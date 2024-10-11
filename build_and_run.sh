#!/bin/bash

# Define the name of the assembly source file
SOURCE_FILE="lab3.s"
OBJECT_FILE="lab3.o"
EXECUTABLE="lab3"

# Assemble the assembly file
as -o $OBJECT_FILE $SOURCE_FILE

# Link the object file using gcc to include the C standard library
gcc -o $EXECUTABLE $OBJECT_FILE

# Run the executable
./$EXECUTABLE
