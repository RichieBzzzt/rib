Function Get-VstsBuild {
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
        $buildName
        , [string]
        $user
        , [string]
        $token
    )
    if ($PSBoundParameters.ContainsKey('user') -eq $true) {
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $token))) 
    }
    $uri = "https://$($vstsAccount).visualstudio.com/$($projectName)/_apis/build/builds/?api-version=4.1"
    Write-Host $uri
    try {
        if ($PSBoundParameters.ContainsKey('user') -eq $true) {
        $result = Invoke-RestMethod -Uri $uri -Method GET -ContentType "application/json" -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo)}
        }
        else{
            $result = Invoke-RestMethod -Uri $uri -Method GET -ContentType "application/json" -Headers @{Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN"}
        }
        $e = $result.value | Where-Object {$_.definition.name -eq $buildName -and $_.status -eq "completed" }
        $buildToCheck = $e | Select-Object -First 1
        return $buildToCheck.id
    }
    catch {
        Throw $_    
    }
}


