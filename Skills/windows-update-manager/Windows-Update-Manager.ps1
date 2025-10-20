<#
.SYNOPSIS
    Windows Update Manager - Automated Windows Update Installation
.DESCRIPTION
    Production-ready PowerShell script for managing Windows Updates
.PARAMETER Action
    Action to perform: Check, Install, or Report
.PARAMETER AutoReboot
    Automatically reboot if required after installation
.PARAMETER IncludeOptional
    Include optional updates in installation
.PARAMETER DryRun
    Simulate installation without actually installing updates
.EXAMPLE
    .\Windows-Update-Manager.ps1 -Action Check
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("Check", "Install", "Report")]
    [string]$Action = "Check",
    
    [Parameter(Mandatory=$false)]
    [switch]$AutoReboot,
    
    [Parameter(Mandatory=$false)]
    [switch]$IncludeOptional,
    
    [Parameter(Mandatory=$false)]
    [switch]$DryRun,
    
    [Parameter(Mandatory=$false)]
    [string]$LogPath = "$env:TEMP\WindowsUpdateManager"
)

#Requires -RunAsAdministrator

$ScriptVersion = "1.0.0"

if (-not (Test-Path $LogPath)) {
    New-Item -ItemType Directory -Path $LogPath -Force | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFile = Join-Path $LogPath "WindowsUpdate_$timestamp.log"

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO", "WARNING", "ERROR", "SUCCESS")]
        [string]$Level = "INFO"
    )
    
    $logMessage = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [$Level] $Message"
    Add-Content -Path $logFile -Value $logMessage
    
    switch ($Level) {
        "ERROR"   { Write-Host $Message -ForegroundColor Red }
        "WARNING" { Write-Host $Message -ForegroundColor Yellow }
        "SUCCESS" { Write-Host $Message -ForegroundColor Green }
        default   { Write-Host $Message -ForegroundColor White }
    }
}

function Export-Report {
    param([object]$Data, [string]$Type = "Text")
    
    $reportFile = Join-Path $LogPath "WindowsUpdate_Report_$timestamp.$($Type.ToLower())"
    
    if ($Type -eq "JSON") {
        $Data | ConvertTo-Json -Depth 10 | Out-File -FilePath $reportFile -Encoding UTF8
    } else {
        $Data | Out-File -FilePath $reportFile -Encoding UTF8
    }
    
    Write-Log "Report saved: $reportFile" "SUCCESS"
    return $reportFile
}

Write-Log "=== Windows Update Manager v$ScriptVersion ===" "INFO"
Write-Log "Action: $Action" "INFO"
Write-Log "Hostname: $env:COMPUTERNAME" "INFO"

if ($DryRun) {
    Write-Log "DRY RUN MODE - No changes will be made" "WARNING"
}

Write-Log "Checking for PSWindowsUpdate module..." "INFO"
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Log "PSWindowsUpdate module not found. Installing..." "WARNING"
    try {
        Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser -ErrorAction Stop
        Write-Log "PSWindowsUpdate module installed successfully" "SUCCESS"
    } catch {
        Write-Log "Failed to install PSWindowsUpdate module: $($_.Exception.Message)" "ERROR"
        exit 1
    }
} else {
    Write-Log "PSWindowsUpdate module found" "SUCCESS"
}

Import-Module PSWindowsUpdate -ErrorAction Stop

try {
    switch ($Action) {
        "Check" {
            Write-Log "Checking for available updates..." "INFO"
                        
            $params = @{
                Verbose = $true
            }
            
            if ($IncludeOptional) {
                $params.Add("NotCategory", @())
            } else {
                $params.Add("NotCategory", "Optional")
            }
            
            $updates = Get-WindowsUpdate @params
            
            if ($updates.Count -eq 0) {
                Write-Log "No updates available" "SUCCESS"
                Write-Host "`n[OK] Your system is up to date!`n" -ForegroundColor Green
            } else {
                Write-Log "Found $($updates.Count) update(s)" "INFO"
                Write-Host "`nAvailable Updates:" -ForegroundColor Cyan
                Write-Host "================================================================================" -ForegroundColor Cyan
                
                foreach ($update in $updates) {
                    $sizeMB = [math]::Round($update.Size / 1MB, 2)
                    Write-Log "  - $($update.Title) [Size: $sizeMB MB]" "INFO"
                    Write-Host "  * $($update.Title)" -ForegroundColor White
                    Write-Host "    Size: $sizeMB MB | KB: $($update.KB)" -ForegroundColor Gray
                }
                Write-Host "================================================================================" -ForegroundColor Cyan
                Write-Host ""
            }
        }
        
        "Install" {
            Write-Log "Starting update installation..." "INFO"
            
            if ($DryRun) {
                Write-Log "DRY RUN: Would install updates but not actually installing" "WARNING"
            }
            
            $params = @{
                AcceptAll = $true
                Install = $true
                Verbose = $true
            }
            
            if ($IncludeOptional) {
                Write-Log "Including optional updates" "INFO"
            } else {
                $params.Add("NotCategory", "Optional")
            }
            
            if ($AutoReboot) {
                $params.Add("AutoReboot", $true)
                Write-Log "Auto-reboot enabled" "WARNING"
            } else {
                $params.Add("IgnoreReboot", $true)
            }
            
            if (-not $DryRun) {
                Write-Host "`nInstalling updates... This may take a while.`n" -ForegroundColor Cyan
                
                $results = Get-WindowsUpdate @params
                
                Write-Host "`nInstallation Summary:" -ForegroundColor Cyan
                Write-Host "================================================================================" -ForegroundColor Cyan
                
                foreach ($result in $results) {
                    if ($result.Result -eq "Installed") {
                        Write-Log "Successfully installed: $($result.Title)" "SUCCESS"
                        Write-Host "  [OK] $($result.Title)" -ForegroundColor Green
                    } else {
                        Write-Log "Failed to install: $($result.Title) - $($result.Result)" "ERROR"
                        Write-Host "  [FAIL] $($result.Title) - $($result.Result)" -ForegroundColor Red
                    }
                }
                
                Write-Host "================================================================================" -ForegroundColor Cyan
                
                if (Get-WURebootStatus -Silent) {
                    Write-Log "Reboot is required to complete installation" "WARNING"
                    Write-Host "`n[WARNING] REBOOT REQUIRED to complete installation`n" -ForegroundColor Yellow
                    
                    if ($AutoReboot) {
                        Write-Log "Auto-reboot will occur shortly..." "WARNING"
                        Write-Host "System will reboot in 60 seconds..." -ForegroundColor Yellow
                        Start-Sleep -Seconds 60
                        Restart-Computer -Force
                    }
                } else {
                    Write-Log "No reboot required" "SUCCESS"
                    Write-Host "`n[OK] Installation complete. No reboot required.`n" -ForegroundColor Green
                }
            } else {
                $updates = Get-WindowsUpdate @params -ErrorAction SilentlyContinue
                Write-Host "`nDRY RUN - Would install:" -ForegroundColor Yellow
                foreach ($update in $updates) {
                    Write-Host "  * $($update.Title)" -ForegroundColor Gray
                }
            }
        }
        
        "Report" {
            Write-Log "Generating update report..." "INFO"
            
            $history = Get-WUHistory | Select-Object -First 50
            $lastInstall = Get-WULastResults
            
            $report = [PSCustomObject]@{
                Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                Hostname = $env:COMPUTERNAME
                LastUpdateCheck = $lastInstall.LastSearchSuccessDate
                LastUpdateInstall = $lastInstall.LastInstallationSuccessDate
                RebootRequired = (Get-WURebootStatus -Silent)
                RecentUpdates = $history | Select-Object -First 10
            }
            
            $textReport = "Windows Update Report`n"
            $textReport += "Generated: $($report.Timestamp)`n"
            $textReport += "Hostname: $($report.Hostname)`n"
            $textReport += "=====================================================`n"
            $textReport += "`n"
            $textReport += "Last Update Check: $($report.LastUpdateCheck)`n"
            $textReport += "Last Update Install: $($report.LastUpdateInstall)`n"
            $textReport += "Reboot Required: $($report.RebootRequired)`n"
            $textReport += "`n"
            $textReport += "Recent Updates (Last 10):`n"
            
            foreach ($update in $report.RecentUpdates) {
                $textReport += "  $($update.Date) - $($update.Title) [$($update.Result)]`n"
            }
            
            Export-Report -Data $textReport -Type "Text" | Out-Null
            Export-Report -Data $report -Type "JSON" | Out-Null
            
            Write-Host "`nReport Summary:" -ForegroundColor Cyan
            Write-Host "================================================================================" -ForegroundColor Cyan
            Write-Host "Last Check: $($report.LastUpdateCheck)" -ForegroundColor White
            Write-Host "Last Install: $($report.LastUpdateInstall)" -ForegroundColor White
            Write-Host "Reboot Required: $($report.RebootRequired)" -ForegroundColor $(if($report.RebootRequired){'Yellow'}else{'Green'})
            Write-Host "================================================================================" -ForegroundColor Cyan
        }
    }
    
    Write-Log "=== Windows Update Manager Completed Successfully ===" "SUCCESS"
    
} catch {
    Write-Log "An error occurred: $($_.Exception.Message)" "ERROR"
    Write-Log "Stack trace: $($_.ScriptStackTrace)" "ERROR"
    exit 1
}
