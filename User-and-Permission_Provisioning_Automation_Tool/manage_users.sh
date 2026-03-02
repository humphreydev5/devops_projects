#!/bin/bash

# --- Configuration & Defaults ---
CSV_FILE=""
DRY_RUN=false
ROLLBACK=false
LOG_FILE="provision_summary.log"
PROJECT_BASE="/opt/projects"

# Tracking for Summary Report
CREATED_USERS=()
SKIPPED_USERS=()
ERRORS=()

# --- Root Validation ---
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root." 
   exit 1
fi

# --- Helper Functions ---
show_help() {
    echo "Usage: $0 [OPTIONS] <csv_file>"
    echo "Options:"
    echo "  --dry-run   Show what would happen without making changes."
    echo "  --rollback  Remove users, groups, and directories defined in the CSV."
    exit 0
}

# --- Argument Parsing ---
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run) DRY_RUN=true; shift ;;
        --rollback) ROLLBACK=true; shift ;;
        -h|--help) show_help ;;
        *) CSV_FILE="$1"; shift ;;
    esac
done

if [[ -z "$CSV_FILE" || ! -f "$CSV_FILE" ]]; then
    echo "Error: CSV file not found."
    show_help
fi

# --- Core Logic ---
process_provisioning() {
    # CSV Format: username,group,shell
    while IFS=',' read -r username group shell || [ -n "$username" ]; do
        # Skip header or empty lines
        [[ "$username" == "username" || -z "$username" ]] && continue

        if $ROLLBACK; then
            echo "Rolling back: $username"
            if $DRY_RUN; then
                echo "[DRY-RUN] Would remove user $username and directory $PROJECT_BASE/$username"
            else
                userdel -r "$username" 2>/dev/null
                rm -rf "$PROJECT_BASE/$username"
                echo "Removed $username"
            fi
            continue
        fi

        # Provisioning Logic
        if id "$username" &>/dev/null; then
            SKIPPED_USERS+=("$username (Exists)")
            continue
        fi

        if $DRY_RUN; then
            echo "[DRY-RUN] Would create group $group, user $username (shell: $shell), and directory $PROJECT_BASE/$username"
            continue
        fi

        # 1. Create Group
        getent group "$group" >/dev/null || groupadd "$group"

        # 2. Create User
        if useradd -m -g "$group" -s "$shell" "$username" 2>/dev/null; then
            # 3. Create Project Directory
            mkdir -p "$PROJECT_BASE/$username"
            
            # 4. Set Permissions (Owner:User, Group:Group, Mode:770)
            chown "$username:$group" "$PROJECT_BASE/$username"
            chmod 770 "$PROJECT_BASE/$username"
            
            CREATED_USERS+=("$username")
        else
            ERRORS+=("$username (Failed to create)")
        fi

    done < "$CSV_FILE"
}

# Run execution
process_provisioning

# --- Summary Report ---
{
    echo "--- Provisioning Summary ($(date)) ---"
    echo "Created: ${CREATED_USERS[*]:-None}"
    echo "Skipped: ${SKIPPED_USERS[*]:-None}"
    echo "Errors:  ${ERRORS[*]:-None}"
    echo "--------------------------------------"
} | tee -a "$LOG_FILE"

echo "Report saved to $LOG_FILE"
