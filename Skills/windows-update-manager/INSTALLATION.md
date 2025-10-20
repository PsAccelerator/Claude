# Installation Guide

## Prerequisites

1. **Windows Operating System**
   - Windows 10 or Windows 11
   - Windows Server 2016 or later

2. **PowerShell**
   - PowerShell 5.1 or later (included with Windows 10/11)
   - Or PowerShell 7+ (recommended)

3. **Administrator Rights**
   - Required for installing updates and modules

## Installation Steps

### Step 1: Set Execution Policy

Open PowerShell as Administrator and run:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**What this does:** Allows running locally created scripts while requiring downloaded scripts to be signed.

### Step 2: Install PSWindowsUpdate Module

The script will automatically install this module if missing, but you can install it manually:

```powershell
Install-Module PSWindowsUpdate -Force -Scope CurrentUser
```

### Step 3: Verify Installation

Check if the module is installed:

```powershell
Get-Module -ListAvailable PSWindowsUpdate
```

### Step 4: Test the Script

Navigate to the skill directory:

```powershell
cd "C:\Users\p.amersfoort\Claude\Skills\windows-update-manager"
```

Run a check (no changes made):

```powershell
.\Windows-Update-Manager.ps1 -Action Check
```

## Security Considerations

### Execution Policy Options

| Policy | Description | Recommendation |
|--------|-------------|----------------|
| Restricted | No scripts allowed | Too restrictive |
| AllSigned | Only signed scripts | Most secure, requires code signing |
| RemoteSigned | Local scripts OK, downloaded must be signed | **Recommended** |
| Unrestricted | All scripts allowed | Use with caution |

### To check current policy:
```powershell
Get-ExecutionPolicy -List
```

### To set for current user only (recommended):
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### To set system-wide (requires admin):
```powershell
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine
```

## Alternative: Bypass Execution Policy (One-Time)

If you don't want to change the execution policy, run the script with bypass:

```powershell
PowerShell.exe -ExecutionPolicy Bypass -File .\Windows-Update-Manager.ps1 -Action Check
```

## Scheduled Task Setup

To run updates automatically:

### Option 1: Simple Weekly Updates

```powershell
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-ExecutionPolicy Bypass -File `"C:\Users\p.amersfoort\Claude\Skills\windows-update-manager\Windows-Update-Manager.ps1`" -Action Install -AutoReboot"

$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 2AM

$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -TaskName "Windows Update Manager - Weekly" `
    -Action $action `
    -Trigger $trigger `
    -Principal $principal `
    -Description "Automated Windows updates every Sunday at 2 AM"
```

### Option 2: Monthly Updates (Patch Tuesday)

```powershell
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-ExecutionPolicy Bypass -File `"C:\Users\p.amersfoort\Claude\Skills\windows-update-manager\Windows-Update-Manager.ps1`" -Action Install -AutoReboot"

# Second Tuesday of each month at 3 AM
$trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Tuesday -At 3AM

$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -TaskName "Windows Update Manager - Monthly" `
    -Action $action `
    -Trigger $trigger `
    -Principal $principal `
    -Description "Automated Windows updates on Patch Tuesday"
```

### To view scheduled tasks:
```powershell
Get-ScheduledTask | Where-Object {$_.TaskName -like "*Windows Update Manager*"}
```

### To remove a scheduled task:
```powershell
Unregister-ScheduledTask -TaskName "Windows Update Manager - Weekly" -Confirm:$false
```

## Network Configuration

### If Behind a Proxy

Edit the script or create a config file with:

```powershell
# Set proxy for PowerShell
$proxy = "http://proxy.company.com:8080"
[System.Net.WebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy($proxy)
$env:HTTP_PROXY = $proxy
$env:HTTPS_PROXY = $proxy
```

### Firewall Rules

Ensure Windows Update service can connect:
- **Service:** Windows Update (wuauserv)
- **Ports:** 80 (HTTP), 443 (HTTPS)
- **Domains:** 
  - *.windowsupdate.microsoft.com
  - *.update.microsoft.com
  - *.download.windowsupdate.com

## Troubleshooting Installation

### Module Won't Install

**Error:** "Unable to download from URI"

**Solution 1:** Use TLS 1.2
```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-Module PSWindowsUpdate -Force
```

**Solution 2:** Install from PowerShell Gallery manually
```powershell
Find-Module PSWindowsUpdate | Install-Module -Force
```

### "PSWindowsUpdate not found" Error

Check if module path is correct:
```powershell
$env:PSModulePath -split ';'
```

Manually import:
```powershell
Import-Module PSWindowsUpdate -Force
```

### Access Denied Errors

Ensure running as Administrator:
```powershell
# Check if running as admin
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
```

### Windows Update Service Issues

Restart the Windows Update service:
```powershell
Restart-Service wuauserv
```

Clear Windows Update cache:
```powershell
Stop-Service wuauserv
Remove-Item C:\Windows\SoftwareDistribution\* -Recurse -Force
Start-Service wuauserv
```

## Uninstallation

To remove the skill:

```powershell
# Remove scheduled tasks
Get-ScheduledTask | Where-Object {$_.TaskName -like "*Windows Update Manager*"} | Unregister-ScheduledTask -Confirm:$false

# Remove module (optional)
Uninstall-Module PSWindowsUpdate -Force

# Delete skill directory
Remove-Item "C:\Users\p.amersfoort\Claude\Skills\windows-update-manager" -Recurse -Force

# Reset execution policy (if desired)
Set-ExecutionPolicy Restricted -Scope CurrentUser
```

## Verification

After installation, verify everything works:

```powershell
# Test module
Get-Command -Module PSWindowsUpdate

# Test script
.\Windows-Update-Manager.ps1 -Action Check

# Check logs
Get-ChildItem "$env:TEMP\WindowsUpdateManager"
```

## Support

For issues:
1. Check the log files in `$env:TEMP\WindowsUpdateManager\`
2. Run with `-Verbose` flag for detailed output
3. Review the SKILL.md troubleshooting section

## Next Steps

After successful installation:
1. Run `.\Windows-Update-Manager.ps1 -Action Check` to test
2. Review the README.md for usage examples
3. Set up scheduled tasks if desired
4. Configure email/webhook notifications (see config.ps1.template)
