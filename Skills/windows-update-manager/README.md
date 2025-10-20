# Windows Update Manager

Automated Windows Update management tool with comprehensive logging and reporting.

## Quick Start

1. **Open PowerShell as Administrator**
2. **Navigate to the skill directory:**
   ```powershell
   cd "C:\Users\p.amersfoort\Claude\Skills\windows-update-manager"
   ```

3. **Check for updates:**
   ```powershell
   .\Windows-Update-Manager.ps1 -Action Check
   ```

4. **Install updates:**
   ```powershell
   .\Windows-Update-Manager.ps1 -Action Install -AutoReboot
   ```

## Common Commands

### Just check what's available
```powershell
.\Windows-Update-Manager.ps1 -Action Check
```

### Install updates (manual reboot)
```powershell
.\Windows-Update-Manager.ps1 -Action Install
```

### Install updates with automatic reboot
```powershell
.\Windows-Update-Manager.ps1 -Action Install -AutoReboot
```

### Include optional updates
```powershell
.\Windows-Update-Manager.ps1 -Action Install -IncludeOptional
```

### Test what would be installed (dry run)
```powershell
.\Windows-Update-Manager.ps1 -Action Install -DryRun
```

### Generate report
```powershell
.\Windows-Update-Manager.ps1 -Action Report
```

## Output Location

All logs and reports are saved to:
```
C:\Users\<username>\AppData\Local\Temp\WindowsUpdateManager\
```

Or specify custom location:
```powershell
.\Windows-Update-Manager.ps1 -Action Install -LogPath "C:\Logs\Updates"
```

## Requirements

- Windows PowerShell 5.1 or PowerShell 7+
- Administrator privileges
- PSWindowsUpdate module (automatically installed if missing)

## Troubleshooting

### "Cannot be loaded because running scripts is disabled"
Run this in PowerShell as Administrator:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Need to run as Administrator
Right-click PowerShell and select "Run as Administrator"

### Module installation issues
Manually install the module:
```powershell
Install-Module PSWindowsUpdate -Force -Scope CurrentUser
```

## Features

✓ Automated update checking
✓ Automated update installation  
✓ Comprehensive logging with timestamps
✓ Text and JSON reports
✓ Optional automatic reboot
✓ Dry-run mode for testing
✓ Error handling and recovery

## Files

- `SKILL.md` - Complete documentation
- `Windows-Update-Manager.ps1` - Main script
- `README.md` - This file
- `INSTALLATION.md` - Setup guide
- `config.ps1.template` - Configuration template
- `MANIFEST.json` - Skill metadata
- `LICENSE.txt` - MIT License

For detailed documentation, see `SKILL.md`
