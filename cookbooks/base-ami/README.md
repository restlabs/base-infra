# base-ami

Creates a base AMI 


## For Local Testing
```commandline
chef-client --local-mode --runlist "recipe[base-ami::default]" --why-run
```

## Linting
```commandline
cookstyle
```

## Remote Testing with Kitchen
```commandline
kitchen test
```

When finished with testing, destroy environment with
```commandline
kitchen destroy
```