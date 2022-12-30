#!/bin/bash

# Function to create directories and install nfs-common
function setup_directories_and_nfs {
  # Array of directories to check
  dirs=(/library /library/data1 /library/data2 /library/data3)

  # Loop through the array of directories
  for dir in "${dirs[@]}"; do
    # Check if the directory exists
    if [ ! -d "$dir" ]; then
      # If it does not exist, create the directory
      mkdir -p "$dir"
    fi
  done

  # Check if nfs-common is installed
  if ! dpkg -s nfs-common >/dev/null 2>&1; then
    # If it is not installed, install it
    sudo apt-get update
    sudo apt-get install -y nfs-common
  fi
}

# Function to create fstab entries and mount directories
function mount_directories {
  # Array of directories and NFS mounts
  dirs=("/library/data1 192.168.1.23:/mnt/md0/data" "/library/data2 192.168.1.23:/mnt/md1/data2" "/library/data3 192.168.1.23:/mnt/md2/data3")

  # Loop through the array of directories and NFS mounts
  for dir in "${dirs[@]}"; do
    # Split the directory and NFS mount into separate variables
    IFS=' ' read -r mount_point nfs_mount <<< "$dir"

    # Check if the mount point is in fstab
    if grep -q "$mount_point" /etc/fstab; then
      echo "$mount_point found in fstab"
    else
      echo "$mount_point not found in fstab"
      # Create a new entry in fstab for the NFS mount
      sudo sh -c "echo '$nfs_mount $mount_point nfs rw,sync 0 0' >> /etc/fstab"
    fi
  done

  # Mount the directories
  mount -a
}

# Function to install git and oh-my-bash
function setup_git_and_bash {
  # Check if git is installed
  if ! hash git 2>/dev/null; then
    # If it is not installed, install it
    sudo apt-get update
    sudo apt-get install -y git
  fi

  # Install oh-my-bash
  bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"

  # Change the theme of oh-my-bash to powerline
  if grep -q 'OSH_THEME=' ~/.bashrc; then
    # If it is found, replace the entire line with OSH_THEME="powerline"
    sed -i '/OSH_THEME=/c\OSH_THEME="powerline"' ~/.bashrc
  fi
}

# Show a welcome message using Zenity
zenity --info --title "Welcome" --text "This script allows you to mount NFS drives, install oh-my-bash, or do both. Select the options you want to perform."

# Show a graphical interface using Zenity
options=$(zenity --list --checklist --title "Select Options" \
  --text "What do you want to do?" \
  --column "Select" --column "Option" \
  TRUE "Mount NFS drives" \
  TRUE "Install oh-my-bash" \
  TRUE "Do both")

# Check if the user selected the "Mount NFS drives" option
if [[ $options == *"Mount NFS drives"* ]]; then
  # Run the setup_directories_and_nfs and mount_directories functions
  setup_directories_and_nfs
  mount_directories
fi

# Check if the user selected the "Install oh-my-bash" option
if [[ $options == *"Install oh-my-bash"* ]]; then
  # Run the setup_git_and_bash function
  setup_git_and_bash
fi

# Check if the user selected the "Do both" option
if [[ $options == *"Do both"* ]]; then
  # Run the setup_directories_and_nfs, mount_directories, and setup_git_and_bash functions
  setup_directories_and_nfs
  mount_directories
  setup_git_and_bash
fi