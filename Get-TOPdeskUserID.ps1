function Get-TOPdeskUserID {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    
    begin {
        # Default Variables
        $Api_Key = $global:Api_Key
        $Topdesk_base_url = $global:Base_url
        $Topdesk_api_endpoint = '/persons/lookup'
    }
    
    process {
        # Authentication
        $Headers = @{
            'Authorization' = $ApiKey
        }

        # Default Search Filter, No archive and 1 result only.
        $Body = @{
            'name'     = "$Name"
            'archived' = 'False'
            '$top'     = '1'
        }
 
        # Create ApiCall
        $ApiCall = @{

            Uri         = '{0}{1}' -f $Topdesk_base_url, $Topdesk_api_endpoint
            Headers     = $Headers
            Body        = $Body
            Method      = 'GET'
            ContentType = 'Application/JSON'

        }

        # Send HTTP request
        try {
            $Response = Invoke-RestMethod @ApiCall
            $ResponsePersonID = $Response.results.id

            if ([string]::IsNullOrEmpty($ResponsePersonID)) {
                Write-Verbose -Verbose "Person not found in TOPdesk"
                throw "$Name not found in TOPdesk"
            }

            else {
                write-verbose -verbose "Person found in TOPdesk"
                return $ResponsePersonID
            }
        }
        catch { 
            "Failed to get data from TOPdesk, {0}" -f $_.Exception.Message
        }
    }
}


