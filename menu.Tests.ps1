# To Do: Change this
BeforeAll {
    . "$PSScriptRoot\os_information_Hao_Zhang.ps1"
}

Describe "Get-SystemInformation" {
    BeforeEach {
        Mock Get-ComputerInfo -ModuleName OSInfoModule {
            return @{ OsName = 'Windows 11' }
        }
    }

    It "Returns computer property when valid parameter provided" {
        # To Do: Change <Get-SystemInformation> to the name of your function
        $result = Get-SystemInformation -propertyName 'OsName'
        $result | Should -Not -BeNullOrEmpty
    }

    It "Calls Get-ComputerInfo with correct property" {
        # To Do: Change <Get-SystemInformation> to the name of your function
        Get-SystemInformation -propertyName 'OsName'
        Should -Invoke Get-ComputerInfo -ModuleName OSInfoModule -ParameterFilter { $Property -eq 'OsName' } -Times 1
    }

    It "Returns error when exception occurs" {
        Mock Get-ComputerInfo -ModuleName OSInfoModule { throw 'Failure' }
        # To Do: Change <Get-SystemInformation> to the name of your function
        $result = Get-SystemInformation -propertyName 'OsName'
        $result | Should -Match 'Error:'
    }
}

Describe "Get-AllInformation" {
    BeforeEach {
        Mock Get-ComputerInfo -ModuleName OSInfoModule {
            return @{ OsName = 'Windows 11'; OsArchitecture = '64-bit' }
        }
    }

    It "Returns formatted computer information" {
        # To Do: Change <Get-SystemInformation> to the name of your function
        $result = Get-AllInformation
        $result | Should -Not -BeNullOrEmpty
    }

    It "Calls Get-ComputerInfo once" {
        # To Do: Change <Get-SystemInformation> to the name of your function
        Get-AllInformation
        Should -Invoke Get-ComputerInfo -ModuleName OSInfoModule -Times 1
    }

    It "Returns error string on failure" {
        Mock Get-ComputerInfo -ModuleName OSInfoModule { throw 'Failure' }
        # To Do: Change <Get-SystemInformation> to the name of your function
        $result = Get-AllInformation
        $result | Should -Match 'Error:'
    }
}

Describe "Show-Menu" {
    It "Displays menu options" {
        Mock Write-Output {}
        # To Do: Change <Show-Menu> to the name of your function
        Show-Menu
        Should -Invoke Write-Output -Times 14 -Exactly
    }
}

Describe "Start-OSInformationMenu" {
    BeforeEach {
        # To Do: Change <Show-Menu> to the name of your function
        Mock Show-Menu {}
        Mock Write-Output {}
        Mock Write-Host {}
        # To Do: Change <Get-SystemInformation> to the name of your function
        Mock Get-SystemInformation { return 'MockedValue' }
        # To Do: Change <Get-SystemInformation> to the name of your function
        Mock Get-AllInformation { return 'AllInfo' }
    }

    Context "Valid selections" {
        It "Handles option 1" {
            $script:inputCount = 0
            Mock Read-Host {
                $script:inputCount++
                if ($script:inputCount -eq 1) { return '1' }
                throw 'StopTest'
            }
            # To Do: Change <Start-OSInformationMenu> to the name of your function
            try {
                Start-OSInformationMenu
            }
            catch {
                if ($_.Exception.Message -ne 'StopTest') { throw }
            }
            # To Do: Change <Get-SystemInformation> to the name of your function
            Should -Invoke Get-SystemInformation -Times 1
        }

        It "Handles option 8" {
            $script:inputCount = 0
            Mock Read-Host {
                $script:inputCount++
                if ($script:inputCount -eq 1) { return '8' }
                throw 'StopTest'
            }
            # To Do: Change <Start-OSInformationMenu> to the name of your function
            try {
                Start-OSInformationMenu
            }
            catch {
                if ($_.Exception.Message -ne 'StopTest') { throw }
            }
            # To Do: Change <Get-AllInformation> to the name of your function
            Should -Invoke Get-AllInformation -Times 1
        }
    }

    Context "Invalid selection greater than 8" {
        It "Prompts again on invalid high input" {
            $script:calls = 0
            Mock Read-Host {
                $script:calls++
                if ($script:calls -eq 1) { return '10' }
                throw 'StopTest'
            }
            # To Do: Change <Start-OSInformationMenu> to the name of your function
            try {
                Start-OSInformationMenu
            }
            catch {
                if ($_.Exception.Message -ne 'StopTest') { throw }
            }
            Should -Invoke Show-Menu -Times 2
        }
    }

    Context "Exit condition" {
        It "Exits when user selects 9" {
            Mock Read-Host { return '9' }
            # To Do: Change <Start-OSInformationMenu> to the name of your function
            { Start-OSInformationMenu } | Should -Not -Throw
        }
    }
}
