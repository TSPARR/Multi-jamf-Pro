#!/bin/bash
# Spruce Report.sh
# A script which iterates over specified jamfPro servers to run Spruce reports against them

# All defined constants
LOGGED_ON_USER=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
API_USER=""
API_PASSWORD=""
REPORT_DIR="/Users/<user name>/Documents/Spruce"
SPRUCE_DIR="/Applications"

# All defined jamfPro Server URLs
jamfPro[0]=jss00.company.com
jamfPro[1]=jss01.company.com
jamfPro[2]=jss02.company.com
jamfPro[3]=jss03.company.com
jamfPro[4]=jss04.company.com
jamfPro[5]=jss05.company.com
jamfPro[6]=jss06.company.com

# Primary loop through all servers
for ((a = 0; a < ${#jamfPro[@]}; a++)); do

  # /usr/libexec/PlistBuddy -c "Delete :JSS_REPOS array" /Users/"$LOGGED_ON_USER"/Library/Preferences/com.github.autopkg.plist

  # Set AutoPkg preferences for specific to each jamfPro server
  /usr/bin/defaults write /Users/"$LOGGED_ON_USER"/Library/Preferences/com.github.autopkg.plist JSS_URL "https://${jamfPro[$a]}:8443/"
  /usr/bin/defaults write /Users/"$LOGGED_ON_USER"/Library/Preferences/com.github.autopkg.plist API_USERNAME "$API_USER"
  /usr/bin/defaults write /Users/"$LOGGED_ON_USER"/Library/Preferences/com.github.autopkg.plist API_PASSWORD "$API_PASSWORD"
  /usr/bin/defaults write /Users/"$LOGGED_ON_USER"/Library/Preferences/com.github.autopkg.plist JSS_VERIFY_SSL -bool false
  /usr/bin/defaults write /Users/"$LOGGED_ON_USER"/Library/Preferences/com.github.autopkg.plist JSS_MIGRATED -bool true

  killall cfprefsd

  "$SPRUCE_DIR"/spruce.py -o "$REPORT_DIR"/"${jamfPro[$a]}".xml

done
