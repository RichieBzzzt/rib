Function Get-VstsRelease {
    [CmdletBinding()]
    param(
        [string]
        [ValidateNotNullOrEmpty()]
        $vstsAccount
        , [string]
        [ValidateNotNullOrEmpty()]
        $projectName
        , [string]
        [ValidateNotNullOrEmpty()]
        $releaseSelfUri
        , [string]
        $user
        , [string]
        $token
    )
    if ($PSBoundParameters.ContainsKey('user') -eq $true) {
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $token))) 
    }
    $uri = $releaseSelfUri
    Write-Host $uri
    try {
        if ($PSBoundParameters.ContainsKey('user') -eq $true) {
        $result = Invoke-RestMethod -Uri $uri -Method GET -ContentType "application/json" -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo)}
        }
        else{
            $result = Invoke-RestMethod -Uri $uri -Method GET -ContentType "application/json" -Headers @{Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN"}
        }
        return $result
    }
    catch {
        Throw $_    
    }
}