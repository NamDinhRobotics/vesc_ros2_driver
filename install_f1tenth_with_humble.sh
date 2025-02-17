#!/bin/bash

# Exit script on error
set -e

echo "Setting up F1TENTH driver stack..."

# Step 1: Install required package
echo "Installing required package: ros-humble-asio-cmake-module..."
sudo apt-get update
sudo apt-get install -y ros-humble-asio-cmake-module

# Step 2: Create ROS 2 workspace
echo "Creating workspace..."
WORKSPACE_DIR="$HOME/f1tenth_ws"
SRC_DIR="$WORKSPACE_DIR/src"
mkdir -p "$SRC_DIR"

# Step 3: Initialize ROS 2 workspace
cd "$WORKSPACE_DIR"
echo "Initializing ROS 2 workspace..."
colcon build

# Step 4: Clone the f1tenth_system repository
echo "Cloning f1tenth_system repository..."
cd "$SRC_DIR"
git clone https://github.com/f1tenth/f1tenth_system.git

# Step 5: Checkout the humble-devel branch
echo "Checking out the humble-devel branch..."
cd f1tenth_system
git checkout humble-devel

# Step 6: Update git submodules
echo "Updating git submodules..."
# git submodule update --init --force --remote
git submodule update --init --recursive

# revove old vesc
rm -rf vesc
git clone -b humble https://github.com/f1tenth/vesc.git

# Step 7: Install dependencies
echo "Installing dependencies..."
cd "$WORKSPACE_DIR"
rosdep update
rosdep install --from-paths src -i -y

# Step 8: Build the workspace with driver stack packages
echo "Building the workspace..."
colcon build

echo "F1TENTH driver stack setup with humble-devel completed successfully!"

