#!/bin/bash

LOG_FILE="backup.log"

# ---------- FUNCTION: LOG MESSAGE ----------
log_message() {
    local status=$1
    local src=$2
    local dest=$3
    echo "$(date '+%Y-%m-%d %H:%M:%S') | Source: $src | Destination: $dest | Status: $status" >> "$LOG_FILE"
}

# ---------- FUNCTION: CREATE BACKUP ----------
create_backup() {
    read -p "Enter source directory: " SRC
    read -p "Enter backup destination directory: " DEST

    if [ ! -d "$SRC" ]; then
        echo "Source directory does not exist."
        log_message "FAILED (Invalid source)" "$SRC" "$DEST"
        return 1
    fi

    if [ ! -d "$DEST" ]; then
        echo "Destination directory does not exist."
        log_message "FAILED (Invalid destination)" "$SRC" "$DEST"
        return 1
    fi

    TIMESTAMP=$(date '+%Y-%m-%d_%H%M%S')
    BACKUP_FILE="$DEST/backup-$TIMESTAMP.tar.gz"

    tar -czf "$BACKUP_FILE" "$SRC" 2>/dev/null

    if [ $? -eq 0 ]; then
        echo "Backup created successfully: $BACKUP_FILE"
        log_message "SUCCESS" "$SRC" "$DEST"
    else
        echo "Backup failed."
        log_message "FAILED (tar error)" "$SRC" "$DEST"
    fi
}

# ---------- FUNCTION: RESTORE BACKUP ----------
restore_backup() {
    read -p "Enter backup directory: " BACKUP_DIR

    if [ ! -d "$BACKUP_DIR" ]; then
        echo "Directory does not exist."
        return 1
    fi

    echo "Available backups:"
    select FILE in "$BACKUP_DIR"/backup-*.tar.gz; do
        if [ -n "$FILE" ]; then
            read -p "Enter restore destination directory: " RESTORE_DEST

            if [ ! -d "$RESTORE_DEST" ]; then
                echo "Restore directory does not exist."
                return 1
            fi

            tar -xzf "$FILE" -C "$RESTORE_DEST" 2>/dev/null

            if [ $? -eq 0 ]; then
                echo "Restore completed successfully."
                log_message "RESTORE SUCCESS" "$FILE" "$RESTORE_DEST"
            else
                echo "Restore failed."
                log_message "RESTORE FAILED" "$FILE" "$RESTORE_DEST"
            fi
            break
        else
            echo "Invalid selection."
        fi
    done
}

# ---------- MAIN MENU ----------
while true; do
    echo "=============================="
    echo " Automated Backup Tool"
    echo "=============================="
    echo "1) Backup Directory"
    echo "2) Restore Backup"
    echo "3) Exit"
    read -p "Choose an option: " choice

    case $choice in
        1) create_backup ;;
        2) restore_backup ;;
        3) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option. Try again." ;;
    esac
done
