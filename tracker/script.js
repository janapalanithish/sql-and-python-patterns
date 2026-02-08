// ===== Daily Consistency Tracker - Script =====
// Uses API for data persistence (fallback to localStorage)

const API_BASE = '/api';

document.addEventListener('DOMContentLoaded', () => {
    const TOTAL_TASKS = 6;
    const TASK_NAMES = ['dbms', 'python', 'patterns', 'scuttle', 'git', 'aptitude'];

    // DOM Elements
    const taskCards = document.querySelectorAll('.task-card');
    const progressBar = document.getElementById('progressBar');
    const progressPercent = document.getElementById('progressPercent');
    const completedCount = document.getElementById('completedCount');
    const streakCount = document.getElementById('streakCount');
    const completionOverlay = document.getElementById('completionOverlay');
    const currentTimeEl = document.getElementById('currentTime');
    const currentDateEl = document.getElementById('currentDate');
    const backendStatusEl = document.getElementById('backendStatus');

    // State
    let tasks = [];
    let streak = { streak_count: 0, longest_streak: 0, last_completion_date: null };

    // Initialize
    init();

    async function init() {
        updateTime();
        setInterval(updateTime, 60000);
        updateDate();
        checkBackendHealth();
        await loadTasksFromAPI();
        await loadStreakFromAPI();
        renderTasks();
        updateProgress();
        bindEvents();
    }

    /**
     * Check backend health endpoint and update status indicator
     * Shows green dot if connected, red if unavailable
     */
    async function checkBackendHealth() {
        if (!backendStatusEl) return;
        
        try {
            const response = await fetch(`${API_BASE}/health`, { 
                method: 'GET',
                timeout: 3000 
            });
            
            if (response.ok) {
                backendStatusEl.classList.add('connected');
                backendStatusEl.classList.remove('disconnected');
                backendStatusEl.title = 'Backend connected';
            } else {
                backendStatusEl.classList.add('disconnected');
                backendStatusEl.classList.remove('connected');
                backendStatusEl.title = 'Backend error';
            }
        } catch (err) {
            backendStatusEl.classList.add('disconnected');
            backendStatusEl.classList.remove('connected');
            backendStatusEl.title = 'Backend unavailable';
        }
    }

    // ===== API Functions =====

    /**
     * Fetch wrapper with comprehensive error handling
     * @param {string} url - API endpoint
     * @param {Object} options - Fetch options
     * @returns {Object|null} Response data or null on failure
     */
    async function apiFetch(url, options = {}) {
        try {
            const response = await fetch(url, {
                ...options,
                headers: {
                    'Content-Type': 'application/json',
                    ...options.headers
                }
            });

            // Handle non-200 responses
            if (!response.ok) {
                const errorData = await response.json().catch(() => ({}));
                const errorMessage = errorData.error || `HTTP ${response.status} error`;
                console.warn(`API Error (${response.status}):`, errorMessage);
                return { success: false, error: errorMessage };
            }

            // Parse JSON response
            const data = await response.json();
            return data;

        } catch (err) {
            // Network failure or JSON parsing error
            console.warn(`API request failed: ${url}`, err.message);
            return null;
        }
    }

    async function loadTasksFromAPI() {
        const data = await apiFetch(`${API_BASE}/tasks`);

        if (data && data.success && Array.isArray(data.tasks)) {
            // Map API data to array format [false, false, ...]
            tasks = data.tasks.map(t => t.completed === 1);
        } else {
            // Fallback to localStorage on API failure
            console.warn('API tasks fetch failed, using localStorage');
            tasks = loadTasksFromLocal();
        }
    }

    async function loadStreakFromAPI() {
        const data = await apiFetch(`${API_BASE}/streak`);

        if (data && data.success && data.streak) {
            streak = {
                streak_count: data.streak.streak_count || 0,
                longest_streak: data.streak.longest_streak || 0,
                last_completion_date: data.streak.last_completion_date || null
            };
        } else {
            // Fallback to localStorage on API failure
            console.warn('API streak fetch failed, using localStorage');
            streak = loadStreakFromLocal();
        }
        updateStreakDisplay();
    }

    async function toggleTaskOnAPI(taskName, completed) {
        const data = await apiFetch(`${API_BASE}/tasks/${taskName}/toggle`, {
            method: 'POST',
            body: JSON.stringify({ completed })
        });

        if (data && data.success) {
            // Optionally update streak from response if all completed
            if (data.streak) {
                streak = {
                    streak_count: data.streak.streak_count || streak.streak_count,
                    longest_streak: data.streak.longest_streak || streak.longest_streak,
                    last_completion_date: data.streak.last_completion_date || streak.last_completion_date
                };
                updateStreakDisplay();
            }
            return true;
        } else {
            console.warn(`Failed to toggle task '${taskName}':`, data?.error || 'Unknown error');
            return false;
        }
    }

    // ===== LocalStorage Fallbacks =====

    /**
     * Load tasks from localStorage using consistent YYYY-MM-DD date format
     * @returns {Array} Array of boolean task completion states
     */
    function loadTasksFromLocal() {
        const stored = localStorage.getItem('dailyTracker');
        if (stored) {
            try {
                const data = JSON.parse(stored);
                const today = getLocalDateString();
                if (data.date === today && Array.isArray(data.tasks)) {
                    return data.tasks;
                }
            } catch (err) {
                console.warn('Failed to parse localStorage tasks:', err.message);
            }
        }
        return Array(TOTAL_TASKS).fill(false);
    }

    /**
     * Load streak from localStorage using consistent YYYY-MM-DD date format
     * @returns {Object} Streak data object
     */
    function loadStreakFromLocal() {
        const stored = localStorage.getItem('dailyStreak');
        if (stored) {
            try {
                const data = JSON.parse(stored);
                const today = getLocalDateString();
                const yesterday = getLocalDateString(-1);
                // Only valid if lastDate is today or yesterday
                if (data.lastDate === today || data.lastDate === yesterday) {
                    return { 
                        streak_count: data.count || 0, 
                        longest_streak: data.count || 0,
                        last_completion_date: data.lastDate 
                    };
                }
            } catch (err) {
                console.warn('Failed to parse localStorage streak:', err.message);
            }
        }
        return { streak_count: 0, longest_streak: 0, last_completion_date: null };
    }

    function saveTasksLocal(tasks) {
        try {
            const data = {
                date: getLocalDateString(),
                tasks: tasks
            };
            localStorage.setItem('dailyTracker', JSON.stringify(data));
        } catch (err) {
            console.warn('Failed to save tasks to localStorage:', err.message);
        }
    }

    function saveStreakLocal(count) {
        try {
            const data = {
                count: count,
                lastDate: getLocalDateString()
            };
            localStorage.setItem('dailyStreak', JSON.stringify(data));
        } catch (err) {
            console.warn('Failed to save streak to localStorage:', err.message);
        }
    }

    // ===== Date Utilities =====

    /**
     * Get date string in YYYY-MM-DD format using local timezone
     * @param {number} offsetDays - Number of days to add (positive) or subtract (negative)
     * @returns {string} Date in YYYY-MM-DD format
     */
    function getLocalDateString(offsetDays = 0) {
        const date = new Date();
        date.setDate(date.getDate() + offsetDays);
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    // ===== Time & Date =====

    function updateTime() {
        const now = new Date();
        const hours = now.getHours();
        const minutes = now.getMinutes().toString().padStart(2, '0');
        const h = hours > 12 ? hours - 12 : hours === 0 ? 12 : hours;
        currentTimeEl.textContent = `${h}:${minutes}`;

        // Update greeting based on time
        const greetingSub = document.querySelector('.greeting-sub');
        if (hours < 12) {
            greetingSub.textContent = 'Good Morning 👋';
        } else if (hours < 17) {
            greetingSub.textContent = 'Good Afternoon 👋';
        } else {
            greetingSub.textContent = 'Good Evening 👋';
        }
    }

    function updateDate() {
        const now = new Date();
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        currentDateEl.textContent = now.toLocaleDateString('en-US', options);
    }

    // ===== Rendering =====

    function renderTasks() {
        taskCards.forEach((card, index) => {
            if (tasks[index]) {
                card.classList.add('completed');
            } else {
                card.classList.remove('completed');
            }
        });
    }

    async function updateProgress() {
        const completed = tasks.filter(Boolean).length;
        const percent = Math.round((completed / TOTAL_TASKS) * 100);

        progressBar.style.width = `${percent}%`;
        progressPercent.textContent = `${percent}%`;
        completedCount.textContent = completed;

        // Check all complete
        if (completed === TOTAL_TASKS) {
            setTimeout(() => showCompletion(), 600);
            await updateStreak();
        }
    }

    function updateStreakDisplay() {
        streakCount.textContent = streak.streak_count || 0;
    }

    // ===== Streak Calculation Logic =====
    /**
     * Updates the daily streak when all tasks are completed
     * 
     * Streak Rules:
     * 1. Streak only updates when last_completion_date != today (prevents double counting)
     * 2. First-ever completion: streak = 1
     * 3. Yesterday was completed: streak continues (increment by 1)
     * 4. Missed a day (or more): streak resets to 1
     * 
     * Edge Cases Handled:
     * - Multiple completions same day: Only first completion increments streak
     * - Completing tasks out of order: Order doesn't matter, only all-or-nothing
     * - Timezone boundaries: Uses local date for consistency
     */
    async function updateStreak() {
        const today = getLocalDateString();
        const yesterday = getLocalDateString(-1);
        
        // Only update if we haven't already counted today
        if (streak.last_completion_date === today) {
            return; // Already counted today's streak
        }
        
        let newStreak;
        
        if (streak.last_completion_date === null) {
            // First completion ever
            newStreak = 1;
        } else if (streak.last_completion_date === yesterday) {
            // Continued from yesterday
            newStreak = (streak.streak_count || 0) + 1;
        } else {
            // Missed at least one day - reset to 1
            newStreak = 1;
        }
        
        // Update state
        streak.streak_count = newStreak;
        streak.last_completion_date = today;
        
        // Persist to localStorage
        saveStreakLocal(newStreak);
        updateStreakDisplay();
    }

    // ===== Events =====

    function bindEvents() {
        taskCards.forEach((card, index) => {
            card.addEventListener('click', () => toggleTask(index));
        });

        completionOverlay.addEventListener('click', () => {
            completionOverlay.classList.remove('show');
        });
    }

    async function toggleTask(index) {
        const taskName = TASK_NAMES[index];
        
        tasks[index] = !tasks[index];
        
        // Save locally as backup (always succeeds)
        saveTasksLocal(tasks);
        
        // Toggle on API (best effort)
        await toggleTaskOnAPI(taskName, tasks[index]);

        const card = taskCards[index];
        if (tasks[index]) {
            card.classList.add('completed');
            if (navigator.vibrate) {
                navigator.vibrate(10);
            }
        } else {
            card.classList.remove('completed');
        }

        await updateProgress();
    }

    function showCompletion() {
        completionOverlay.classList.add('show');
        setTimeout(() => {
            completionOverlay.classList.remove('show');
        }, 3000);
    }
});
