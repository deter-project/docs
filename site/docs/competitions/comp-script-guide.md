# Writing start up scripts for competitions

A good start up script for a competition has the following properties:

- Is project and experiment agnostic - it takes project and experiment names as arguments from command line. This enables scaling and portability.
- Limits access to specific experiment's nodes to red/blue team or removes access to all teams
- Installs needed software
- Starts scoring
- Makes any changes persist through reboots
- Ends up with node reboot

Please start from our [sample script with these features](start.pl) and version it to satisfy your needs.

!!! tip
    Don't forget to make your script executable