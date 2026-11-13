# Import the module containing the functions.
try {
    Import-Module "$PSScriptRoot\OSInfoModule.psm1" -Force -ErrorAction Stop
}
catch {
    # Display an error if the module cannot be imported.
    Write-Host 'Error importing OSInfoModule.psm1.'
    Write-Host $_.Exception.Message
    return
}

# Display the nine menu options.
function Show-Menu {
    Write-Output ''
    Write-Output '==================================='
    Write-Output 'ITWorks - OS Information Menu'
    Write-Output '==================================='
    Write-Output '1. Operating System'
    Write-Output '2. Windows Remote Service Status'
    Write-Output '3. Computer Manufacturer and Model'
    Write-Output '4. Computer Name'
    Write-Output '5. Computer Domain Name'
    Write-Output '6. Trusted Hosts'
    Write-Output '7. Operating System Architecture'
    Write-Output '8. Get All Information'
    Write-Output '9. Quit'
    Write-Output '==================================='

 }

function Start-OSInformationMenu {
    # Set the initial user selection and output.
    $selection = ''
    $output = ''

    # Keep running until the user selects option 9.
    while ($selection -ne '9') {

        # Display the menu.
        Show-Menu | ForEach-Object { Write-Host $_ }

        # Display the result from the previous selection.
        if ($output -ne '') {
            Write-Host ''
            Write-Host $output
        }

        Write-Host ''

        # Ask the user to enter a menu option.
        $selection = Read-Host 'Enter your selection (1-9)'

        # Use SWITCH to handle the user selection.
        switch ($selection) {

            '1' {
                # Get the operating system name and version.
                $result = Get-SystemInformation -PropertyName 'OsName'
                $output = "Operating System: $result"
            }

            '2' {
                # Get the Windows remote service status.
                $result = Get-SystemInformation -PropertyName 'WindowsRemoteServiceStatus'
                $output = "Windows Remote Service Status: $result"
            }

            '3' {
                # Get the computer manufacturer and model.
                $result = Get-SystemInformation -PropertyName 'ComputerManufacturerandModel'
                $output = "Computer Manufacturer and Model: $result"
            }

            '4' {
                # Get the computer name.
                $result = Get-SystemInformation -PropertyName 'ComputerName'
                $output = "Computer Name: $result"
            }

            '5' {
                # Get the computer domain name.
                $result = Get-SystemInformation -PropertyName 'ComputerDomainName'
                $output = "Computer Domain Name: $result"
            }

            '6' {
                # Get the trusted hosts.
                $result = Get-SystemInformation -PropertyName 'ComputersTrustedHosts'
                $output = "Trusted Hosts: $result"
            }

            '7' {
                # Get the operating system architecture.
                $result = Get-SystemInformation -PropertyName 'OperatingSystemArchitecture'
                $output = "Operating System Architecture: $result"
            }

            '8' {
                # Get all seven categories of computer information.
                $result = Get-AllInformation
                $output = "All Computer Information:`n$result"
            }

            '9' {
                # Exit the program.
                Write-Host 'Exiting the program.'
            }

            default {
                # Handle an invalid menu selection.
                $output = 'Invalid selection. Please enter a number from 1 to 9.'
            }
        }
    }

}

# Start only when the script is run directly, not when loaded by Pester.
if ($MyInvocation.InvocationName -ne '.') {
    Start-OSInformationMenu
}
