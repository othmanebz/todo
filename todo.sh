#!/bin/sh

TODO_FILE="todo.txt"
DELIM="|"


generate_id() {
  date +%s%N
}


create_task() {
  echo "Enter title:"
  read title
  if [ -z "$title" ]; then
    echo "Title is required" >&2
    return
  fi

  echo "Enter description (optional):"
  read description
  echo "Enter location (optional):"
  read location
  echo "Enter due date (YYYY-MM-DD) (required):"
  read due_date
  if [ -z "$due_date" ]; then
    echo "Due date is required" >&2
    return
  fi
  echo "Enter due time (HH:MM) (optional):"
  read due_time

  id=$(generate_id)
  completion_marker="N"
  echo "${id}${DELIM}${title}${DELIM}${description}${DELIM}${location}${DELIM}${due_date}${DELIM}${due_time}${DELIM}${completion_marker}" >> $TODO_FILE
  echo "Task created with ID: $id"
}
update_task() {
  echo "Enter task ID to update:"
  read id
  if ! grep -q "^${id}${DELIM}" $TODO_FILE; then
    echo "Task ID not found" >&2
    return
  fi

  echo "Enter new title (leave blank to keep current):"
  read title
  echo "Enter new description (leave blank to keep current):"
  read description
  echo "Enter new location (leave blank to keep current):"
  read location
  echo "Enter new due date (YYYY-MM-DD) (leave blank to keep current):"
  read due_date
  echo "Enter new due time (HH:MM) (leave blank to keep current):"
  read due_time
  echo "Enter completion marker (Y/N) (leave blank to keep current):"
  read completion_marker

  awk -F"${DELIM}" -v id="$id" -v title="$title" -v desc="$description" -v loc="$location" -v date="$due_date" -v time="$due_time" -v comp="$completion_marker" -v OFS="${DELIM}" '
  $1 == id {
    if (title != "") $2 = title;
    if (desc != "") $3 = desc;
    if (loc != "") $4 = loc;
    if (date != "") $5 = date;
    if (time != "") $6 = time;
    if (comp != "") $7 = comp;
  }
  { print }
  ' $TODO_FILE > ${TODO_FILE}.tmp && mv ${TODO_FILE}.tmp $TODO_FILE
  echo "Task updated"
}


delete_task() {
  echo "Enter task ID to delete:"
  read id
  if ! grep -q "^${id}${DELIM}" $TODO_FILE; then
    echo "Task ID not found" >&2
    return
  fi

  grep -v "^${id}${DELIM}" $TODO_FILE > ${TODO_FILE}.tmp && mv ${TODO_FILE}.tmp $TODO_FILE
  echo "Task deleted"
}

show_task() {
  echo "Enter task ID to show:"
  read id
  if ! grep -q "^${id}${DELIM}" $TODO_FILE; then
    echo "Task ID not found" >&2
    return
  fi

  grep "^${id}${DELIM}" $TODO_FILE | awk -F"${DELIM}" '{
    printf "ID: %s\nTitle: %s\nDescription: %s\nLocation: %s\nDue Date: %s\nDue Time: %s\nCompleted: %s\n", $1, $2, $3, $4, $5, $6, $7
  }'
}


list_tasks() {
  echo "Enter date to list tasks (YYYY-MM-DD):"
  read date
  if [ -z "$date" ]; then
    date=$(date +%Y-%m-%d)
  fi

  echo "Tasks for $date:"
  echo "Completed:"
  grep "${DELIM}${date}${DELIM}.*${DELIM}Y$" $TODO_FILE | awk -F"${DELIM}" '{
    printf "ID: %s | Title: %s\n", $1, $2
  }'

  echo "Uncompleted:"
  grep "${DELIM}${date}${DELIM}.*${DELIM}N$" $TODO_FILE | awk -F"${DELIM}" '{
    printf "ID: %s | Title: %s\n", $1, $2
  }'
}


search_task() {
  echo "Enter title to search for:"
  read title
  grep "${DELIM}${title}" $TODO_FILE | awk -F"${DELIM}" '{
    printf "ID: %s | Title: %s\n", $1, $2
  }'
}

if [ $# -eq 0 ]; then
  list_tasks
else
  case $1 in
    -c)
      create_task
      ;;
    -u)
      update_task
      ;;
    -d)
      delete_task
      ;;
    -s)
      show_task
      ;;
    -l)
      list_tasks
      ;;
    -f)
      search_task
      ;;
    *)
      echo "Unknown command: $1" >&2
      exit 1
      ;;
  esac
fi
