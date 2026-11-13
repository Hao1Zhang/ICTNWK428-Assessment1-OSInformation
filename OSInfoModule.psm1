# Get specific computer information based on the parameter.
<#
.SYNOPSIS
Gets a requested system information property.
.PARAMETER PropertyName
The system information property to retrieve.
#>
function Get-SystemInformation {
    param(
        [string]$PropertyName
    )

    try {
        # Select which information to retrieve.
        switch ($PropertyName) {
            'OsName' {
                # Get the operating system name.
                $info = Get-ComputerInfo -Property OsName -ErrorAction Stop
                return $info.OsName
            }
            'WindowsRemoteServiceStatus' {
                # Get the Windows Remote Management service status.
                $service = Get-Service -Name WinRM -ErrorAction Stop
                return $service.Status.ToString()
            }
            'ComputerManufacturerandModel' {
                # Get the computer manufacturer and model.
                $info = Get-ComputerInfo -ErrorAction Stop
                return "$($info.CsManufacturer) - $($info.CsModel)"
            }
            'ComputerName' {
                # Get the computer name.
                $info = Get-ComputerInfo -ErrorAction Stop
                return $info.CsName
            }
            'ComputerDomainName' {
                # Get the computer domain name.
                $info = Get-ComputerInfo -ErrorAction Stop
                return $info.CsDomain
            }
            'ComputersTrustedHosts' {
                # Get the trusted hosts configured for Windows remoting.
                $hosts = Get-Item -Path WSMan:\localhost\Client\TrustedHosts -ErrorAction Stop
                if ([string]::IsNullOrWhiteSpace($hosts.Value)) {
                    return 'None configured'
                }
                else {
                    return $hosts.Value
                }
            }
            'OperatingSystemArchitecture' {
                # Get the operating system architecture (32-bit or 64-bit).
                $info = Get-ComputerInfo -ErrorAction Stop
                return $info.OsArchitecture
            }
            default {
                # Handle an invalid information type.
                return 'Invalid information type'
            }
        }
    }
    catch {
        # Return an error message that can also be checked by Pester.
        return "Error: $($_.Exception.Message)"
    }
}

# Get all seven types of computer information.
<#
.SYNOPSIS
Gets all seven categories of system information.
#>
function Get-AllInformation {
    try {
        # Get computer information once for all standard computer properties.
        $info = Get-ComputerInfo -ErrorAction Stop
        $service = Get-Service -Name WinRM -ErrorAction Stop
        $hosts = Get-Item -Path WSMan:\localhost\Client\TrustedHosts -ErrorAction Stop
        $trustedHosts = $hosts.Value
        if ([string]::IsNullOrWhiteSpace($trustedHosts)) {
            $trustedHosts = 'None configured'
        }

        # Create the output in the same order as the menu.
        $output = "Operating System: $($info.OsName)`n"
        $output += "Windows Remote Service Status: $($service.Status)`n"
        $output += "Computer Manufacturer and Model: $($info.CsManufacturer) - $($info.CsModel)`n"
        $output += "Computer Name: $($info.CsName)`n"
        $output += "Computer Domain Name: $($info.CsDomain)`n"
        $output += "Trusted Hosts: $trustedHosts`n"
        $output += "Operating System Architecture: $($info.OsArchitecture)"
        return $output
    }
    catch {
        return "Error: $($_.Exception.Message)"
    }
}

# Export the functions for use in the main script.
Export-ModuleMember -Function Get-SystemInformation, Get-AllInformation
