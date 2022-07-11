function Connect-TOPdeskAPI {
    <#
    .SYNOPSIS
        Creates a TOPdesk API key from a TOPdesk username and Application Password from Secure String.

    .PARAMETER Username
        Please enter the Base64 API Key here.

    .PARAMETER ApplicationPassword

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