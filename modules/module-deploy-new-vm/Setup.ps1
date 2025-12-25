<#
.SYNOPSIS
    Configures IIS bindings, updates the OS hostname, and optionally restarts the VM.
#>

param (
    [string]$IISHostname,
    [string]$NewOSHostname,
    [switch]$RestartVM
)

Start-Transcript -Path "$env:ProgramData\Ginesys\CLoudAdmin\WindowsSetUp\VM_Setup_$(get-date -Format 'yyyyMMdd_HHmmss').log" -Append


Write-Host "Script started."

# --- 1. Set IIS Binding ---
if (![string]::IsNullOrWhiteSpace($IISHostname)) {
    try {
        if (!(Get-Module -ListAvailable WebAdministration)) {
            throw "WebAdministration module not found. IIS may not be installed."
        }
        Import-Module WebAdministration
        
        Write-Host "Attempting to add IIS binding for: $IISHostname"
        # Adds a port 443 binding to the Default Web Site as an example
        New-WebBinding -Name "Default Web Site" -IPAddress "*" -Port 443 -HostHeader $IISHostname -Protocol https -ErrorAction Stop
        Write-Host "Successfully added IIS binding for $IISHostname."
    }
    catch {
        Write-Host "Failed to set IIS binding: $($_.Exception.Message)" "ERROR"
    }
}

# --- 2. Set OS Hostname ---
if (![string]::IsNullOrWhiteSpace($NewOSHostname)) {
    try {
        $CurrentName = $env:COMPUTERNAME
        if ($CurrentName -ne $NewOSHostname) {
            Write-Host "Changing Hostname from $CurrentName to $NewOSHostname."
            Rename-Computer -NewName $NewOSHostname -Force -ErrorAction Stop
            Write-Host "Hostname change pending."
        } else {
            Write-Host "Hostname is already $NewOSHostname. Skipping."
        }
    }
    catch {
        Write-Host "Failed to change Hostname: $($_.Exception.Message)" "ERROR"
    }
}

# --- 3. Restart VM ---
if ($RestartVM) {
    Write-Host "Restart flag detected. System will restart in 5 seconds."
    Start-Sleep -Seconds 5
    Restart-Computer -Force
} else {
    Write-Host "Script completed without restart."
}

Stop-Transcript