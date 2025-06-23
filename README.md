# Goose Lab - WeAreDev Lab Environment

This is a development environment for WeAreDev Labs using Goose AI. It provides a split-screen interface with a Goose chat on one side and a live preview of your code on the other.

## Prerequisites

- Node.js installed
- Goose AI installed and running (`goose web` should be running on port 8080)
- Git

## Setup

1. Clone this repository:
```bash
git clone https://github.com/blackgirlbytes/goose-lab.git
cd goose-lab
```

2. Install dependencies:
```bash
npm install
```

3. Start the Lab environment:
```bash
./start-Lab.sh
```

## How It Works

1. The environment consists of:
   - A Goose Web interface for AI interaction
   - A live preview of your code
   - A session management system

2. When you start a new Lab:
   - A new session ID is generated
   - Your code files are created in `Labs/{sessionId}/`
   - The preview updates automatically

3. Files Structure:
   - `goose-launcher.html`: Main interface
   - `session-writer.js`: Backend server for session management
   - `start-Lab.sh`: Script to start the environment
   - `Labs/`: Directory containing session-specific code

## Usage

1. Make sure Goose Web is running:
```bash
goose web --port 8080
```

2. In a new terminal, start the Lab environment:
```bash
./start-Lab.sh
```

3. Open http://localhost:3737 in your browser

4. Click "Start New Lab" to begin

## Features

- Real-time preview of your code
- Automatic session management
- Support for HTML, CSS, and JavaScript
- Camera access support for webcam-based Labs
- Dark/Light theme toggle

## Notes

- The preview refreshes automatically when files are updated
- Each session gets its own isolated environment
- Use the "End Lab" button to clear the current session