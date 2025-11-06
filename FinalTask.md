# Final Project: Unified Log Analysis Tool

## Objective
The goal of this project is to create a single, powerful bash script that acts as a unified log analysis tool. This tool will integrate the functionality of the four individual log analyzer scripts (`01_text_log_analyzer.sh`, `02_json_log_analyzer.sh`, `03_csv_log_analyzer.sh`, and `04_yaml_config_analyzer.sh`) into a single, menu-driven interface.

## Key Requirements

### 1. Create a Master Script
- Create a new bash script named `master_log_analyzer.sh` in the `/opt/devops-bootcamp-project/bash/scripts/` directory.
- This script will serve as the main entry point for the unified tool.

### 2. Implement a Menu-Driven Interface
- When `master_log_analyzer.sh` is executed, it should display a menu with the following options:
  1. Analyze Text Log File (`application.log`)
  2. Analyze JSON Log File (`extended_activity_log.json`)
  3. Analyze CSV Log File (`activity_log.csv`)
  4. Analyze YAML Configuration File (`services.yaml`)
  5. Exit
- The script should prompt the user to select an option.

### 3. Integrate Existing Scripts
- Based on the user's menu selection, the `master_log_analyzer.sh` script should call and execute the corresponding log analyzer script.
- **Important:** You are not required to rewrite the logic of the individual analyzer scripts. Instead, your master script should invoke them. You may need to slightly modify the individual scripts to be called from a master script (e.g., by removing redundant header printouts or making file paths more flexible).

### 4. User-Friendly Output
- Ensure that the output is clear and well-formatted.
- After a report is generated, the script should return to the main menu, allowing the user to perform another analysis or exit.

### 5. Error Handling
- The master script should include basic error handling. For example, it should provide a message if the user enters an invalid menu option.
- It should also ensure that the required log files and analyzer scripts exist before attempting to run an analysis.

## Project Structure
- All scripts should be located in the `/opt/devops-bootcamp-project/bash/scripts/` directory.
- All log files should be in the `/opt/devops-bootcamp-project/bash/examples/` directory.
- Reports should be saved to the `/opt/devops-bootcamp-project/bash/reports/` directory, as is currently implemented in the individual scripts.

## Evaluation Criteria
- **Functionality:** Does the master script successfully launch the correct analyzer based on user input?
- **User Interface:** Is the menu clear, and is the tool easy to use?
- **Integration:** How well are the individual scripts integrated into the master script?
- **Code Quality:** Is the `master_log_analyzer.sh` script well-commented and easy to understand?
- **Error Handling:** Does the script handle invalid input gracefully?

## Submission
- Submit your `master_log_analyzer.sh` script.
- Include a brief `README.md` file in the `/opt/devops-bootcamp-project/bash/` directory explaining how to run your unified tool and any modifications you made to the individual scripts.
