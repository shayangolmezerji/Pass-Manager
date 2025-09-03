#!/bin/bash

# --- Configuration ---
PASS_DIR="$HOME/.password-manager"
PASSWORDS_DIR="$PASS_DIR/passwords"

GPG_RECIPIENT="alex alexian (example) <alex@example.com>"

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- Core Functions ---

check_dependencies() {
    if ! command -v gpg &> /dev/null; then
        echo -e "${RED}Error: gpg is not installed. Please install it to continue.${NC}" >&2
        exit 1
    fi
    if [[ "$GPG_RECIPIENT" == "Your Name <your-email@example.com>" ]]; then
        echo -e "${YELLOW}Warning: GPG_RECIPIENT is not configured. Please edit the script and set your GPG key ID.${NC}" >&2
        exit 1
    fi
    # Check if the GPG key for the recipient exists on the system.
    if ! gpg --list-keys "$GPG_RECIPIENT" &> /dev/null; then
        echo -e "${RED}Error: The specified GPG recipient key '$GPG_RECIPIENT' does not exist. Did you import the correct key?${NC}" >&2
        exit 1
    fi
    # Check for xclip, as it is needed for the improved 'get' functionality.
    if ! command -v xclip &> /dev/null; then
        echo -e "${YELLOW}Warning: xclip is not installed. The 'get' command will display the password but will not copy it to the clipboard.${NC}" >&2
    fi
}

initialize_dir() {
    if [[ ! -d "$PASSWORDS_DIR" ]]; then
        echo -e "${CYAN}Creating password directory: $PASSWORDS_DIR${NC}"
        mkdir -p "$PASSWORDS_DIR"
        chmod 700 "$PASS_DIR" "$PASSWORDS_DIR"
    fi
}

generate_password() {
    local length=${1:-16} # Default length is 16 if not specified
    tr -dc 'a-zA-Z0-9!@#$%^&*()_+{}[]|:;<>?,./' < /dev/urandom | head -c "$length"
}

add_password() {
    read -rp "Enter the service/account name (e.g., google.com): " service
    service=$(echo "$service" | tr ' ' '_')
    local file="$PASSWORDS_DIR/$service.gpg"

    if [[ -f "$file" ]]; then
        echo -e "${YELLOW}A password for '$service' already exists. Do you want to overwrite it? (y/n)${NC}"
        read -n 1 -rp "-> " overwrite_choice
        echo
        if [[ ! "$overwrite_choice" =~ ^[Yy]$ ]]; then
            echo -e "${RED}Operation cancelled.${NC}" >&2
            return 1
        fi
    fi

    read -rp "Enter the username for $service: " username
    read -srp "Enter the password for $service (input will be hidden): " password
    echo

    temp_file=$(mktemp)
    {
        echo "Service: $service"
        echo "Username: $username"
        echo "Password: $password"
    } > "$temp_file"

    if gpg --batch --encrypt --recipient "$GPG_RECIPIENT" -o "$file" "$temp_file"; then
        echo -e "${GREEN}Password for '$service' successfully added.${NC}"
    else
        echo -e "${RED}Error: Failed to encrypt the password.${NC}" >&2
    fi

    rm "$temp_file"
}

get_password() {
    local service=${1}
    local file="$PASSWORDS_DIR/$service.gpg"

    if [[ ! -f "$file" ]]; then
        echo -e "${RED}Error: No password found for '$service'.${NC}" >&2
        return 1
    fi
    
    # Decrypt and capture the output. Errors are sent to /dev/null
    local decrypted_content=$(gpg --batch --quiet --decrypt "$file" 2>/dev/null)
    
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}Decryption successful.${NC}"
        # Extract the password line and copy it to the clipboard if xclip is available
        if command -v xclip &> /dev/null; then
            echo "$decrypted_content" | grep '^Password: ' | sed 's/^Password: //;s/ //g' | tr -d '\n' | xclip -selection c
            echo -e "${CYAN}Password copied to clipboard. It will remain there until another item is copied or your session ends.${NC}"
        fi
        echo
        echo "$decrypted_content"
    else
        echo -e "${RED}Error: Failed to decrypt password. Check your GPG passphrase.${NC}" >&2
    fi
}

list_passwords() {
    local count=$(ls -1 "$PASSWORDS_DIR"/*.gpg 2>/dev/null | wc -l)

    if [[ "$count" -eq 0 ]]; then
        echo -e "${YELLOW}No passwords found. Add one with the 'add' command.${NC}"
        return 0
    fi

    echo -e "${CYAN}Stored Passwords:${NC}"
    echo "-----------------"
    ls -1 "$PASSWORDS_DIR"/*.gpg | sed 's/\.gpg$//' | xargs -n1 basename | sort
    echo "-----------------"
    echo -e "Total: ${count}${NC}"
}

delete_password() {
    read -rp "Enter the service name to delete: " service
    local file="$PASSWORDS_DIR/$service.gpg"

    if [[ ! -f "$file" ]]; then
        echo -e "${RED}Error: No password found for '$service'.${NC}" >&2
        return 1
    fi

    echo -e "${YELLOW}Are you sure you want to delete the password for '$service'? This cannot be undone. (y/n)${NC}"
    read -n 1 -rp "-> " delete_choice
    echo

    if [[ "$delete_choice" =~ ^[Yy]$ ]]; then
        rm "$file"
        echo -e "${GREEN}Password for '$service' successfully deleted.${NC}"
    else
        echo -e "${RED}Operation cancelled.${NC}" >&2
    fi
}

# --- Main CLI Menu and Logic ---
print_help() {
    echo -e "${BLUE}Usage: $0 [command]${NC}"
    echo
    echo -e "${CYAN}Available Commands:${NC}"
    echo -e "${GREEN}  add            ${NC}Add a new password entry."
    echo -e "${GREEN}  get [service]  ${NC}Retrieve and display a password."
    echo -e "${GREEN}  list           ${NC}List all stored services."
    echo -e "${GREEN}  delete         ${NC}Delete a password entry."
    echo -e "${GREEN}  generate       ${NC}Generate a secure password (default 16 characters)."
    echo -e "${GREEN}  -h, --help     ${NC}Show this help message."
    echo
    echo -e "Example: $0 get my-bank-account"
}

check_dependencies
initialize_dir

case "$1" in
    add)
        add_password
        ;;
    get)
        if [[ -z "$2" ]]; then
            echo -e "${RED}Error: 'get' command requires a service name.${NC}" >&2
            print_help
            exit 1
        fi
        get_password "$2"
        ;;
    list)
        list_passwords
        ;;
    delete)
        delete_password
        ;;
    generate)
        read -rp "Enter desired password length (default 16): " length
        if [[ -z "$length" || "$length" =~ ^[0-9]+$ ]]; then
            echo -e "${GREEN}Generated Password: $(generate_password "${length}") ${NC}"
        else
            echo -e "${RED}Invalid length. Generating default 16 characters.${NC}" >&2
            echo -e "${GREEN}Generated Password: $(generate_password) ${NC}"
        fi
        ;;
    -h|--help)
        print_help
        ;;
    *)
        echo -e "${RED}Invalid command.${NC}" >&2
        print_help
        exit 1
        ;;
esac

exit 0
