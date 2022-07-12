function Get-TOPdeskOperator {

    <#
    .DESCRIPTION 
        Returns id, name pair if the user is an active TOPdesk Operator. Archived users are excluded. 
        Boolean is useful for including in a workflow which requires to check if an user is a TOPdesk Operator.
    
    .PARAMETER Name
        Name of the operator to look up      

    .PARAMETER Api_Endpoint
        The API endpoint that will be used as part of the HTTP request.

    .PARAMETER Boolean
        Returns boolean True if the found user is an active operator.

    #>
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Name,
        [Parameter(Position = 2, Mandatory = $false)]
        [string]$Api_Endpoint = '/operators/lookup/',
        [Parameter(Position = 4, Mandatory = $false)]
        [switch]$Boolean

    )
    
    $Api_Key = $global:Api_Key
    $Base_url = $global:Base_url

    # Encode URL for spaces
    Add-Type -AssemblyName System.Web
    $Uri = ('{0}{1}?name=' -f $Base_Url, $Api_Endpoint) + [System.Web.HttpUtility]::UrlEncode($Name) + ('&archived=false')

    # Header
    $Header = @{
        'Authorization' = "Basic $Api_Key"
    }

    $params = @{
        Header      = $Header
        Uri         = $Uri
        Method      = 'GET'
        ContentType = 'Application/JSON'
    }

    # Send Request 
    try {
        $OperatorResult = Invoke-RestMethod @params
    }
    catch { 
        Write-Error $_.Exception.Message
    } 
    # Returns True if the person is an active Operator
    if ($Boolean) {
        if ($OperatorResult.results) {
            return $True
        
        }
        else {
            return $False
        }
    }
    if ($OperatorResult.results) {
        return $OperatorResult.results
    }
}


