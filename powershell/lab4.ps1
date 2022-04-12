function get-hardwinfo {
Write-Host "System hardware information:"
Get-cimInstance Win32_ComputerSystem | format-list
}

function get-operatingsys {
Write-Host "OS Information:"
get-CimInstance win32_operatingsystem | format-list Name, Version
}

function get-processorinfo {
Write-Host "Processor Description:"
Get-WmiObject -class win32_processor | fl Description, MaxClockSpeed,
NumberOfCores, @{n="L1CacheSize";e={switch($_.L1CacheSize){$null{$var="data unavailable"}};$var}}, L2CacheSize, L3CacheSize
}

function get-meminfor {
Write-Host "summary of the total RAM:"
$CapacityInitialization = 0
Get-WmiObject -class win32_physicalmemory |
foreach {
New-Object -TypeName psobject -Property @{
Manufacturer = $_.Manufacturer
Description = $_.description
"Size(GB)" = $_.Capacity/1gb
Bank = $_.Banklabel
Slot = $_.Devicelocator
}
$CapacityInitialization += $_.capacity/1gb
}|
ft -auto Manufacturer, Description, "Size(GB)", Bank, Slot
"Total RAM: ${CapacityInitialization}GB"
}

function get-mydisk {
Write-Host "Available Disk drives:"
Get-WmiObject Win32_DiskDrive | where DeviceID -ne $NULL |
Foreach {
$drive = $_
$drive.GetRelated("Win32_DiskPartition")|
foreach {$logicaldisk = $_.GetRelated("win32_LogicalDisk");
  if ($logicaldisk.size) {
    new-object -TypeName PSobject -Property @{
    Manufacturer = $drive.Manufacturer
    DriveLetter = $logicaldisk.deviceID
    Model = $drive.model
    Size = [string]($logicaldisk.size/1gb -as [int])+"GB"
    Free= [String]((($logicaldisk.freespace / $logicaldisk.size) * 100) -as [int]) +"%"
    FreeSpace =[string]($logicaldisk.freespace / 1gb -as [int])+ "GB"
  }| format-table -auto Manufacturer, Model, size, Free, FreeSpace }}}
}

function get-networks {
Write-Host "Network INFO:"
get-ciminstance Win32_NetworkAdapterConfiguration | ? { $_.ipenabled -eq "true"}| 
format-table Description, Index, IPAddress, IPSubnet, 
@{n="DNSServersearchorder";
e={switch($_.DNSServersearchorder)
{$NULL{$var="data unavailable"; $var}};if($null -ne $_.DNSServerSearchorder){$_.DNSServerSearchorder}}},
@{n="DNSDomain";
e={switch($_.DNSDomain)
{$NULL{$var="data unavailable";$var }};if($null -ne $_.DNSdomain){$_.DNSdomain}}}
}

function get-gpu {
Write-Host "Graphics card Information:"
$Horizontaldimention=(gwmi -class Win32_Videocontroller).CurrentHorizontalResolution -as [String]
$Verticaldimention=(gwmi -class Win32_videocontroller).CurrentVerticalresolution -as [String]
$Bit=(get-wmiobject -class win32_videocontroller).CurrentBitsPerPixel -as [String]
$sum= $Horizontaldimention + " x " + $Verticaldimention + " and " + $Bit + " bits"
gwmi -class win32_videocontroller|
FL @{n="Video Card Vendor"; e={$_.AdapterCompatibility}},
Description,@{n="Resolution"; e={$sum -as [string]}}
}

get-hardwinfo
get-operatingsys
get-processorinfo
get-meminfor
get-mydisk
get-networks
get-gpu