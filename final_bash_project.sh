#!/bin/bash

echo "Starting the script..."

DB_DIR="./databases"
mkdir -p "$DB_DIR"
echo "Database directory set up at $DB_DIR"

function main_menu {
    while true; do
        echo "Main Menu:"
        echo "1. Create Database"
        echo "2. List Databases"
        echo "3. Connect To Database"
        echo "4. Drop Database"
        echo "5. Exit"
        read -p "Choose an option: " choice

        case $choice in
            1) create_database ;;
            2) list_databases ;;
            3) connect_to_database ;;
            4) drop_database ;;
            5) exit 0 ;;
            *) echo "Invalid option, please try again." ;;
        esac
    done
}

function create_database {
    read -p "Enter database name: " dbname
    if [ -d "$DB_DIR/$dbname" ]; then
        echo "Database already exists."
    else
        mkdir "$DB_DIR/$dbname"
        echo "Database '$dbname' created."
    fi
}

function list_databases {
    echo "Databases:"
    ls "$DB_DIR"
}

function connect_to_database {
    read -p "Enter database name to connect: " dbname
    if [ -d "$DB_DIR/$dbname" ]; then
        connected_database="$DB_DIR/$dbname"
        echo "Connected to database '$dbname'."
        table_menu
    else
        echo "Database does not exist."
    fi
}

function drop_database {
    read -p "Enter database name to drop: " dbname
    if [ -d "$DB_DIR/$dbname" ]; then
        rm -r "$DB_DIR/$dbname"
        echo "Database '$dbname' dropped."
    else
        echo "Database does not exist."
    fi
}

function table_menu {
    while true; do
        echo "Table Menu:"
        echo "1. Create Table"
        echo "2. List Tables"
        echo "3. Drop Table"
        echo "4. Insert into Table"
        echo "5. Select From Table"
        echo "6. Delete From Table"
        echo "7. Update Table"
        echo "8. Back to Main Menu"
        read -p "Choose an option: " choice

        case $choice in
            1) create_table ;;
            2) list_tables ;;
            3) drop_table ;;
            4) insert_into_table ;;
            5) select_from_table ;;
            6) delete_from_table ;;
            7) update_table ;;
            8) break ;;
            *) echo "Invalid option, please try again." ;;
        esac
    done
}

function create_table {
    read -p "Enter table name: " tablename
    if [ -f "$connected_database/$tablename" ]; then
        echo "Table already exists."
    else
        read -p "Enter columns (name:type, separated by commas): " columns
        echo $columns > "$connected_database/$tablename"
        echo "Table '$tablename' created."
    fi
}

function list_tables {
    echo "Tables:"
    ls "$connected_database"
}

function drop_table {
    read -p "Enter table name to drop: " tablename
    if [ -f "$connected_database/$tablename" ]; then
        rm "$connected_database/$tablename"
        echo "Table '$tablename' dropped."
    else
        echo "Table does not exist."
    fi
}

function insert_into_table {
    read -p "Enter table name: " tablename
    if [ -f "$connected_database/$tablename" ]; then
        columns=$(head -n 1 "$connected_database/$tablename")
        IFS=',' read -ra cols <<< "$columns"
        values=()
        for col in "${cols[@]}"; do
            name="${col%%:*}"
            read -p "Enter value for $name: " value
            values+=("$value")
        done
        echo "${values[*]}" >> "$connected_database/$tablename"
        echo "Data inserted into '$tablename'."
    else
        echo "Table does not exist."
    fi
}

function select_from_table {
    read -p "Enter table name: " tablename
    if [ -f "$connected_database/$tablename" ]; then
        cat "$connected_database/$tablename"
    else
        echo "Table does not exist."
    fi
}

function delete_from_table {
    read -p "Enter table name: " tablename
    if [ -f "$connected_database/$tablename" ]; then
        read -p "Enter row number to delete: " row
        sed -i "${row}d" "$connected_database/$tablename"
        echo "Row $row deleted from '$tablename'."
    else
        echo "Table does not exist."
    fi
}

function update_table {
    read -p "Enter table name: " tablename
    if [ -f "$connected_database/$tablename" ]; then
        read -p "Enter row number to update: " row
        columns=$(head -n 1 "$connected_database/$tablename")
        IFS=',' read -ra cols <<< "$columns"
        values=()
        for col in "${cols[@]}"; do
            name="${col%%:*}"
            read -p "Enter new value for $name: " value
            values+=("$value")
        done
        sed -i "${row}s/.*/${values[*]}/" "$connected_database/$tablename"
        echo "Row $row updated in '$tablename'."
    else
        echo "Table does not exist."
    fi
}

# Start the main menu
main_menu

