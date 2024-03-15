# Check if the current session is running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Relaunch the script with administrative privileges
    Start-Process powershell.exe -Verb RunAs -ArgumentList ('-File "{0}"' -f $MyInvocation.MyCommand.Definition)
}
else {
    do {
        # Display menu to the user
        Write-Output "Select an option:"
        Write-Output "1. Remove a VM by name"
        Write-Output "2. Remove all VMs"
        Write-Output "3. Exit"
        $option = Read-Host "Enter your choice"

        switch ($option) {
            '1' {
                do {
                    $vmName = Read-Host "Enter the name of the VM to remove (or 'exit' to stop removing VMs)"
                    if ($vmName -eq 'exit') {
                        break
                    }
                    $vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue
                    if ($null -ne $vm) {
                        if ($vm.State -eq 'Running') {
                            Stop-VM -Name $vm.Name -Force
                        }
                        Remove-VM -Name $vm.Name -Force
                        Write-Output "VM '$vmName' has been removed."
                    } else {
                        Write-Output "No VM found with the name '$vmName'."
                    }
                } while ($true)
            }
            '2' {
                $confirmation = Read-Host "Are you sure you want to remove all VMs? (yes/no)"
                if ($confirmation -eq 'yes') {
                    $vms = Get-VM
                    foreach ($vm in $vms) {
                        if ($vm.State -eq 'Running') {
                            Stop-VM -Name $vm.Name -Force
                        }
                        Remove-VM -Name $vm.Name -Force
                    }
                    Write-Output "All VMs have been removed."
                    break
                } else {
                    Write-Output "Operation cancelled."
                }
            }
            '3' {
                Write-Output "Exiting... Press Enter to close PowerShell."
                Read-Host "Press Enter to exit"
                exit
            }
            default {
                Write-Output "Invalid option. Please try again."
            }
        }
    } while ($true)
}
