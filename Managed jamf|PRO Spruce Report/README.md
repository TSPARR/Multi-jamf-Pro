# Managed jamfPro Spruce Report.sh
This script will allow you to run Spruce reports against multiple jamf Pro servers. As such, it requires https://github.com/sheagcraig/Spruce. Please reference install guides and GitHub page if you have any issues getting your environment setup.

## Defined Variable Explanation

**API_USER** - The account JSS Importer will use. It requires specific privileges defined at https://github.com/sheagcraig/JSSImporter#setup
<br>
**API_PASSWORD** - The password for the account defined above
<br>
**REPORT_DIR** - The directory where reports are to be saved i.e. `/Users/<user name>/Documents/Spruce`
<br>
**SPRUCE_DIR** - The directory where Spruce currently lives i.e. `/Applications`
<br>
**jamfPro[0]** - The first jamf Pro server you wish to run recipes against
<br>

## Future Work            
It's important to note that the script as is works well for my situation. I'm putting it up because I think it can be useful for others. That being said, there are definitely areas of improvement that I (or anyone who wishes) will eventually be adding.
