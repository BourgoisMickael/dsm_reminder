#!/bin/sh

# Daily Scrum Meeting Reminder
#
# Helps you remind yourself about what you did the last 
# working day by printing all commit messages

if [[ -z "$DSM_REMINDER_WORKDIR" ]]; then
    echo "Missing environment variable DSM_REMINDER_WORKDIR"
    echo "Edit your shell rc file to add:"
    echo "export DSM_REMINDER_WORKDIR=~/your_workdir"
    exit 1
fi

DAY=$(date +%A)
if [ $DAY == 'Monday' ]; then
    SINCE='3 days'
else
    SINCE='1 day'
fi

GIT_NAME=$(git config user.name)

ls -d1 "$DSM_REMINDER_WORKDIR"/*/.git | while read -r REPO_PATH
do
    cd "$REPO_PATH"
    REPO_NAME=$(echo "$REPO_PATH" | sed "s/\/\.git$//;s/^.*\///")
    LOGS=$(git log --all --author "$GIT_NAME" --format=%s --since "$SINCE")

    if [ ! -z "$LOGS" ]; then
        echo "$REPO_NAME"
        echo "$LOGS" | while read -r LOG_LINE
        do
            echo "\t$LOG_LINE"
        done
    fi
done
