param ( [switch]$System, [switch]$Disks, [switch]$Network)

Import-Module ankitpreetsharma

if ($System -eq $false -and $Disks -eq $false -and $Network -eq $false) {
	write-Host "Include CMD Args. Otherwise this script created to display/run all possible functions."
	write-Host "______________________________________________________________________________________"
	write-Host ""
  ankitpreetsharma-System;ankitpreetsharma-Disks;ankitpreetsharma-Network
  write-Host ""
} else {
  if ($System) { ankitpreetsharma-System;
  }
  if ($Disks) { ankitpreetsharma-Disks;
  }
  if ($Network) { ankitpreetsharma-Network;
  }
}