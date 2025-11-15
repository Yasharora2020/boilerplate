#!/bin/bash

# Pomodoro Timer Status Line Script with Git, CWD, and Model Info
# Displays comprehensive session info in the status line

TIMER_FILE="$HOME/.claude-pomodoro-timer"
TIMER_STATE_FILE="$HOME/.claude-pomodoro-state"

# Read the session data from stdin
read -r session_json

# Extract session info from JSON - handle model as object with display_name
model=$(echo "$session_json" | jq -r '.model.display_name // .model.name // .model // .modelName // .name // empty' 2>/dev/null)
if [[ -z "$model" ]]; then
    model="Unknown"
fi
cwd=$(echo "$session_json" | jq -r '.cwd // .currentWorkingDirectory // empty' 2>/dev/null)
if [[ -z "$cwd" ]]; then
    cwd=$(pwd)
fi

# Get git branch if in a git repo
git_branch=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n "$git_branch" ]]; then
        git_branch=" 🌿 $git_branch"
    fi
fi

# Get directory name (just the folder, not full path)
dir_name=$(basename "$cwd")

# Get the current time
current_time=$(date +%s)

# Initialize or read timer state
if [[ ! -f "$TIMER_STATE_FILE" ]]; then
    # No timer started yet - show status without timer
    printf "📂 %s%s | 🤖 %s" "$dir_name" "$git_branch" "$model"
    exit 0
fi

# Read timer start time
start_time=$(cat "$TIMER_STATE_FILE" 2>/dev/null)

# Check if timer should be reset (if the file doesn't exist)
if [[ ! -f "$TIMER_FILE" ]]; then
    rm -f "$TIMER_STATE_FILE"
    printf "📂 %s%s | 🤖 %s" "$dir_name" "$git_branch" "$model"
    exit 0
fi

# Calculate elapsed time in seconds
elapsed=$((current_time - start_time))
total_seconds=$((25 * 60))  # 25 minutes

# Check if timer is complete
if [[ $elapsed -ge $total_seconds ]]; then
    rm -f "$TIMER_FILE" "$TIMER_STATE_FILE"
    printf "🍅 ✅ Complete! | 📂 %s%s | 🤖 %s" "$dir_name" "$git_branch" "$model"
    exit 0
fi

# Calculate remaining time
remaining=$((total_seconds - elapsed))
minutes=$((remaining / 60))
seconds=$((remaining % 60))

# Create a simple progress bar (10 segments)
progress=$((elapsed * 10 / total_seconds))
bar=""
for ((i=0; i<progress; i++)); do
    bar+="█"
done
for ((i=progress; i<10; i++)); do
    bar+="░"
done

# Format complete status line with all info
printf "🍅 %02d:%02d [%s] | 📂 %s%s | 🤖 %s" "$minutes" "$seconds" "$bar" "$dir_name" "$git_branch" "$model"