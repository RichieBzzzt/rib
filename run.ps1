Import-Module ..\rib -Force

$accountName = "bzzztio"
$proj = "MyFirstProject"
$usr = "richie@bzzzt.io"
$tkn = "xozx2cv3m3pfuuzwetevwqd5vtfjr6mz2f3q4ui5c7zbzgdjmora"
$releaseDefinitionId = 2
$buildArtifactName = "_prm-ci-pr"
$buildname = "prm_baton_pass"
$releaseName = "prm"
$buildToCheck = Get-VstsBuild -vstsAccount $accountName -projectName $proj -buildName $buildname -user $usr -token $tkn
# Write-Output $buildToCheck | ConvertTo-Json
# break

# $buildId = $buildToCheck.definition.id 
# #Invoke-VstsReleaseInBuild -vstsAccount $accountName -projectName $proj -releaseDefinitionId $releaseDefinitionId -buildName $buildname -buildArtifactName $buildArtifactName -user $usr -token $tkn

# # $buildOutput = Invoke-VstsBuild -vstsAccount $accountName -projectName $proj -buildId $buildId -user $usr -token $tkn
# # Write-Host $buildOutput

$release = Get-VstsReleaseByName -vstsAccount $accountName -projectName $proj -releaseName $releaseName -user $usr -token $tkn
Write-Output $release.releaseDefinition.id
$release | ConvertTo-Json
$bob = $release._links.self.href
$bob

$releaseArtifacts = Get-VstsRelease -vstsAccount $accountName -projectName $proj -releaseSelfUri $bob -user $usr -token $tkn
Write-Host $releaseArtifacts | ConvertTo-Json -Depth 5
Write-Host $releaseArtifacts.artifacts

#8b350f3e-ab46-4902-9450-5321a27a4077:21