```powershell
#region users
Write-Host "WARNING: This will ensure that all accounts are authorized!"
Start-Sleep -Seconds 2

$uaccounts = Get-WmiObject Win32_UserAccount -Filter 'LocalAccount=True' | Select-Object -ExpandProperty Name

foreach ($user in $uaccounts) {
    $authorized = Read-Host "Is '$user' an authorized user? (Yes/No)"
    
    if ($authorized -eq 'No') {
        Write-Host "Deleting user '$user'..."
        net user $user /Delete /Yes
        Get-WmiObject -Class Win32_UserProfile -Filter "LocalPath LIKE '%$user%'" | Remove-WmiObject
        Write-Host "User '$user' deleted."
    }
    elseif ($authorized -eq 'Yes') {
        Write-Host "User '$user' is authorized."
    }
}

Clear-Host
Write-Host "All users have been managed."
Start-Sleep -Seconds 5
#endregion users

Clear-Host
#region admins
Write-Host "WARNING: This will ensure all ADMIN accounts are authorized, but double check!"
Start-Sleep -Seconds 2

$admins = net localgroup administrators | Where-Object { $_ -and $_ -notmatch "command completed successfully" } | Select-Object -Skip 4

foreach ($admin in $admins) {
    $authorized = Read-Host "Is '$admin' an authorized Admin? (Yes/No)"
    
    if ($authorized -eq 'No') {
        Write-Host "Removing admin '$admin' from administrators group..."
        net localgroup administrators $admin /Delete
        Write-Host "Admin '$admin' removed from administrators group."
    }
    elseif ($authorized -eq 'Yes') {
        Write-Host "Admin '$admin' is authorized."
    }
}

Clear-Host
Write-Host "All Admin accounts have been checked."
Start-Sleep -Seconds 5
#endregion admins

Clear-Host
#region enable
Write-Host "WARNING: This will ensure all authorized accounts are enabled!"
Start-Sleep -Seconds 2

$disabledAccounts = Get-WmiObject Win32_UserAccount -Filter 'Disabled=True or Lockout=True' | Select-Object -ExpandProperty Name

foreach ($account in $disabledAccounts) {
    $enable = Read-Host "User account '$account' is locked out or disabled. Do you want to enable? (Yes/No)"
    
    if ($enable -eq 'Yes') {
        Write-Host "Enabling account '$account'..."
        net user $account /Active:Yes
        Write-Host "Account '$account' enabled."
    }
    elseif ($enable -eq 'No') {
        Write-Host "Account '$account' will not be enabled."
    }
}

Clear-Host
Write-Host "All locked or disabled users have been managed."
Start-Sleep -Seconds 5
#endregion enable

Clear-Host
#region password
Write-Host "WARNING: Setting a new password for all accounts!"
Start-Sleep -Seconds 2

$newPassword = Read-Host 'Enter a new password for all accounts' -AsSecureString
$plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPassword))

$accounts = Get-WmiObject Win32_UserAccount -Filter 'LocalAccount=True' | Select-Object -ExpandProperty Name

foreach ($account in $accounts) {
    Write-Host "Setting password for account '$account'..."
    net user $account $plainPassword
    Write-Host "Password set for account '$account'."
}

Clear-Host
Write-Host "All user account passwords set."
Start-Sleep -Seconds 5
#endregion password

Clear-Host
#region password policies
Write-Host "Setting Password policies..."
Start-Sleep -Seconds 2

net accounts /MinPWLen:8 /MaxPWAge:30 /MinPWAge:10 /UniquePW:5
net accounts /LockoutThreshold:3

Write-Host "Password Policies Set!"
Start-Sleep -Seconds 5
#endregion password policies

Clear-Host
#region Guest account
Write-Host "Disabling Guest and Administrator accounts."
Start-Sleep -Seconds 2

net user guest /Active:No
net user Administrator /Active:No

Write-Host "Accounts Disabled."
Start-Sleep -Seconds 5
#endregion Guest account
```
