#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function zip_reports() {
  # Inform user that the zipping process is starting
  echo -e "${GREEN}Starting the zipping process...${NC}"
  
  # Add a sleep period if needed
  sleep 5
  
  # Zip the reports
  if zip -r web-performance/reports/taurusReports.zip web-performance/reports/taurusReports; then
    echo -e "${GREEN}Reports have been successfully zipped.${NC}"
  else
    echo -e "${RED}Failed to zip the reports.${NC}"
    exit 1
  fi
  
  # Add a sleep period if needed
  sleep 15
  
  # Inform user that the zipping process is complete
  echo -e "${YELLOW}Zipping process is complete.${NC}"
}

# Call the function
zip_reports
