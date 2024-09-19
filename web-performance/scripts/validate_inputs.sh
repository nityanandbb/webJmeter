
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Emojis
FIRE_EMOJI="🔥"
GREEN_CIRCLE="🟢"
RED_CIRCLE="🔴"
CHECK_MARK="✅"
CROSS_MARK="❌"
WARNING_SIGN="⚠️"

# Default path
DEFAULT_PATH="web-performance/jmeter/tests/performance/"

# Function to print error messages
print_error() {
  local message="$1"
  echo -e "${RED}${RED_CIRCLE} ${CROSS_MARK} Error: ${message}${RESET}"
}

# Function to print success messages
print_success() {
  local message="$1"
  echo -e "${GREEN}${GREEN_CIRCLE} ${CHECK_MARK} ${message}${RESET}"
}

# Function to print warning messages
print_warning() {
  local message="$1"
  echo -e "${YELLOW}${WARNING_SIGN} Warning: ${message}${RESET}"
}

# Function to log input values with status
log_input() {
  local name="$1"
  local value="$2"
  local is_valid="$3"
  
  if [ "$is_valid" = true ]; then
    echo -e "${GREEN}${GREEN_CIRCLE} ${CHECK_MARK} ${name}: ${GREEN}${value}${RESET}"
  else
    echo -e "${RED}${RED_CIRCLE} ${CROSS_MARK} ${name}: ${RED}${value}${RESET}"
  fi
}

# Validate Threads Number
THREADS_NUMBER="${THREADS_NUMBER:-}"
echo -e "${YELLOW}Validating Threads Number...${RESET}"
if ! [[ "$THREADS_NUMBER" =~ ^[1-9][0-9]*$ ]]; then
  print_error "'threadsNumber' must be a positive integer greater than or equal to 1."
  log_input "threadsNumber" "$THREADS_NUMBER" false
  exit 1
else
  print_success "'threadsNumber' is valid."
  log_input "threadsNumber" "$THREADS_NUMBER" true
fi

# Validate base URL
BASE_URL="${BASE_URL:-}"
echo -e "${YELLOW}Validating Base URL...${RESET}"
if [[ -z "$BASE_URL" || ! "$BASE_URL" =~ ^https?:// ]]; then
  print_warning "'baseurl' is empty or not a valid URL. It should start with http:// or https://."
  log_input "baseurl" "$BASE_URL" false
else
  print_success "'baseurl' is valid."
  log_input "baseurl" "$BASE_URL" true
fi

# Validate timeDuration
TIME_DURATION="${TIME_DURATION:-}"
echo -e "${YELLOW}Validating Time Duration...${RESET}"
if [[ -z "$TIME_DURATION" ]]; then
  print_warning "'timeDuration' is empty."
  log_input "timeDuration" "$TIME_DURATION" false
else
  print_success "'timeDuration' is valid."
  log_input "timeDuration" "$TIME_DURATION" true
fi

# Validate testfilesList
TESTFILES_LIST="${TESTFILES_LIST:-}"
echo -e "${YELLOW}Validating Test Files List...${RESET}"

# Convert test files list into an array
IFS=' ' read -r -a testList <<< "$TESTFILES_LIST"

found_file=false

for testfile in "${testList[@]}"; do
  IFS='|' read -r filename folderpath <<< "$testfile"
  
  # Default folder path if not provided
  if [ -z "$folderpath" ]; then
    folderpath="$DEFAULT_PATH"
  fi
  
  # Construct full file path
  full_path="${folderpath}/${filename}"
  
  echo -e "${YELLOW}Checking file path: '$full_path'${RESET}"
  
  if [ ! -e "$full_path" ]; then
    print_warning "Path '$full_path' does not exist."
    log_input "testfilesList" "$full_path" false
  else
    found_file=true
    print_success "Path '$full_path' is valid."
    log_input "testfilesList" "$full_path" true
  fi
done

if [ "$found_file" = false ]; then
  print_warning "No valid files or directories found."
fi

# Export validated variables
echo "export THREADS_NUMBER=$THREADS_NUMBER" >> $GITHUB_ENV
echo "export BASE_URL=$BASE_URL" >> $GITHUB_ENV
echo "export TIME_DURATION=$TIME_DURATION" >> $GITHUB_ENV
echo "export TESTFILES_LIST=\"$TESTFILES_LIST\"" >> $GITHUB_ENV

print_success "All validations completed!"
