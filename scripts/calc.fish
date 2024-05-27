#!/bin/fish
## Calculator 🧮 ##

# Fuzzel prompt for mathematical expressions
# See https://fishshell.com/docs/current/cmds/math.html
# The ans variable stores the result of the last calulation and 
# can be used in the prompt

# Define history file
set HISTORY_FILE "$HOME/.calc_history"
touch $HISTORY_FILE

# Initialize the answer variable
set ans "0"

# Start a loop for the calculator prompt
while true
  # Prompt the user for an expression, showing the last answer
  # and expression history
  set expression (fuzzel -d -p "$ans : "< $HISTORY_FILE)

  # Exit the loop if the input is empty
  if test -z "$expression"
    break
  end

  # Replace occurrences of 'ans' and 'ANS' 
  # in the expression with the last answer
  set expression (string replace "ans" $ans $expression)
  set expression (string replace "ANS" $ans $expression)

  # Calculate the result using the math command and store it in ans
  if ! set ans (echo $expression | math)
    # Break the loop if it returns an error
    break
  end

  # Create a temporary file
  set tmp (mktemp)
  # Prepend the expression to the history file, store in tmp
  echo "$expression" | cat - $HISTORY_FILE > $tmp
  # Move the first 10 lines of the temp file to the history file
  head $tmp > $HISTORY_FILE
  # Remove duplicates from the history file
  awk '!seen[$0]++' $HISTORY_FILE > $tmp && mv $tmp $HISTORY_FILE

  # Copy answer to clipboard
  wl-copy $ans
end
