#!/bin/bash
# trigger-pr-review.sh
# Helper script to detect if a PR-related command was run
# Used by hooks.json PostToolUse hook

COMMAND="$1"

if echo "$COMMAND" | grep -qE "(gh pr create|git push)"; then
  echo "PR_REVIEW_TRIGGERED=true"
  exit 0
else
  echo "PR_REVIEW_TRIGGERED=false"
  exit 0
fi
