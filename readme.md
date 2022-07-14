# TOPdesk_PowerShell
`TOPdesk_PowerShell` is a PowerShell module for various TOPdesk API's. It allows users to programatically retrieve data from TOPdesk and includes cmdlets which are useful for including in workflows and automating processes. 

## Requirements
Before you can use this module, please view the requirements here for the TOPdesk configuration. https://developers.topdesk.com/tutorial.html. 

## Authentication
To work with the API it expects an application password, not the password used to login to the web interface. So the first step is to set up an application password. I've created the `Connect-TOPdeskAPI` command that makes is easier to save and re-use the API authentication details.
