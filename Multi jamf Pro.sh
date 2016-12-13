#!/bin/bash

# All defined constants
LOGGED_ON_USER=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
API_USER="api_user"
API_PASSWORD="api_password"
AUTOPKG_DIR="autopkg_dir"
RECIPE_LIST="RecipeList.txt"

# All defined jamfPro Server URLs
jamfPro[0]=casper01.company.com
jamfPro[1]=casper02.company.com

# All defined file share names
fileShare[0]=fileShare01
fileShare[1]=fileShare02

# All defined file share passwords
sharePassword[0]=sharePassword01
sharePassword[1]=sharePassword02

# Primary loop through all servers
for ((a = 0; a < ${#jamfPro[@]}; a++)); do

  /usr/libexec/PlistBuddy -c "Delete :JSS_REPOS array" /Users/"$LOGGED_ON_USER"/Library/Preferences/com.github.autopkg.plist

  /usr/bin/defaults write /Users/"$LOGGED_ON_USER"/Library/Preferences/com.github.autopkg.plist JSS_URL "https://${jamfPro[$a]}:8443/"
  /usr/bin/defaults write /Users/"$LOGGED_ON_USER"/Library/Preferences/com.github.autopkg.plist API_USERNAME "$API_USER"
  /usr/bin/defaults write /Users/"$LOGGED_ON_USER"/Library/Preferences/com.github.autopkg.plist API_PASSWORD "$API_PASSWORD"
  /usr/bin/defaults write /Users/"$LOGGED_ON_USER"/Library/Preferences/com.github.autopkg.plist JSS_VERIFY_SSL -bool false

  # Create our key and array
  /usr/libexec/PlistBuddy -c "Add :JSS_REPOS array" /Users/""$LOGGED_ON_USER""/Library/Preferences/com.github.autopkg.plist

  # For each distribution point, add a dict. This is the first array element, so it is index 0.
  /usr/libexec/PlistBuddy -c "Add :JSS_REPOS:0 dict" /Users/"$LOGGED_ON_USER"/Library/Preferences/com.github.autopkg.plist
  /usr/libexec/PlistBuddy -c "Add :JSS_REPOS:0:name string ${fileShare[$a]}" /Users/"$LOGGED_ON_USER"/Library/Preferences/com.github.autopkg.plist
  /usr/libexec/PlistBuddy -c "Add :JSS_REPOS:0:password string ${sharePassword[$a]}" /Users/"$LOGGED_ON_USER"/Library/Preferences/com.github.autopkg.plist

  /usr/local/bin/autopkg run --recipe-list "$AUTOPKG_DIR"/RecipeOverrides/"$RECIPE_LIST"

  # This isn't really recommended behavior, but I found after repeated runs Autopkg would stop picking up changes to preferences
  killall cfprefsd

done
