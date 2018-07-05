$exoPSModulePath = $((Get-ChildItem -Path $($env:LOCALAPPDATA+"\Apps\2.0\") -Filter Microsoft.Exchange.Management.ExoPowershellModule.dll -Recurse).FullName | ? {$_ -notmatch "_none_"} | Select-Object -First 1)

Import-Module $exoPSModulePath
Import-Module MillerModule
Import-Module Posh-Git
