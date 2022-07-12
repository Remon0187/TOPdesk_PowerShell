function Connect-TOPdeskAPI {
    <#
    .DESCRIPTION
        Converts TOPdesk username and Application password to base64 string for usage in API request. Also saves the connection details as a global variable for use in other modules.
    .PARAMETER Username
        Please enter the Base64 API Key here.

    .PARAMETER ApplicationPassword
        Please enter the Application Password from TOPdesk here.
    .EXAMPLE
        PS C:\> Set-TOPdeskApiKey
    #>
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Username,
        [Parameter(Mandatory = $true)]
        [string]$ApplicationPassword,
        [Parameter(Mandatory = $true)]
        [string]$Base_Url
    )

    # API Credentials for Authentication header
    $Pair = "$($Username):$($ApplicationPassword)"

    # Encode API Credentials
    $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
    $basicAuthValue = "Basic $encodedCreds"

    $ConnectionTest = Test-NetConnection -ComputerName $Base_Url

    if ($ConnectionTest.PingSucceeded -eq $true) {

        $global:Base_Url = $Base_Url + '/tas/api'
        Write-Output "Base URL is set to $global:Base_Url"
        $global:Api_key = $basicAuthValue
        Write-Output 'API key is set'
        

    }
}