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
    npm install express cors >/dev/null 2>&1
fi

# Start the session writer in the background
node session-writer.js &
SESSION_WRITER_PID=$!

# Start Goose web in the background
goose web --port 8080 --host 127.0.0.1 &
GOOSE_PID=$!

# Wait a moment for the servers to start
sleep 2

# Open the launcher in the default browser
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Try multiple methods for macOS
    open -a "Google Chrome" "file://$SCRIPT_DIR/goose-launcher.html" || \
    open -a "Firefox" "file://$SCRIPT_DIR/goose-launcher.html" || \
    open -a "Safari" "file://$SCRIPT_DIR/goose-launcher.html" || \
    open "file://$SCRIPT_DIR/goose-launcher.html"
    
    # If none worked, provide instructions
    if [ $? -ne 0 ]; then
        echo "Please open this URL in your browser:"
        echo "file://$SCRIPT_DIR/goose-launcher.html"
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    xdg-open "file://$SCRIPT_DIR/goose-launcher.html"
fi

# Function to clean up on exit
cleanup() {
    echo "Cleaning up..."
    kill $GOOSE_PID 2>/dev/null
    kill $SESSION_WRITER_PID 2>/dev/null
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