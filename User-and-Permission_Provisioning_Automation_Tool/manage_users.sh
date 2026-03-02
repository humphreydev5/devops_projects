#!/bin/bash

# ==============================
# CONFIG
# ==============================
CSV_FILE="$1"
DRY_RUN=false
ROLLBACK=false

CREATED_USERS=()
CREATED_GROUPS=()
CREATED_DIRS=()

CREATED_COUNT=0
SKIPPED_COUNT=0
ERROR_COUNT=0

# ==============================
# ARGUMENT PARSING
# ==============================
for arg in "$@"; do
    case $arg in
        --dry-run) DRY_RUN=true ;;
        --rollback) ROLLBACK=true ;;
    esac
done

# ==============================
# ROOT CHECK
# ==============================
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: This script must be run as root."
    exit 1
fi

# ==============================
# HELPER FUNCTIONS
# ==============================
run_cmd() {
    if $DRY_RUN; then
        echo "[DRY-RUN] $*"
    else
        eval "$@"
        return $?
    fi
}

group_exists() {
    getent group "$1" > /dev/null
}

user_exists() {
    id "$1" &>/dev/null
}

# ==============================
# ROLLBACK FUNCTION
# ==============================
rollback() {
    echo "Starting rollback..."

    for user in "${CREATED_USERS[@]}"; do
        echo "Removing user: $user"
        run_cmd userdel -r "$user"
    done

    for grp in "${CREATED_GROUPS[@]}"; do
        echo "Removing group: $grp"
        run_cmd groupdel "$grp"
    done

    for dir in "${CREATED_DIRS[@]}"; do
        echo "Removing directory: $dir"
        run_cmd rm -rf "$dir"
    done

    echo "Rollback completed."
    exit 0
}

if $ROLLBACK; then
    rollback
fi

# ==============================
# VALIDATE CSV
# ==============================
if [ -z "$CSV_FILE" ] || [ ! -f "$CSV_FILE" ]; then
    echo "Usage: $0 users.csv [--dry-run] [--rollback]"
    exit 1
fi

# ==============================
# PROCESS CSV
# ==============================
while IFS=, read -r username group shell; do

    echo "Processing user: $username"

    # ----- CREATE GROUP -----
    if group_exists "$group"; then
        echo "Group exists: $group"
    else
        if run_cmd groupadd "$group"; then
            CREATED_GROUPS+=("$group")
        else
            echo "Error creating group $group"
            ((ERROR_COUNT++))
            continue
        fi
    fi

    # ----- CREATE USER -----
    if user_exists "$username"; then
        echo "User exists: $username (skipped)"
        ((SKIPPED_COUNT++))
    else
        if run_cmd useradd -m -s "$shell" -g "$group" "$username"; then
            CREATED_USERS+=("$username")
            ((CREATED_COUNT++))
        else
            echo "Error creating user $username"
            ((ERROR_COUNT++))
            continue
        fi
    fi

    # ----- CREATE PROJECT DIRECTORY -----
    PROJECT_DIR="/opt/projects/$username"

    if [ -d "$PROJECT_DIR" ]; then
        echo "Directory exists: $PROJECT_DIR"
    else
        if run_cmd mkdir -p "$PROJECT_DIR"; then
            CREATED_DIRS+=("$PROJECT_DIR")
        else
            echo "Error creating directory for $username"
            ((ERROR_COUNT++))
            continue
        fi
    fi

    run_cmd chown "$username:$group" "$PROJECT_DIR"
    run_cmd chmod 770 "$PROJECT_DIR"

done < "$CSV_FILE"

# ==============================
# SUMMARY REPORT
# ==============================
echo ""
echo "========= PROVISIONING SUMMARY ========="
echo "Users created : $CREATED_COUNT"
echo "Users skipped : $SKIPPED_COUNT"
echo "Errors        : $ERROR_COUNT"
echo "========================================"
