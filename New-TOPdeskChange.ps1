function New-TOPdeskChange {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BriefDescription,

        [Parameter(Mandatory = $true)]
        [string]$Request,

        [Parameter(Mandatory = $true)]
        [string]$RequesterID,

        [Parameter(Mandatory = $true)]
        [string]$ChangeTemplateID,

        [Parameter(Mandatory = $false)]
        [string]$AlternativeRequesterID
    )
    
    begin {
        # Default Variables 
        $Topdesk_base_url = $global:Base_url
        $Topdesk_api_endpoint = '/operatorChanges'
        $Topdesk_api_key = $global:Api_Key
        $Topdesk_change_id = $ChangeTemplateID
        $Topdesk_person_id = $RequesterID

        # Person ID of Service Automation Account
        $Topdesk_Alternative_ID = $AlternativeRequesterID
    }
    
    process {
        # Authentication
        $Headers =
        @{
            'Authorization' = "$Topdesk_api_key"
        }

        # If no Manager exists, use SA Account for creating Change
        if ([string]::IsNullOrWhiteSpace($Topdesk_person_id)) {
            $Topdesk_person_id = $Topdesk_Alternative_ID

            # TOPdesk Change JSON
            $Body = @{
                template         = @{ 
                    id = $Topdesk_change_id
                }
                requester        = @{
                    id = $Topdesk_person_id
                }
                briefDescription = "$BriefDescription"
                request          = "$Request"
                changetype       = "Simple"
            }

            # Send request to TOPdesk API
            $ApiCall = @{

                Uri         = '{0}{1}' -f $Topdesk_base_url, $Topdesk_api_endpoint
                Headers     = $Headers
                Body        = (ConvertTo-Json -InputObject $Body)
                Method      = 'POST'
                ContentType = 'Application/JSON'

            }

            try {
                $Response = Invoke-RestMethod @ApiCall
                return $Response.number
            }
            catch { 
                "Failed to get data from TOPdesk, {0}" -f $_.Exception.Message
            }
        }
    }
}