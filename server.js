// Daily Consistency Tracker - Backend Server
// Express.js server with API endpoints for task tracking

const express = require('express');
const cors = require('cors');
const path = require('path');
const db = require('./database');

const app = express();
const PORT = process.env.PORT || 3000;

// Allowed task names for validation
const ALLOWED_TASKS = ['dbms', 'python', 'patterns', 'scuttle', 'git', 'aptitude'];

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'tracker')));

// ===== Utility Functions =====

// Validate task name
function isValidTaskName(taskName) {
    return typeof taskName === 'string' && 
           ALLOWED_TASKS.includes(taskName) &&
           /^[a-z]+$/.test(taskName);
}

// Validate days parameter
function isValidDays(days) {
    const num = parseInt(days);
    return Number.isInteger(num) && num > 0 && num <= 365;
}

// Error response helper
function sendError(res, status, message, details = null) {
    const errorResponse = { 
        success: false, 
        error: message 
    };
    if (details && process.env.NODE_ENV !== 'production') {
        errorResponse.details = details;
    }
    res.status(status).json(errorResponse);
}

// ===== API Routes =====

// GET /api/tasks - Get all tasks and their completion status for today
app.get('/api/tasks', async (req, res) => {
    try {
        const tasks = await db.getTodayTasks();
        res.json({
            success: true,
            date: db.getTodayDate(),
            tasks: tasks
        });
    } catch (err) {
        console.error('Error fetching tasks:', err.message);
        sendError(res, 500, 'Failed to fetch tasks', err.message);
    }
});

// POST /api/tasks/:taskName/toggle - Toggle task completion
app.post('/api/tasks/:taskName/toggle', async (req, res) => {
    try {
        const { taskName } = req.params;
        const { completed } = req.body;

        // Validate task name
        if (!isValidTaskName(taskName)) {
            return sendError(res, 400, 'Invalid task name', `Task '${taskName}' is not recognized`);
        }

        // Validate completed body field
        if (completed === undefined || completed === null) {
            return sendError(res, 400, 'Missing required field: completed');
        }

        if (typeof completed !== 'boolean') {
            return sendError(res, 400, 'Invalid completed value', 'Must be a boolean (true/false)');
        }

        const result = await db.toggleTask(taskName, completed);
        
        // Check if all tasks are completed and update streak
        const allTasks = await db.getTodayTasks();
        const allCompleted = allTasks.every(t => t.completed === 1);
        
        let streakUpdate = null;
        if (allCompleted && completed) {
            streakUpdate = await db.updateStreak();
        }
        
        res.json({
            success: true,
            task: result,
            allCompleted,
            streak: streakUpdate
        });
    } catch (err) {
        console.error('Error toggling task:', err.message);
        
        // Handle constraint violations gracefully
        if (err.message && err.message.includes('UNIQUE constraint failed')) {
            return sendError(res, 409, 'Task completion record already exists');
        }
        if (err.message && err.message.includes('FOREIGN KEY constraint failed')) {
            return sendError(res, 400, 'Invalid task reference');
        }
        
        sendError(res, 500, 'Failed to toggle task', err.message);
    }
});

// GET /api/streak - Get current streak data
app.get('/api/streak', async (req, res) => {
    try {
        const streak = await db.getStreak();
        
        // Ensure streak data is properly initialized
        if (!streak) {
            return res.json({
                success: true,
                streak: { streak_count: 0, longest_streak: 0, last_completion_date: null }
            });
        }
        
        res.json({ success: true, streak });
    } catch (err) {
        console.error('Error fetching streak:', err.message);
        sendError(res, 500, 'Failed to fetch streak', err.message);
    }
});

// GET /api/history - Get completion history
app.get('/api/history', async (req, res) => {
    try {
        const { days } = req.query;
        
        // Validate days parameter
        if (days !== undefined && !isValidDays(days)) {
            return sendError(res, 400, 'Invalid days parameter', 'Must be an integer between 1 and 365');
        }
        
        const daysNum = parseInt(days) || 30;
        const history = await db.getCompletionHistory(daysNum);
        res.json({ success: true, history, days: daysNum });
    } catch (err) {
        console.error('Error fetching history:', err.message);
        sendError(res, 500, 'Failed to fetch history', err.message);
    }
});

// GET /api/health - Health check endpoint
app.get('/api/health', (req, res) => {
    res.json({ 
        success: true, 
        status: 'healthy',
        timestamp: new Date().toISOString()
    });
});

// Serve frontend for all other routes
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'tracker', 'index.html'));
});

// Start server
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
    console.log('API Endpoints:');
    console.log('  GET  /api/tasks           - Get today\'s tasks');
    console.log('  POST /api/tasks/:name/toggle - Toggle task completion');
    console.log('  GET  /api/streak          - Get streak data');
    console.log('  GET  /api/history          - Get completion history');
    console.log('  GET  /api/health           - Health check');
});

// Export for testing
module.exports = app;
