#!/bin/bash

# ask for user's name
read -p "Enter a name: " userName

# Define main dir
S_dir="submission_reminder_${userName}"

# Create directory one by one
mkdir -p "$S_dir/config"
mkdir -p "$S_dir/modules"
mkdir -p "$S_dir/app"
mkdir -p "$S_dir/assets"

# Create needed files
touch "$S_dir/config/config.env"
touch "$S_dir/assets/submissions.txt"
touch "$S_dir/app/reminder.sh"
touch "$S_dir/modules/functions.sh"
touch "$S_dir/startup.sh"


# config.env
cat << EOF > "$S_dir/config/config.env"
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# submissions.txt with some student records
cat << EOF > "$S_dir/assets/submissions.txt"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Niyonzima, Shell Navigation, not submitted
Peter, Shell Basics, submitted
Hugue, Shell Navigation, not submitted
Jean, Shell Navigation, not submitted
Vanessa, Shell Navigation, not submitted
Habeeb, Shell Navigation, submitted
EOF

# functions.sh
cat << 'EOF' > "$S_dir/modules/functions.sh"
#!/bin/bash

# Function to read submissions file and output students who have not submitted
 
 function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

# reminder.sh being populated
cat << 'EOF' > "$S_dir/app/reminder.sh"
#!/bin/bash
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

# startup.sh being populated
cat << 'EOF' > "$S_dir/startup.sh"
#!/bin/bash
echo "Starting Submission Reminder App..."
./app/reminder.sh
EOF

# executing the scripts
chmod +x "$S_dir/modules/functions.sh"
chmod +x "$S_dir/startup.sh"
chmod +x "$S_dir/app/reminder.sh"
