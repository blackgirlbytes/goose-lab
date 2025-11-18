#!/bin/bash

# Start in the script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Create challenges directory if it doesn't exist
mkdir -p challenges

# Install dependencies if needed
if [ ! -f "node_modules/express/package.json" ]; then
    echo "Installing dependencies..."
    npm init -y >/dev/null 2>&1
    npm install express cors http-proxy-middleware >/dev/null 2>&1
fi

# Start the session writer in the background
node session-writer.js &
SESSION_WRITER_PID=$!

# Start Goose web in the background (using local development version)
/Users/ebonyl/goose/target/debug/goose web --port 8080 --host 127.0.0.1 &
# /Users/ebonyl/goose/target/debug/goose web --port 8080 --host 0.0.0.0 &
GOOSE_PID=$!

# Wait a moment for the servers to start
sleep 2

# Open the launcher from the HTTP server (this fixes iframe cross-origin issues)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Try multiple methods for macOS
    open -a "Google Chrome" "http://localhost:3737/" || \
    open -a "Firefox" "http://localhost:3737/" || \
    open -a "Safari" "http://localhost:3737/" || \
    open "http://localhost:3737/"
    
    # If none worked, provide instructions
    if [ $? -ne 0 ]; then
        echo "Please open this URL in your browser:"
        echo "http://localhost:3737/"
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    xdg-open "http://localhost:3737/"
fi

# Function to clean up on exit
cleanup() {
    echo "Cleaning up..."
    kill $GOOSE_PID 2>/dev/null
    kill $SESSION_WRITER_PID 2>/dev/null
    rm -rf "/tmp/goose_chrome_dev" 2>/dev/null
    exit 0
}

# Set up cleanup on script exit
trap cleanup EXIT

echo "Goose web is running..."
echo "Session writer is running..."
echo "Launcher should open in your browser"
echo "Press Ctrl+C to stop"

# Keep script running
while true; do
    sleep 1
done
