$project = "myproject"
$tri = "bbb"
$domain = "mydomain.fr"
$dns_name = "test" 
$netbiosname = "netbiosname"
$upnsuffix = "upnsuffix"
$cert_name = "certificate.pfx"
$AD_Users_name = "infra-bbb-AD-Users.csv"
$Import_AD_Users = "Import-AD_Users.ps1"

#Domaine
$DomainNetbiosName = $dns_name
$DomainName = $dns_name+".local"
# Resource Group & Location
$rg_name = "infra-$($tri)"
$location = "northeurope"
# Network Resources
$vnet_name = "infra-$tri-vnet"
$vnet_add_prefix = "10.0.0.0/16"
$externalSubnet_name = "infra-$tri-int"
$externalSubnet_add_prefix = "10.0.1.0/24"
$internalSubnet_name = "infra-$tri-ext"
$internalSubnet_add_prefix = "10.0.2.0/24"

# virtual Machines
$vm_adfs_name = "$tri-AZ-ADFS01"
$vm_ad_name = "$tri-AZ-AD01"
$vm_wap_name = "$tri-AZ-WAP01"
$vm_win10_name = "$tri-AZ-WIN10"

# Define the Script for VM Extension
$script_ad = '$ErrorActionPreference="SilentlyContinue"' + "`n"
$script_ad += 'Stop-Transcript | out-null' + "`n"
$script_ad += '$ErrorActionPreference = "Continue"' + "`n"
$script_ad += 'Start-Transcript -path C:\output_ad_VMExtension.txt -append' + "`n"

$script_ad += "Add-WindowsFeature AD-Domain-Services `n"
$script_ad += "Add-WindowsFeature DNS `n"
$script_ad += "Import-Module ADDSDeployment `n"
$script_ad += '$password = "' + "$vm_dsrm_password" + '"' + " | ConvertTo-SecureString -asPlainText -Force `n"
$script_ad += 'Install-ADDSForest -SafeModeAdministratorPassword $password -DatabasePath C:\windows\NTDS -DomainMode WinThreshold -DomainName test.local -DomainNetbiosName test -ForestMode WinThreshold -InstallDns -LogPath C:\windows\NTDS -SysvolPath C:\windows\SYSVOL -Force' + "`n"
$script_ad += 'curl -o "C:\' + "$Import_AD_Users" + '" https://intrastorageaccount.blob.core.windows.net/vmextensions/' + "$Import_AD_Users" + '"' + "`n"
$script_ad += 'curl -o "C:\' + "$AD_Users_name" + '" https://intrastorageaccount.blob.core.windows.net/vmextensions/' + "$AD_Users_name" + '"' + "`n"
$script_ad += 'C:\' + "$Import_AD_Users" + "`n"

$script_ad += 'Stop-Transcript_ad'


$item_script_ad = New-Item -Path . -Name "ad_vmextension.ps1" -ItemType "file" -Value $script_ad -Force
