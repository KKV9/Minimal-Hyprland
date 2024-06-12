#!/bin/fish
## Calculator 🧮 ##

# Fuzzel prompt for mathematical expressions
# See https://fishshell.com/docs/current/cmds/math.html
# The ans variable stores the result of the last calculation and 
# can be used in the prompt

# Add prompt options to history file
function append_options
  # Enter clear prompt option into history file
  if ! grep -q "clear" "$HISTORY_FILE"
    echo "clear" >> "$HISTORY_FILE"
  end
end

# Define history file
set HISTORY_FILE "$HOME/.calc_history"
# Define the answer variable
set ans "0"

# Initialise history file
touch "$HISTORY_FILE"
append_options

# Start a loop for the calculator prompt
while true
  # Prompt the user for an expression, showing the last answer
  # and expression history
  set expression (fuzzel -d -l 10 -w 60 --no-fuzzy -p "$ans : "<\
  "$HISTORY_FILE")

  # Clear history, reset variables and restart
  if test "$expression" = "clear"
    echo "clear" > "$HISTORY_FILE"
    set ans "0"
    continue
  end

  # Replace occurrences of 'ans' and 'ANS' 
  # in the expression with the last answer
  set expression (string replace -a "ans" "($ans)" "$expression")
  set expression (string replace -a "ANS" "($ans)" "$expression")

  # Calculate the result using the math command and store it in ans
  if ! set ans (echo "$expression" | math)
    # Break the loop if it returns an error
    break
  end
  
  # Create a temporary file
  set tmp (mktemp)
  # Prepend the expression to the history file, store in tmp
  echo "$expression" | cat - "$HISTORY_FILE" > "$tmp"
  # Move the first 9 lines of the temp file to the history file
  head -n 9 "$tmp" > "$HISTORY_FILE"
  # Remove duplicates from the history file
  awk '!seen[$0]++' "$HISTORY_FILE" > "$tmp" && mv "$tmp" "$HISTORY_FILE"

  # Ensure prompt options are available
  append_options

  # Copy answer to clipboard
  wl-copy "$ans"
end
