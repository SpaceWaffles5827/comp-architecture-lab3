#!/bin/bash

# Script to compile and debug the lab03 assembly program

# Set the name of your assembly file and output executable
ASM_FILE="lab3.s"
EXECUTABLE="lab3"

# Compile the assembly file with debug information (-g flag)
echo "Compiling $ASM_FILE..."
gcc -g -o $EXECUTABLE $ASM_FILE

# Check if the compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful. Starting GDB..."
    
    # Run the executable in GDB
    gdb ./$EXECUTABLE
else
    echo "Compilation failed. Please check the assembly code for errors."
fi
