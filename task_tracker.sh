#!/bin/bash

# Task Tracker Utility

# Configuration
TASK_DIR="$HOME/.task_tracker"
TASKS_FILE="$TASK_DIR/tasks.csv"
HISTORY_FILE="$TASK_DIR/history.csv"

# Ensure task directory exists
mkdir -p "$TASK_DIR"
touch "$TASKS_FILE" "$HISTORY_FILE"

# Function to generate unique task ID
generate_task_id() {
    date +%Y%m%d%H%M%S
}

# Function to add a new task
add_task() {
    clear
    echo "Add New Task"
    read -p "Enter task name: " task_name
    
    if [[ -z "$task_name" ]]; then
        echo "Task name cannot be empty!"
        return 1
    fi

    #task_id=$(generate_task_id)
    #creation_date=$(date "+%Y-%m-%d %H:%M:%S")

    echo "$task_id|$task_name| ---- | ----- " >> "$TASKS_FILE"
    echo "Task added successfully!"
}


start_task(){
    clear
    read -p "Start Task : " task_id_start
    
    if [[ -z "$task_id_start" ]]; then
        echo "Task to be started cannot be empty!"
        return 1
    fi

    creation_date=$(date "+%Y-%m-%d %H:%M:%S")

    sed -i "/^$task_id_start|/s/|[^|]*|/|$creation_date| ---- |Pending/" "$TASKS_FILE"
    echo "Task $task_id_start started."
}

stop_task(){
    clear
    read -p "Stop Task : " task_id_stop
    
    if [[ -z "$task_id_stop" ]]; then
        echo "Task to be stopped cannot be empty!"
        return 1
    fi

    completion_date=$(date "+%Y-%m-%d %H:%M:%S")

    # Retrieve the current line for the specified task ID
    current_line=$(grep "^$task_id_stop|" "$TASKS_FILE")

    if [[ -z "$current_line" ]]; then
        echo "Task ID $task_id_stop not found!"
        return 1
    fi

    # Extract the creation date from the current line
    creation_date=$(echo "$current_line" | cut -d '|' -f 3)

    sed -i "/^$task_id_stop|/s/|[^|]*|[^|]*$/|$creation_date|$completion_date|Completed/" "$TASKS_FILE"
    echo "Task $task_id_stop completed."
}

review_tasks(){
    if [[ ! -f "$TASKS_FILE" ]]; then
        echo "Tasks file not found!"
        return 1
    fi

    echo "ID        TaskName        Started         Stopped         Status"

    while IFS= read -r line; do
        IFS='|' read -r task_id task_name creation_date completion_date status <<< "$line"
        printf "%s\t\t%s\t\t%s\t\t%s\t\t%s\n" "$task_id" "$task_name" "$creation_date" "$completion_date" "$status"
    done < "$TASKS_FILE"
}

# Main menu function
main_menu() {
    while true; do
        clear
        echo "==== Task Tracker ===="
        echo "1. Add Task"
        echo "2. Start Task"
        echo "3. Stop Task"
        echo "4. Review Tasks"
        echo "5. Exit"
        read -p "Choose an option (1-5): " choice

        case $choice in
            1) add_task ;;
            2) start_task ;;
            3) stop_task ;;
            4) review_tasks ;;
            5) exit 0 ;;
            6) echo "Invalid option. Press enter to continue."; read ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

# Entry point
main_menu
