-- Daily Consistency Tracker Database Schema
-- SQLite database for storing task completion and streak data

-- Table to store daily task completions
CREATE TABLE IF NOT EXISTS daily_tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    task_name TEXT NOT NULL UNIQUE,
    task_index INTEGER NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table to store user task completions by date
CREATE TABLE IF NOT EXISTS task_completions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    task_name TEXT NOT NULL,
    task_index INTEGER NOT NULL,
    date DATE NOT NULL,
    completed INTEGER DEFAULT 0,
    completed_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(task_name, date)
);

-- Table to store streak data
CREATE TABLE IF NOT EXISTS streak_data (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    streak_count INTEGER DEFAULT 0,
    last_completion_date DATE,
    longest_streak INTEGER DEFAULT 0,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insert default tasks if not exists
INSERT OR IGNORE INTO daily_tasks (task_name, task_index) VALUES
    ('dbms', 0),
    ('python', 1),
    ('patterns', 2),
    ('scuttle', 3),
    ('git', 4),
    ('aptitude', 5);

-- Initialize streak data if not exists
INSERT OR IGNORE INTO streak_data (id, streak_count, longest_streak) VALUES
    (1, 0, 0);
