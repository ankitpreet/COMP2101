get-ciminstance win32_networkadapterconfiguration |
Where-Object {$_.ipenabled -eq "True" } | ft Description, Index, ipAddress, IPSubnet, DNSDomain, DNSServerSearchOrder