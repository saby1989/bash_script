#!/bin/bash

# Path to your Python script
PYTHON_SCRIPT="python_script/test.py"

# Path to your Quarto render command
QUARTO_RENDER_CMD="quarto render quarto_file/test.qmd --to html"

# Path to the generated Quarto report and output directory
REPORT_PATH="quarto_file/test.html"
OUTPUT_DIR="quarto_output/"

# Execute the Python script
echo "Running Python script..."
python "$PYTHON_SCRIPT"

# Check if the Python script executed successfully
if [ $? -eq 0 ]; then
    echo "Python script executed successfully."
    
    # Run the Quarto render command
    echo "Running Quarto render command..."
    $QUARTO_RENDER_CMD
    
    # Check if Quarto render command was successful
    if [ $? -eq 0 ]; then
        echo "Quarto render completed successfully."

        # Move the Quarto report to the output directory
        echo "Moving Quarto report to output directory..."
        mv "$REPORT_PATH" "$OUTPUT_DIR"
        
        if [ $? -eq 0 ]; then
            echo "Report moved successfully."
        else
            echo "Failed to move the report."
        fi
    else
        echo "Quarto render failed."
    fi
else
    echo "Python script failed. Skipping Quarto render."
fi
