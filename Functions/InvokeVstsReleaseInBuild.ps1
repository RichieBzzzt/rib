Function Invoke-VstsReleaseInBuild {
    [CmdletBinding()]
    param(
        [string]
        [ValidateNotNullOrEmpty()]
        $vstsAccount
        , [string]
        [ValidateNotNullOrEmpty()]
        $projectName
        , [int]
        [ValidateNotNullOrEmpty()]
        $releaseDefinitionId
        , [string]
        $buildName
        , [string]
        [ValidateNotNullOrEmpty()]
        $buildArtifactName
        , [string]
        $user
        , [string]
        $token
    )
    if ($PSBoundParameters.ContainsKey('user') -eq $true) {
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $token)))
    }
    if (-not $Env:triggeredbuildid) {
        Write-Host "triggeredbuildid environment variable is missing. This means that build has been kicked off manually. Will attempt to get last successful build, which may not be correct!"
        try {
            if ($PSBoundParameters.ContainsKey('user') -eq $true) {
                $buildToCheck = Get-VstsBuild -vstsAccount $vstsAccount -projectName $projectName -buildName $buildName -user $user -token $token
                $bi = $buildToCheck.definition.id 
            }
            else {
                $buildToCheck = Get-VstsBuild -vstsAccount $vstsAccount -projectName $projectName -buildName $buildName
                $bi = $buildToCheck.definition.id
            }
        }
        catch {
            Throw $_
        }
    }
    else {
        $bi = $Env:triggeredbuildid
    }
    Write-Host $bi
    $body = @{
        "definitionId" = "$($releaseDefinitionId)"
        "description"  = "Creating automated release"
    }
    $body.Add("artifacts", @())
    $artifact = @{
        "alias"             = "$($buildArtifactName)"
        "instanceReference" = @{
            "id"   = "$($bi)"
            "name" = $null
        }
    }
    $body.artifacts += $artifact
    $jsonBody = $body | ConvertTo-Json -Depth 5
    
    try {
        $uri = "https://$($vstsAccount).vsrm.visualstudio.com/$($projectName)/_apis/release/releases?api-version=4.1-preview.6" 
        if ($PSBoundParameters.ContainsKey('user') -eq $true) {
            $result = Invoke-RestMethod -Uri $uri -Method POST -ContentType "application/json" -Body $jsonBody -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo)}
        }
        else {
            $result = Invoke-RestMethod -Uri $uri -Method POST -ContentType "application/json" -Body $jsonBody -Headers @{Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN"}
        }
        $monitorUrl = $result.Url
        Write-Host $monitorUrl
        if ($PSBoundParameters.ContainsKey('user') -eq $true) {
            $monitor = Invoke-RestMethod -Uri $monitorUrl -Method GET -ContentType "application/json" -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo)}
        }
        else {
            $monitor = Invoke-RestMethod -Uri $monitorUrl -Method GET -ContentType "application/json" -Headers @{Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN"}
        }
        Write-Host "Checking status of release. Please wait, this could take some time..."
        while (($monitor.environments[0].status -eq "queued") -or ($monitor.environments[0].status -eq "inProgress")) {
            Start-Sleep -Seconds 5
            if ($PSBoundParameters.ContainsKey('user') -eq $true) {
                $monitor = Invoke-RestMethod -Uri $monitorUrl -Method GET -ContentType "application/json" -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo)}
            }
            else {
                $monitor = Invoke-RestMethod -Uri $monitorUrl -Method GET -ContentType "application/json" -Headers @{Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN"}
            }
        }
        if ($($monitor.environments[0].status) -ne "succeeded") {
            throw "oh dear, release has failed."
        }
        else {
            Write-Host "Hooray! The release has passed!"
        }
    }
    catch {
        Throw $_    
    }
}