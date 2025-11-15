#!/bin/bash

# Log bash commands executed through Claude Code

# Get the command from stdin
COMMAND=$(cat | jq -r '.tool_input.command' 2>/dev/null)

# Define log file in the current working directory
LOG_FILE="bash-commands.log"

# Log the command with timestamp
if [ -n "$COMMAND" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $COMMAND" >> "$LOG_FILE"
fi

exit 0
