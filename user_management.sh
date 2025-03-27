#!/bin/bash

# Script Name: user_management.sh
# Description: Advanced user management in Ubuntu (Create, Delete, List, Lock, Unlock)
# Usage: Run as root and follow menu prompts
# Author: SHACKVERSE PRIVATE LIMITED
# Version: 2.0

# Global variables
LOG_FILE="/var/log/user_management.log"

# Function to initialize logging
init_logging() {
    touch "$LOG_FILE"
    chmod 600 "$LOG_FILE"
}

# Function to log actions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Function to check if script is run as root
check_root() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "Error: This script must be run as root." >&2
        log_action "Failed attempt to run script without root privileges"
        exit 1
    fi
}

# Function to sanitize input
sanitize_input() {
    echo "$1" | tr -d ';|&<>'
}

# Function to validate password complexity
validate_password() {
    local password=$1
    local min_length=8
    
    if [[ ${#password} -lt $min_length ]]; then
        echo "Password must be at least $min_length characters"
        return 1
    fi
    
    if ! [[ "$password" =~ [A-Z] ]]; then
        echo "Password must contain at least one uppercase letter"
        return 1
    fi
    
    if ! [[ "$password" =~ [a-z] ]]; then
        echo "Password must contain at least one lowercase letter"
        return 1
    fi
    
    if ! [[ "$password" =~ [0-9] ]]; then
        echo "Password must contain at least one number"
        return 1
    fi
    
    return 0
}

# Function to create a new user
create_user() {
    while true; do
        read -p "Enter username to create: " username
        username=$(sanitize_input "$username")
        if [[ -z "$username" ]]; then
            echo "Username cannot be empty."
            continue
        fi
        if [[ "$username" =~ [[:space:]] ]]; then
            echo "Username cannot contain spaces."
            continue
        fi
        if id "$username" &>/dev/null; then
            echo "User '$username' already exists."
            log_action "Attempt to create existing user: $username"
            return 1
        fi
        break
    done

    while true; do
        read -s -p "Enter password for $username: " password
        echo
        read -s -p "Confirm password: " password_confirm
        echo
        
        if [[ "$password" != "$password_confirm" ]]; then
            echo "Passwords do not match. Please try again."
            continue
        fi
        
        if ! validate_password "$password"; then
            continue
        fi
        
        break
    done

    useradd -m -s /bin/bash "$username"
    echo "$username:$password" | chpasswd
    
    # Set password aging policy
    chage -M 90 "$username"  # Password expires after 90 days
    chage -W 7 "$username"   # Warn 7 days before expiration
    
    echo "User '$username' created successfully."
    log_action "Created user: $username"

    read -p "Add user to a group? (y/n): " add_group
    if [[ "$add_group" =~ ^[Yy]$ ]]; then
        read -p "Enter group name: " groupname
        groupname=$(sanitize_input "$groupname")
        if grep -q "^$groupname:" /etc/group; then
            usermod -aG "$groupname" "$username"
            echo "User '$username' added to group '$groupname'."
            log_action "Added user $username to group $groupname"
        else
            echo "Group '$groupname' does not exist."
        fi
    fi

    read -p "Grant sudo privileges? (y/n): " grant_sudo
    if [[ "$grant_sudo" =~ ^[Yy]$ ]]; then
        usermod -aG sudo "$username"
        echo "User '$username' granted sudo privileges."
        log_action "Granted sudo to user: $username"
    fi

    read -p "Add SSH public key? (y/n): " add_key
    if [[ "$add_key" =~ ^[Yy]$ ]]; then
        mkdir -p "/home/$username/.ssh"
        while true; do
            read -p "Paste public key (or 'done' to finish): " pubkey
            if [[ "$pubkey" == "done" ]]; then
                break
            fi
            echo "$pubkey" >> "/home/$username/.ssh/authorized_keys"
        done
        chmod 700 "/home/$username/.ssh"
        chmod 600 "/home/$username/.ssh/authorized_keys"
        chown -R "$username:$username" "/home/$username/.ssh"
        echo "SSH key(s) added for user '$username'."
        log_action "Added SSH keys for user: $username"
    fi
}

# Function to delete a user
delete_user() {
    read -p "Enter username to delete: " username
    username=$(sanitize_input "$username")
    
    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist."
        log_action "Attempt to delete non-existent user: $username"
        return 1
    fi

    read -p "Are you sure you want to delete user '$username'? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        # Check if user has running processes
        if pgrep -u "$username" > /dev/null; then
            read -p "User has running processes. Kill them? (y/n): " kill_procs
            if [[ "$kill_procs" =~ ^[Yy]$ ]]; then
                pkill -9 -u "$username"
                echo "All processes for user '$username' killed."
                log_action "Killed processes for user: $username"
            fi
        fi
        
        userdel -r "$username" 2>/dev/null
        if [[ $? -eq 0 ]]; then
            echo "User '$username' deleted successfully."
            log_action "Deleted user: $username"
        else
            echo "Failed to completely remove user '$username'. Check manually."
            log_action "Partial deletion of user: $username"
            return 1
        fi
    else
        echo "User deletion aborted."
    fi
}

# Function to list all users with details
list_users() {
    echo "Listing all system users:"
    echo "-----------------------------------------------------------------"
    printf "%-20s %-10s %-30s %-15s\n" "USERNAME" "UID" "HOME" "SHELL"
    echo "-----------------------------------------------------------------"
    
    awk -F':' '{ printf "%-20s %-10s %-30s %-15s\n", $1, $3, $6, $7 }' /etc/passwd
    
    echo "-----------------------------------------------------------------"
    log_action "Viewed user list"
}

# Function to show user details
show_user_details() {
    read -p "Enter username to view details: " username
    username=$(sanitize_input "$username")
    
    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist."
        return 1
    fi

    echo "Detailed information for user '$username':"
    echo "-----------------------------------------------------------------"
    finger "$username" 2>/dev/null || echo "Install 'finger' for more detailed information"
    echo "Groups: $(groups "$username")"
    echo "-----------------------------------------------------------------"
    echo "Last login:"
    lastlog -u "$username"
    echo "-----------------------------------------------------------------"
    echo "Password aging information:"
    chage -l "$username"
    echo "-----------------------------------------------------------------"
    log_action "Viewed details for user: $username"
}

# Function to lock a user
lock_user() {
    read -p "Enter username to lock: " username
    username=$(sanitize_input "$username")
    
    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist."
        log_action "Attempt to lock non-existent user: $username"
        return 1
    fi

    passwd -l "$username"
    usermod --expiredate 1 "$username"  # Set account expiration to past date
    echo "User '$username' has been locked and expired."
    log_action "Locked user: $username"
}

# Function to unlock a user
unlock_user() {
    read -p "Enter username to unlock: " username
    username=$(sanitize_input "$username")
    
    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist."
        log_action "Attempt to unlock non-existent user: $username"
        return 1
    fi

    passwd -u "$username"
    usermod --expiredate "" "$username"  # Remove account expiration
    echo "User '$username' has been unlocked."
    log_action "Unlocked user: $username"
}

# Function to set password policy
set_password_policy() {
    echo "Current password policy:"
    grep "^PASS_" /etc/login.defs | grep -v "^#"
    echo ""
    
    read -p "Set minimum password days (current: $(grep "^PASS_MIN_DAYS" /etc/login.defs | awk '{print $2}')): " min_days
    read -p "Set maximum password days (current: $(grep "^PASS_MAX_DAYS" /etc/login.defs | awk '{print $2}')): " max_days
    read -p "Set password warn age (current: $(grep "^PASS_WARN_AGE" /etc/login.defs | awk '{print $2}')): " warn_age
    
    if [[ "$min_days" =~ ^[0-9]+$ ]]; then
        sed -i "s/^PASS_MIN_DAYS.*/PASS_MIN_DAYS\t$min_days/" /etc/login.defs
    fi
    
    if [[ "$max_days" =~ ^[0-9]+$ ]]; then
        sed -i "s/^PASS_MAX_DAYS.*/PASS_MAX_DAYS\t$max_days/" /etc/login.defs
    fi
    
    if [[ "$warn_age" =~ ^[0-9]+$ ]]; then
        sed -i "s/^PASS_WARN_AGE.*/PASS_WARN_AGE\t$warn_age/" /etc/login.defs
    fi
    
    echo "Password policy updated."
    log_action "Updated password policy: MIN_DAYS=$min_days, MAX_DAYS=$max_days, WARN_AGE=$warn_age"
}

# Function to show menu
show_menu() {
    clear
    echo "-----------------------------------------------"
    echo "    Ubuntu Advanced User Management Script     "
    echo "-----------------------------------------------"
    echo "1) Create a new user"
    echo "2) Delete a user"
    echo "3) List all users"
    echo "4) Show user details"
    echo "5) Lock a user account"
    echo "6) Unlock a user account"
    echo "7) Set password policy"
    echo "8) Exit"
    echo "-----------------------------------------------"
}

# Function to display help
show_help() {
    clear
    echo "USER MANAGEMENT SCRIPT HELP"
    echo "--------------------------"
    echo "1) Create User: Creates new user with home directory, sets password, and allows adding to groups"
    echo "2) Delete User: Removes user account and home directory"
    echo "3) List Users: Shows all system users with basic info"
    echo "4) User Details: Shows comprehensive user information"
    echo "5) Lock User: Disables account login and expires password"
    echo "6) Unlock User: Enables account login and removes expiration"
    echo "7) Password Policy: Configure system-wide password requirements"
    echo "8) Exit: Quit the script"
    echo ""
    read -n 1 -s -r -p "Press any key to return to menu..."
}

# Main script execution
init_logging
check_root

while true; do
    show_menu
    read -p "Choose an option (1-8) or 'h' for help: " choice

    case $choice in
        1) create_user ;;
        2) delete_user ;;
        3) list_users ;;
        4) show_user_details ;;
        5) lock_user ;;
        6) unlock_user ;;
        7) set_password_policy ;;
        8) echo "Exiting..."; log_action "Script exited"; exit 0 ;;
        h|H) show_help ;;
        *) echo "Invalid option. Please select a valid choice." ;;
    esac
    
    read -n 1 -s -r -p "Press any key to continue..."
done