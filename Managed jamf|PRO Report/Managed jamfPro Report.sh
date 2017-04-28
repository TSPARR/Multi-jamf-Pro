#!/bin/bash
# Managed jamfPro Report.sh
# A script which iterates over specified jamfPro servers advanced search groups to grab the current number of managed devices.
# NOTE: This requires pre-populated Advanced Computer Searches and Advanced Mobile Device Searches named "All Managed OS X Devices" and "All Managed iOS Devices"


# All defined constants
OUTPUT_XML="/tmp/tempList.xml"
DATABASE="/tmp/tempList.DB"
REPORT_USER="api_user"
REPORT_PASSWORD="api_password"
COMPUTER_GROUP="All%20Managed%20OS%20X%20Devices"
MOBILE_DEVICE_GROUP="All%20Managed%20iOS%20Devices"

# All defined jamfPro Server URLs
jamfPro[0]=jss01.company.com
jamfPro[1]=jss02.company.com
jamfPro[2]=jss03.company.com
jamfPro[3]=jss04.company.com
jamfPro[4]=jss05.company.com
jamfPro[5]=jss06.company.com

# Creates the temp XML file if they don't already exist
[[ -f "$OUTPUT_XML" ]] || touch "$OUTPUT_XML"

# Creates the SQLite database for reporting purposes
/usr/bin/sqlite3 "$DATABASE" "CREATE TABLE jamfPro (jamfPro_server TEXT, managed_computers TEXT, managed_mobile_devices TEXT, application TEXT, policy_name TEXT, package_name_policy TEXT, smart_group TEXT, package_name_group TEXT)"

# Primary loop through all servers
for ((a = 0; a < ${#jamfPro[@]}; a++)); do

    # Makes an API call based on the group name and saves it to the defined location for later parsing
    curl -s -H "Accept: application/xml" "https://${jamfPro[$a]}:8443/JSSResource/advancedcomputersearches/name/$COMPUTER_GROUP" --user "$REPORT_USER:$REPORT_PASSWORD" > "$OUTPUT_XML"

    # Uses XMLlint to parse the output XML for the count defined in the policy
    managed_computer_count=$(xmllint "$OUTPUT_XML" --xpath /advanced_computer_search/computers/size)

    #trim the XML keys from the variable
    managed_computer_count=${managed_computer_count#<size>}
    managed_computer_count=${managed_computer_count%</size>}

    # Makes an API call based on the group name and saves it to the defined location for later parsing
    curl -s -H "Accept: application/xml" "https://${jamfPro[$a]}:8443/JSSResource/advancedmobiledevicesearches/name/$MOBILE_DEVICE_GROUP" --user "$REPORT_USER:$REPORT_PASSWORD" > "$OUTPUT_XML"

    # Uses XMLlint to parse the output XML for the count defined in the policy
    managed_mobile_device_count=$(xmllint "$OUTPUT_XML" --xpath /advanced_mobile_device_search/mobile_devices/size)

    #trim the XML keys from the variable
    managed_mobile_device_count=${managed_mobile_device_count#<size>}
    managed_mobile_device_count=${managed_mobile_device_count%</size>}

    # Inserts the information gathered into the defined SQLlite database for later parsing
    /usr/bin/sqlite3 "$DATABASE" "INSERT INTO jamfPro (jamfPro_server, managed_computers, managed_mobile_devices, application, policy_name, package_name_policy, smart_group, package_name_group) VALUES ('${jamfPro[$a]}', '$managed_computer_count', '$managed_mobile_device_count', '${application[$b]}', '$policy_readable_name', '$policy_package_name', '$smart_group_readable_name', '$smart_group_package_criteria')"

done

#
# In the SQLITE section below, do not indent. The columns part of '.mode' could be a variable to offer different
# output like list, csv, even html read .help in sqlite3 for more information.
#
# One danger is if a semicolon is ever embedded in the ${servername} it could break the SQL statements.
# See https://xkcd.com/327/ for more information.
for servername in $(/usr/bin/sqlite3 "$DATABASE" "SELECT DISTINCT jamfPro_server FROM jamfPro ; ")
do
    echo
    echo "Server: "$servername
    /usr/bin/sqlite3 "$DATABASE" << SQLITE
.headers on
.mode columns
.print "==================================="
SELECT managed_computers, managed_mobile_devices FROM jamfPro WHERE jamfPro_server = "$servername";
.print "==================================="
.quit
SQLITE
done

# Prints all data to the STDOUT
# sqlite3 -column -header "$DATABASE" "SELECT * FROM jamfPro"

# Removes the temporary database and XML files
rm "$DATABASE"
rm "$OUTPUT_XML"
