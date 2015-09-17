# Death To LCs
Cleans up unused AWS launch configs.

#Usage
```
git clone git@github.com:thekindofme/death_to_lcs.git
cd death_to_lcs
bundle install
ruby ./death_to_lcs.rb
```

By default, the script will delete all your unused launch configs.

##Dry run
```
ruby ./death_to_lcs.rb --dry
```

##Version
```
ruby ./death_to_lcs.rb --version
```

# Settings
Edit the .env file to change your AWS_REGION.

#Options


# References
This script was inspired by this [post](http://www.markomedia.com.au/delete-launch-config-programatically-aws/) by Marko.
