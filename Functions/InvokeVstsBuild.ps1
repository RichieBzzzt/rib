Function Invoke-VstsBuild {
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
        $buildId
        , [string]
        $user
        , [string]
        $token
    )

    if ($PSBoundParameters.ContainsKey('user') -eq $true) {
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $token))) 
    }
    $uri = "https://$($vstsAccount).visualstudio.com/$($projectName)/_apis/build/builds/?api-version=4.1"

    $body = "{
        ""parameters"":  ""{\""triggered.build.id\"":  \""3\""}"",
        ""definition"": {
            ""id"" : $buildId
        }
      }" 

      Write-Host $body

    try {
        if ($PSBoundParameters.ContainsKey('user') -eq $true) {
            $buildresponse = Invoke-RestMethod -Method Post -ContentType application/json -Uri $Uri -Headers @{Authorization=("Basic {0}" -f $base64authinfo)} -Body $body
        }
        else {
            $buildresponse = Invoke-RestMethod -Method Post -ContentType application/json -Uri $Uri -Headers @{Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN"} -Body $body
        }
    return $buildResponse
    }
    catch {
        Throw $_    
    }
}