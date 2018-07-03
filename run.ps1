Import-Module ..\rib -Force

$accountName = "bzzztio"
$proj = "MyFirstProject"
$usr = "richie@bzzzt.io"
$tkn = "xozx2cv3m3pfuuzwetevwqd5vtfjr6mz2f3q4ui5c7zbzgdjmora"
$releaseDefinitionId = 2
#$buildId = Get-VstsBuild -vstsAccount $accountName -projectName $proj -buildName $buildname -user $usr -token $tkn
$buildArtifactName = "_prm-ci-pr"
$buildname = "prm-ci-pr"
cls
Invoke-VstsReleaseInBuild -vstsAccount $accountName -projectName $proj -releaseDefinitionId $releaseDefinitionId -buildName $buildname -buildArtifactName $buildArtifactName -user $usr -token $tkn