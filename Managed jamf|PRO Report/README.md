# Managed jamf Pro Report.sh
This script will allow you to run a report against multiple jamf Pro servers to build a report listing the number of managed computers and devices.

## Setup
Create an Advanced Computer Search and an Advanced Mobile Device Search as structured below:

#### Advanced Computer Search
Name: All Managed OS X devices
<br>
Criteria: Managed is Managed

#### Advanced Mobile Device Search
Name: All Managed iOS devices
<br>
Criteria: Managed is Managed

If you wish to change any names, the variables in the script will need changed to match.

## Defined Variable Explanation

**OUTPUT_XML** - The temporary location where XML files will be downloaded to. It gets deleted at the end, so it's recommended to not change from the default location.
<br>
**DATABASE** - The temporary location where the SQLite database is created. It gets deleted at the end, so it's recommended to not change from the default location.
<br>
**REPORT_USER** - The API user which will reach out and grab the information. It needs at a bare minimum read access to Advanced Computer Searches and Advanced Mobile Device Searches.
<br>
**REPORT_PASSWORD** - The password for the API user defined above.
<br>
**jamfPro[0]** - The FQDN of your jamf Pro servers. Feel free to add as many to the array as necessary.
