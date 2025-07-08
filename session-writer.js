// session-writer.js
const express = require('express');
const fs = require('fs');
const path = require('path');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// Add security headers for camera access
app.use((req, res, next) => {
    // Required for camera access
    res.setHeader('Feature-Policy', 'camera *');
    res.setHeader('Permissions-Policy', 'camera=*');
    // Security headers
    res.setHeader('Cross-Origin-Embedder-Policy', 'require-corp');
    res.setHeader('Cross-Origin-Opener-Policy', 'same-origin');
    next();
});

// Serve challenge files
app.use('/preview', express.static('challenges'));

// Get current session
app.get('/current-session', (req, res) => {
    try {
        const sessionFile = path.join(__dirname, 'challenges', 'current_session.json');
        if (fs.existsSync(sessionFile)) {
            const data = fs.readFileSync(sessionFile);
            res.json(JSON.parse(data));
        } else {
            res.json({ session_id: null });
        }
    } catch (error) {
        console.error('Error reading session:', error);
        res.status(500).json({ error: error.message });
    }
});

// Update session
app.post('/update-session', (req, res) => {
    try {
        const sessionId = req.body.sessionId;
        const sessionData = JSON.stringify({ session_id: sessionId }, null, 2);
        
        // Get absolute path to challenges directory
        const challengesDir = path.join(__dirname, 'challenges');
        const sessionFile = path.join(challengesDir, 'current_session.json');
        
        // Make sure challenges directory exists
        if (!fs.existsSync(challengesDir)) {
            console.log('Creating challenges directory...');
            fs.mkdirSync(challengesDir, { recursive: true });
        }
        
        // Write file
        console.log('Writing to:', sessionFile);
        fs.writeFileSync(sessionFile, sessionData);
        console.log('Successfully updated session ID to:', sessionId);
        
        res.json({ success: true });
    } catch (error) {
        console.error('Error updating session:', error);
        res.status(500).json({ error: error.message });
    }
});

// Check if challenge files exist
app.get('/check-files', (req, res) => {
    try {
        const sessionId = req.query.sessionId;
        if (!sessionId) {
            return res.json({ exists: false });
        }

        const challengeDir = path.join(__dirname, 'challenges', sessionId);
        const files = ['index.html', 'style.css', 'script.js'];
        const exists = fs.existsSync(challengeDir) && 
                      files.every(file => fs.existsSync(path.join(challengeDir, file)));
        
        res.json({ exists });
    } catch (error) {
        console.error('Error checking files:', error);
        res.status(500).json({ error: error.message });
    }
});

const port = 3737;
app.listen(port, () => {
    console.log(`Session writer running on port ${port}`);
    console.log('Working directory:', __dirname);
});