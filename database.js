// Database utility module for Daily Consistency Tracker
// Uses SQLite for simple file-based database

const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const DB_PATH = path.join(__dirname, 'tracker.db');

// Create database connection
const db = new sqlite3.Database(DB_PATH, (err) => {
    if (err) {
        console.error('Error opening database:', err.message);
    } else {
        console.log('Connected to SQLite database:', DB_PATH);
        initializeDatabase();
    }
});

// Initialize database tables
function initializeDatabase() {
    db.serialize(() => {
        // Create daily_tasks table
        db.run(`CREATE TABLE IF NOT EXISTS daily_tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task_name TEXT NOT NULL UNIQUE,
            task_index INTEGER NOT NULL UNIQUE,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )`);

        // Create task_completions table
        db.run(`CREATE TABLE IF NOT EXISTS task_completions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task_name TEXT NOT NULL,
            task_index INTEGER NOT NULL,
            date DATE NOT NULL,
            completed INTEGER DEFAULT 0,
            completed_at DATETIME,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            UNIQUE(task_name, date)
        )`);

        // Create streak_data table
        db.run(`CREATE TABLE IF NOT EXISTS streak_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            streak_count INTEGER DEFAULT 0,
            last_completion_date DATE,
            longest_streak INTEGER DEFAULT 0,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )`);

        // Insert default tasks if not exists
        const tasks = [
            { name: 'dbms', index: 0 },
            { name: 'python', index: 1 },
            { name: 'patterns', index: 2 },
            { name: 'scuttle', index: 3 },
            { name: 'git', index: 4 },
            { name: 'aptitude', index: 5 }
        ];

        const insertTask = db.prepare('INSERT OR IGNORE INTO daily_tasks (task_name, task_index) VALUES (?, ?)');
        tasks.forEach(task => {
            insertTask.run(task.name, task.index);
        });
        insertTask.finalize();

        // Initialize streak data if not exists
        db.run('INSERT OR IGNORE INTO streak_data (id, streak_count, longest_streak) VALUES (1, 0, 0)');
    });
}

// ===== Date Utilities =====

/**
 * Get today's date in YYYY-MM-DD format using local timezone
 * This ensures consistency between server and client date handling
 * @returns {string} Today's date in YYYY-MM-DD format
 */
function getTodayDate() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

/**
 * Get yesterday's date in YYYY-MM-DD format
 * Used for streak continuity checks
 * @returns {string} Yesterday's date in YYYY-MM-DD format
 */
function getYesterdayDate() {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const year = yesterday.getFullYear();
    const month = String(yesterday.getMonth() + 1).padStart(2, '0');
    const day = String(yesterday.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

// ===== Task Operations =====

/**
 * Get all tasks completion status for today
 * @returns {Promise<Array>} Array of task objects with completion status
 */
function getTodayTasks() {
    return new Promise((resolve, reject) => {
        const today = getTodayDate();
        const query = `
            SELECT t.task_name, t.task_index, 
                   COALESCE(c.completed, 0) as completed,
                   c.completed_at
            FROM daily_tasks t
            LEFT JOIN task_completions c ON t.task_name = c.task_name AND c.date = ?
            ORDER BY t.task_index
        `;
        
        db.all(query, [today], (err, rows) => {
            if (err) {
                reject(err);
            } else {
                resolve(rows);
            }
        });
    });
}

/**
 * Toggle task completion for today
 * Uses UPSERT pattern (INSERT OR UPDATE) to handle multiple toggles
 * @param {string} taskName - The task identifier
 * @param {boolean} completed - Whether task is completed
 * @returns {Promise<Object>} Result object with task details
 */
function toggleTask(taskName, completed) {
    return new Promise((resolve, reject) => {
        const today = getTodayDate();
        const completedAt = completed ? new Date().toISOString() : null;
        
        const query = `
            INSERT INTO task_completions (task_name, task_index, date, completed, completed_at)
            VALUES (?, (SELECT task_index FROM daily_tasks WHERE task_name = ?), ?, ?, ?)
            ON CONFLICT(task_name, date) DO UPDATE SET
                completed = excluded.completed,
                completed_at = excluded.completed_at
        `;
        
        db.run(query, [taskName, taskName, today, completed ? 1 : 0, completedAt], function(err) {
            if (err) {
                reject(err);
            } else {
                resolve({ taskName, completed, date: today });
            }
        });
    });
}

// ===== Streak Operations =====

/**
 * Get current streak data from database
 * @returns {Promise<Object>} Streak data object
 */
function getStreak() {
    return new Promise((resolve, reject) => {
        db.get('SELECT streak_count, last_completion_date, longest_streak FROM streak_data WHERE id = 1', (err, row) => {
            if (err) {
                reject(err);
            } else {
                resolve(row);
            }
        });
    });
}

/**
 * Update streak when all tasks are completed
 * 
 * Streak Calculation Logic:
 * 1. Only updates when last_completion_date is NOT today (prevents duplicate increments)
 * 2. If last_completion_date is null (first ever) → streak = 1
 * 3. If last_completion_date is yesterday → streak continues (increment by 1)
 * 4. If last_completion_date is neither today nor yesterday → streak resets to 1
 * 5. Longest streak is updated if current streak exceeds it
 * 
 * @returns {Promise<Object>} Updated streak data
 */
function updateStreak() {
    return new Promise((resolve, reject) => {
        const today = getTodayDate();
        const yesterday = getYesterdayDate();
        
        db.get('SELECT streak_count, last_completion_date, longest_streak FROM streak_data WHERE id = 1', (err, row) => {
            if (err) {
                reject(err);
                return;
            }
            
            // Calculate new streak value
            // Case 1: First completion ever (null last_date) → streak = 1
            // Case 2: Yesterday → streak continues (increment)
            // Case 3: Other date (missed day) → streak resets to 1
            let newStreak;
            
            if (row.last_completion_date === null) {
                // First completion ever
                newStreak = 1;
            } else if (row.last_completion_date === yesterday) {
                // Continued streak from yesterday
                newStreak = row.streak_count + 1;
            } else {
                // Streak broken (missed at least one day)
                newStreak = 1;
            }
            
            // Update longest streak if needed
            const longestStreak = Math.max(newStreak, row.longest_streak);
            
            db.run(`UPDATE streak_data SET 
                    streak_count = ?, 
                    last_completion_date = ?,
                    longest_streak = ?,
                    updated_at = CURRENT_TIMESTAMP
                    WHERE id = 1`,
                [newStreak, today, longestStreak],
                function(err) {
                    if (err) {
                        reject(err);
                    } else {
                        resolve({ 
                            streak_count: newStreak, 
                            longest_streak: longestStreak,
                            last_completion_date: today 
                        });
                    }
                });
        });
    });
}

// ===== History Operations =====

/**
 * Get completion history for analytics
 * @param {number} days - Number of days to retrieve (default 30)
 * @returns {Promise<Array>} Array of daily completion records
 */
function getCompletionHistory(days = 30) {
    return new Promise((resolve, reject) => {
        const query = `
            SELECT date, 
                   COUNT(*) as total_tasks,
                   SUM(completed) as completed_tasks,
                   (COUNT(*) * SUM(completed)) / 100.0 as completion_rate
            FROM (
                SELECT t.task_name, c.date, COALESCE(c.completed, 0) as completed
                FROM daily_tasks t
                LEFT JOIN task_completions c ON t.task_name = c.task_name
                WHERE c.date >= date('now', ?)
            )
            GROUP BY date
            ORDER BY date DESC
        `;
        
        db.all(query, [`-${days} days`], (err, rows) => {
            if (err) {
                reject(err);
            } else {
                resolve(rows);
            }
        });
    });
}

module.exports = {
    db,
    getTodayTasks,
    toggleTask,
    getStreak,
    updateStreak,
    getCompletionHistory,
    getTodayDate,
    getYesterdayDate
};
