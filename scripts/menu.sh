#!/bin/bash

sleep 0.5

show_menu() {
    echo "========================================="
    echo "  Terraform Infrastructure Manager       "
    echo "========================================="
    echo "Please select an operation to perform:"
    echo "1) Init             (scripts/init.sh)"
    echo "2) Apply            (scripts/apply.sh)"
    echo "3) Upgrade          (scripts/upgrade.sh)"
    echo "4) Output           (scripts/output.sh)"
    echo "5) Update Snapshots (scripts/update_snapshots.sh)"
    echo "6) Destroy          (scripts/destroy.sh)"
    echo "q) Quit"
    echo "========================================="
}

bash scripts/configure_aws.sh

while true; do
    show_menu
    read -p "Enter your choice [1-7, q]: " choice

    case $choice in
        1)
            echo "Running Init..."
            bash scripts/init.sh
            ;;
        2)
            echo "Running Apply..."
            read -p "Enter extra arguments for apply (e.g. -auto-approve) or press Enter: " args
            bash scripts/apply.sh $args
            ;;
        3)
            echo "Running Upgrade..."
            bash scripts/upgrade.sh
            ;;
        4)
            echo "Running Output..."
            bash scripts/output.sh
            ;;
        5)
            echo "Running Update Snapshots..."
            bash scripts/update_snapshots.sh
            ;;
        6)
            echo "Running Destroy..."
            read -p "Enter extra arguments for destroy (e.g. -auto-approve) or press Enter: " args
            bash scripts/destroy.sh "$args"
            ;;
        q|Q)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
    
    echo ""
    read -p "Press Enter to return to the menu..."
done
