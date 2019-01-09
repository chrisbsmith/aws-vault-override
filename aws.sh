#!/bin/bash

# Alias for aws-vault
aws() {
       awscli=$(which aws)
       # Convert the arguments to a string
       str="$*"
       # Extract the value that comes after --profile
       profile=$(echo "$str" | sed -n  's/.*--profile \([^[:space:]]*\).*/\1/p')
       p="--profile "
       # Remove the profile value and the word --profile from the command so it can be
       # passed to aws-vault
       cmd=${str//$profile/}
       cmd=${cmd//$p/}

       # Pass the profile and command to aws-vault
       aws-vault exec ${profile:-default} -- $awscli $(echo $cmd)

       # If aws-vault doesn't recognize the profile, pass the entire string to aws
       [[ $? -eq 1 ]] && $awscli $@
}
