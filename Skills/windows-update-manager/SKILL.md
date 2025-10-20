# Windows Update Manager Skill

## Overview
Professional Windows Update automation tool with comprehensive logging, error handling, and reporting capabilities.

## Features
- ✅ Automated Windows Update checking and installation
- ✅ Comprehensive logging with timestamps
- ✅ Error handling and recovery
- ✅ Optional automatic reboot
- ✅ Text and JSON report generation
- ✅ Email/webhook notifications (SIEM integration ready)
- ✅ Dry-run mode for testing
- ✅ Include/exclude optional updates

## Quick Start

### Check for Updates
```powershell
.\Windows-Update-Manager.ps1 -Action Check
```

### Install Updates (with auto-reboot)
```powershell
.\Windows-Update-Manager.ps1 -Action Install -AutoReboot
```

### Generate Report
```powershell
.\Windows-Update-Manager.ps1 -Action Report
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| Action | String | Check | Check, Install, or Report |
| AutoReboot | Switch | False | Automatically reboot if required |
| IncludeOptional | Switch | False | Include optional updates |
| LogPath | String | $env:TEMP\WindowsUpdateManager | Log file location |
| DryRun | Switch | False | Simulate without installing |

## Requirements
- Windows PowerShell 5.1 or PowerShell 7+
- Administrator privileges
- PSWindowsUpdate module (auto-installed if missing)

## File Structure
```
windows-update-manager/
├── SKILL.md                          # This file
├── Windows-Update-Manager.ps1        # Main script
├── README.md                         # Quick start guide
├── INSTALLATION.md                   # Setup instructions
├── config.ps1.template               # Configuration template
├── MANIFEST.json                     # Skill metadata
└── LICENSE.txt                       # MIT License
```

## Usage Examples

### Example 1: Check and Install with Logging
```powershell
# Check what's available
.\Windows-Update-Manager.ps1 -Action Check

# Install updates with custom log path
.\Windows-Update-Manager.ps1 -Action Install -LogPath "C:\Logs\Updates"
```

### Example 2: Automated Installation
```powershell
# Install all updates including optional, auto-reboot
.\Windows-Update-Manager.ps1 -Action Install -IncludeOptional -AutoReboot
```

### Example 3: Generate Reports
```powershell
# Generate text and JSON reports
.\Windows-Update-Manager.ps1 -Action Report

# Reports saved to: $env:TEMP\WindowsUpdateManager\
```

### Example 4: Dry Run (Test Mode)
```powershell
# See what would be installed without actually installing
.\Windows-Update-Manager.ps1 -Action Install -DryRun
```

## Advanced Configuration

Create a `config.ps1` file from the template:
```powershell
# Email notification settings
$EmailEnabled = $true
$SmtpServer = "smtp.company.com"
$SmtpPort = 587
$EmailFrom = "updates@company.com"
$EmailTo = "admin@company.com"

# Webhook for SIEM integration
$WebhookEnabled = $true
$WebhookUrl = "https://siem.company.com/webhook"

# Update preferences
$ExcludedKBs = @("KB1234567", "KB2345678")
$UpdateCategories = @("Critical Updates", "Security Updates")
```

## Output Files

### Log File
Location: `$LogPath\WindowsUpdate_YYYYMMDD_HHMMSS.log`
```
[2025-01-20 14:30:00] [INFO] === Windows Update Manager Started ===
[2025-01-20 14:30:05] [INFO] Found 5 update(s)
[2025-01-20 14:30:10] [SUCCESS] Update installed: KB5034441
```

### JSON Report
Location: `$LogPath\WindowsUpdate_Report_YYYYMMDD_HHMMSS.json`
```json
{
  "timestamp": "2025-01-20T14:30:00",
  "hostname": "DESKTOP-ABC123",
  "totalUpdates": 5,
  "installedUpdates": 5,
  "failedUpdates": 0,
  "rebootRequired": true
}
```

## Error Handling

The script handles common errors:
- Missing administrator privileges
- Network connectivity issues
- Failed update installations
- Module installation failures

All errors are logged with timestamps and detailed messages.

## Security Considerations

1. **Administrator Rights**: Required for installing updates
2. **Execution Policy**: May need to be set to RemoteSigned or Unrestricted
3. **Module Source**: PSWindowsUpdate installed from PSGallery
4. **Logging**: Contains system information - secure log directory appropriately

## Scheduled Task Setup

To run automatically:
```powershell
# Create scheduled task for weekly updates
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-ExecutionPolicy Bypass -File C:\Path\To\Windows-Update-Manager.ps1 -Action Install -AutoReboot"

$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 2am

Register-ScheduledTask -TaskName "Windows Update Manager" `
    -Action $action -Trigger $trigger -RunLevel Highest
```

## Troubleshooting

### Script won't run
- Ensure running as Administrator
- Check execution policy: `Get-ExecutionPolicy`
- Set if needed: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`

### PSWindowsUpdate module errors
- Manually install: `Install-Module PSWindowsUpdate -Force`
- Update module: `Update-Module PSWindowsUpdate`

### No updates found but Windows Update shows updates
- Run Windows Update troubleshooter
- Restart Windows Update service: `Restart-Service wuauserv`

## Support & Contributions

For issues or improvements, refer to the README.md file for contribution guidelines.

## License

MIT License - See LICENSE.txt for details
