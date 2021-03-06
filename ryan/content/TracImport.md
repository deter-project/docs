# Bugzilla

Ticket data can be imported from Bugzilla using the [bugzilla2trac.py](http://trac.edgewall.org/browser/trunk/contrib/bugzilla2trac.py) script, available in the contrib/ directory of the Trac distribution.

	
	$ bugzilla2trac.py
	bugzilla2trac - Imports a bug database from Bugzilla into Trac.
	
	Usage: bugzilla2trac.py [options]
	
	Available Options:
	  --db <MySQL dbname>              - Bugzilla's database
	  --tracenv /path/to/trac/env      - full path to Trac db environment
	  -h | --host <MySQL hostname>     - Bugzilla's DNS host name
	  -u | --user <MySQL username>     - effective Bugzilla's database user
	  -p | --passwd <MySQL password>   - Bugzilla's user password
	  -c | --clean                     - remove current Trac tickets before importing
	  --help | help                    - this help info
	
	Additional configuration options can be defined directly in the script.
	

Currently, the following data is imported from Bugzilla:

  * bugs
  * bug activity (field changes)
  * bug attachments
  * user names and passwords (put into a htpasswd file)

The script provides a number of features to ease the conversion, such as:

  * PRODUCT_KEYWORDS:  Trac doesn't have the concept of products, so the script provides the ability to attach a ticket keyword instead.

  * IGNORE_COMMENTS:  Don't import Bugzilla comments that match a certain regexp.

  * STATUS_KEYWORDS:  Attach ticket keywords for the Bugzilla statuses not available in Trac.  By default, the 'VERIFIED' and 'RELEASED' Bugzilla statuses are translated into Trac keywords.

For more details on the available options, see the configuration section at the top of the script.

# Sourceforge

Ticket data can be imported from Sourceforge using the [sourceforge2trac.py](http://trac.edgewall.org/browser/trunk/contrib/sourceforge2trac.py) script, available in the contrib/ directory of the Trac distribution.

See #Trac3521 for an updated sourceforge2trac script.

# Mantis

The mantis2trac script now lives at http://trac-hacks.org/wiki/MantisImportScript. You can always get the latest version from http://trac-hacks.org/changeset/latest/mantisimportscript?old_path=/&filename=mantisimportscript&format=zip

Mantis bugs can be imported using the attached script.

Currently, the following data is imported from Mantis:
  * bugs
  * bug comments
  * bug activity (field changes)
  * attachments (as long as the files live in the mantis db, not on the filesystem) 

If you use the script, please read the NOTES section (at the top of the file) and make sure you adjust the config parameters for your environment.

mantis2trac.py has the same parameters as the bugzilla2trac.py script:
	
	mantis2trac - Imports a bug database from Mantis into Trac.
	
	Usage: mantis2trac.py [options] 
	
	Available Options:
	  --db <MySQL dbname>              - Mantis database
	  --tracenv /path/to/trac/env      - Full path to Trac db environment
	  -h | --host <MySQL hostname>     - Mantis DNS host name
	  -u | --user <MySQL username>     - Effective Mantis database user
	  -p | --passwd <MySQL password>   - Mantis database user password
	  -c | --clean                     - Remove current Trac tickets before importing
	  --help | help                    - This help info
	
	Additional configuration options can be defined directly in the script.
	 

# Jira

The [Jira2Trac plugin](http://trac-hacks.org/wiki/JiraToTracIntegration) provides you with tools to import Atlassian Jira backup files into Trac.

The plugin consists of a Python 3.1 commandline tool that:

 - Parses the Jira backup XML file
 - Sends the imported Jira data and attachments to Trac using the [XmlRpcPlugin](http://trac-hacks.org/wiki/XmlRpcPlugin)
 - Generates a htpasswd file containing the imported Jira users and their SHA-512 base64 encoded passwords

# Other

Since trac uses a SQL database to store the data, you can import from other systems by examining the database tables. Just go into [sqlite](http://www.sqlite.org/sqlite.html) command line to look at the tables and import into them from your application.

## Using a comma delimited file - CSV
See [http://trac.edgewall.org/attachment/wiki/TracSynchronize/csv2trac.2.py] for details.  This approach is particularly useful if one needs to enter a large number of tickets by hand. (note that the ticket type type field, (task etc...) is also needed for this script to work with more recent Trac releases)
Comments on script: The script has an error on line 168, ('Ticket' needs to be 'ticket').  Also, the listed values for severity and priority are swapped. 

## Using an Excel (.xls) or comma delimited file (.csv)
This plugin http://trac-hacks.org/wiki/TicketImportPlugin lets you import into Trac a series of tickets from a CSV file or (if the xlrd library is installed) from an Excel file.

You can also use it to modify tickets in batch, by saving a report as CSV, editing the CSV file, and re-importing the tickets.

This plugin is very useful when starting a new project: you can import a list of requirements that may have come from meeting notes, list of features, other ticketing systems... It's also great to review the tickets off-line, or to do massive changes to tickets.

Based on the ticket id (or, if no id exists, on the summary) in the imported file, tickets are either created or updated. 


