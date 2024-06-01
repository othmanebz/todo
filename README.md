# TODO Script

This is a simple shell script (`sh`) to manage your todo tasks. The script provides functionalities to create, update, delete, show, list, and search tasks. Each task has a unique identifier, a title, a description, a location, a due date and time, and a completion marker.

## Design Choices

### Data Storage

- **Storage File**: Tasks are stored in a text file named `todo.txt`.
- **Delimiter**: Fields in the file are separated by a delimiter (`|`).
- **Fields**: Each task record contains the following fields:
  - Unique Identifier (generated using `date +%s%N`)
  - Title
  - Description (optional)
  - Location (optional)
  - Due Date (required, format `YYYY-MM-DD`)
  - Due Time (optional, format `HH:MM`)
  - Completion Marker (Y/N)

### Code Organization

- **Functions**:
  - `generate_id`: Generates a unique identifier for each task.
  - `create_task`: Prompts the user for task details and appends the task to the storage file.
  - `update_task`: Updates an existing task based on its ID.
  - `delete_task`: Deletes a task based on its ID.
  - `show_task`: Displays details of a specified task.
  - `list_tasks`: Lists tasks for a specified day, showing completed and uncompleted tasks separately.
  - `search_task`: Searches for tasks matching a title.
- **Main Logic**: The script uses a case statement to handle different command-line options (`-c`, `-u`, `-d`, `-s`, `-l`, `-f`).

### Error Handling

- **Validation**: Ensures required fields (title, due date) are provided.
- **ID Checks**: Validates that the provided task ID exists for update, delete, and show operations.
- **Standard Error**: Error messages are redirected to standard error (`>&2`).

## How to Run the Program

1. **Clone the repository or download the script**:
    ```sh
    git clone <repository-url>
    cd <repository-directory>
    ```

2. **Make the script executable**:
    ```sh
    chmod +x todo
    ```

3. **Run the script with the appropriate options**:

    - **Create a Task**:
        ```sh
        ./todo -c
        ```

    - **Update a Task**:
        ```sh
        ./todo -u
        ```

    - **Delete a Task**:
        ```sh
        ./todo -d
        ```

    - **Show a Task**:
        ```sh
        ./todo -s
        ```

    - **List Tasks**:
        ```sh
        ./todo -l
        ```

    - **Search for a Task**:
        ```sh
        ./todo -f
        ```

### Example Usage

- **Creating a Task**:
    ```sh
    ./todo -c
    ```
    Follow the prompts to enter the task details.

- **Updating a Task**:
    ```sh
    ./todo -u
    ```
    Follow the prompts to update the task details.

- **Deleting a Task**:
    ```sh
    ./todo -d
    ```
    Enter the task ID to delete.

- **Showing a Task**:
    ```sh
    ./todo -s
    ```
    Enter the task ID to show details.

- **Listing Tasks**:
    ```sh
    ./todo -l
    ```
    Enter the date to list tasks (leave blank to list tasks for the current day).

- **Searching for a Task**:
    ```sh
    ./todo -f
    ```
    Enter the title to search for tasks.

## Notes

- Ensure the `todo.txt` file is in the same directory as the script, or modify the `TODO_FILE` variable in the script to point to the correct path.
- The script currently does not support concurrent modifications. Ensure to run the script from a single terminal session to avoid conflicts.
- This script is intended for simple task management and may not handle edge cases or large datasets efficiently.

