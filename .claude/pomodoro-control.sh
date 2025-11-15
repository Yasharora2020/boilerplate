#!/bin/bash

# Pomodoro Timer Control Script
# Usage: source this script or run commands directly

TIMER_FILE="$HOME/.claude-pomodoro-timer"
TIMER_STATE_FILE="$HOME/.claude-pomodoro-state"

pomodoro_start() {
    touch "$TIMER_FILE"
    date +%s > "$TIMER_STATE_FILE"
    echo "✅ Pomodoro timer started! (25 minutes)"
}

pomodoro_stop() {
    rm -f "$TIMER_FILE" "$TIMER_STATE_FILE"
    echo "⏹️  Pomodoro timer stopped"
}

pomodoro_status() {
    if [[ ! -f "$TIMER_FILE" ]]; then
        echo "🍅 Pomodoro timer is not running"
        return 0
    fi

    current_time=$(date +%s)
    start_time=$(cat "$TIMER_STATE_FILE" 2>/dev/null)

    if [[ -z "$start_time" ]]; then
        echo "🍅 Pomodoro timer is not running"
        return 0
    fi

    elapsed=$((current_time - start_time))
    total_seconds=$((25 * 60))

    if [[ $elapsed -ge $total_seconds ]]; then
        echo "✅ Pomodoro session complete!"
        return 0
    fi

    remaining=$((total_seconds - elapsed))
    minutes=$((remaining / 60))
    seconds=$((remaining % 60))

    printf "⏱️  Time remaining: %02d:%02d\n" "$minutes" "$seconds"
}

# Handle command line arguments
case "${1:-}" in
    start)
        pomodoro_start
        ;;
    stop)
        pomodoro_stop
        ;;
    status)
        pomodoro_status
        ;;
    *)
        echo "Usage: $0 {start|stop|status}"
        echo ""
        echo "Examples:"
        echo "  $0 start   - Start a 25-minute Pomodoro session"
        echo "  $0 stop    - Stop the current Pomodoro session"
        echo "  $0 status  - Check remaining time"
        ;;
esac