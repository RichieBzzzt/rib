Function Get-VstsReleaseByName {
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
        $releaseName
        , [string]
        $user
        , [string]
        $token
    )
    if ($PSBoundParameters.ContainsKey('user') -eq $true) {
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $token))) 
    }
    $uri = "https://$($vstsAccount).vsrm.visualstudio.com/$($projectName)/_apis/release/releases?api-version=4.1-preview.6"
    Write-Host $uri
    try {
        if ($PSBoundParameters.ContainsKey('user') -eq $true) {
        $result = Invoke-RestMethod -Uri $uri -Method GET -ContentType "application/json" -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo)}
        }
        else{
            $result = Invoke-RestMethod -Uri $uri -Method GET -ContentType "application/json" -Headers @{Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN"}
        }
        $e = $result.value | Where-Object {$_.releaseDefinition.name -eq $releaseName }
        $releaseToCheck = $e | Select-Object -First 1
        return $releaseToCheck
    }
    catch {
        Throw $_    
    }
}