# AWS Vault Override

[aws-vault](https://github.com/99designs/aws-vault) is a nifty utility that securely stores and access your AWS credentials. However, I am a creature of habit and it will take me years to switch from using the awscli to the aws-vault cli.

While the aws-vault [Usage Guide](https://github.com/99designs/aws-vault/blob/master/USAGE.md) provides an option to override the awscli, this didn't work in my situation.  I manage multiple aws enviornments and am constantly using the `--profile` option for awscli.  So I needed a way to capture the `aws` command and extract the `--profile` value and pass it to aws-vault.  

This simple script can be added as a script in your path or it can be added to your `.bash_profile` or `.zshrc` file to override the `aws` command

## In your `.bash_profile` or `.zshrc`

Add this code snippet to your `.bash_profile` or `.zshrc` file. (note: these are the only shells I've tested in so far)

```bash
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
```

## As a script in your path

You can also run this as a script, as long as it is higher in your `$PATH` than `aws`.  

```bash
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
```