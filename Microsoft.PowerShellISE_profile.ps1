# Global Modules
Import-Module AzureAD
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
Import-Module SkypeOnlineConnector
Import-Module MSOnline
Import-Module MillerModule
Import-Module Posh-Git

# Start ISESteroids
Start-Steroids

# Global Settings
New-Variable -Name ProfilePath -Value (Split-Path -Parent -Path $profile.CurrentUserCurrentHost) -Option Constant
New-Variable -Name CredFilePath -Value ([IO.Path]::Combine($ProfilePath,('{0}.xml' -f $env:USERNAME))) -Option Constant
#New-Variable -Name CodeSignCert -Value (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert) -Option Constant

# Global Functions
function Get-CurrentUsersEmailAddress {
  $domain = ([adsi]'LDAP://RootDSE').defaultNamingContext
  $searcher = [adsisearcher]("(&(objectCategory=user)(sAMAccountName=$env:USERNAME))")
  $searcher.SearchRoot = [adsi]("LDAP://$domain")
  $user = $searcher.FindOne()
  if ($user) {
    return $user.Properties.mail
  } else {
    return $null
  }
}

function Connect-SfBOnline {
  param (
  [string]$UserName
  )

  $session = New-CsOnlineSession -UserName $UserName
  if ($session) { Import-PSSession $session }
}

# Load ISE menu items
$O365root = $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("O365 Admin Shells",$null,$null)
[void]$O365root.Submenus.Add("Azure AD",{Connect-AzureAD -AccountId (Get-CurrentUsersEmailAddress)},$null)
[void]$O365root.Submenus.Add("Azure AD [MSOnline]",{Connect-MsolService},$null)
[void]$O365root.Submenus.Add("Exchange Online",{Connect-EXOShell -UserPrincipalName (Get-CurrentUsersEmailAddress)},$null)
[void]$O365root.Submenus.Add("Security & Compliance Center",{Connect-EOPShell -UserPrincipalName (Get-CurrentUsersEmailAddress)},$null)
[void]$O365root.Submenus.Add("Sharepoint Online",{Connect-SPOService -Url 'https://txu-admin.sharepoint.com'},$null)
#[void]$O365root.Submenus.Add("Skype for Business Online",{Connect-SfBOnline -UserName (Get-CurrentUsersEmailAddress)},$null)



