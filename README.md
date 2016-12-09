This script will allow you to run .jss recipes from AutoPkg against multiple jamf Pro servers. As such, it requires https://github.com/autopkg/autopkg and https://github.com/sheagcraig/JSSImporter. Using https://github.com/lindegroup/autopkgr can help speed up the install process. Please reference their respective install guides and GitHub pages if you have any issues getting your environment setup.

### Defined Variable Explanation ###

API_USER - The account JSS Importer will use. It requires specific privileges defined at https://github.com/sheagcraig/JSSImporter#setup
API_PASSWORD - The password for the account defined above
AUTOPKG_DIR - The directory where AutoPkg currently lives along with Recipes and Repos i.e. /Users/<user name>/Documents/AutoPkg/
RECIPE_LIST - The name of the list of recipes you wish to run against all servers.  See here for more info: https://github.com/autopkg/autopkg/wiki/Running-Multiple-Recipes#recipe-lists Note: Only one recipe list is currently supported.
jamfPro[0] - The first jamf Pro server you wish to run recipes against
fileShare[0] - The name of the master share defined in File Share Distribution Points of the above jamf Pro server. Note: Only one distribution point per server is currently supported.
sharePassword[0] - The Read/Write password for the above share.

####        Future Work         ####               
It's important to note that the script as is works well for my situation. I'm putting it up because I think it can be useful for others. That being said, there are definitely areas of improvement that I (or anyone who wishes) will eventually be adding.

1.) Support for multiple recipe lists
2.) Support for multiple distribution points
3.) Support for multiple API users
