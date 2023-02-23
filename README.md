# Welcome to BADWARE 👋

![Version](https://img.shields.io/badge/version-3.0-blue.svg?cacheSeconds=2592000)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-yellow.svg)](https://github.com/JMousqueton/Badware/blob/main/LICENSE)
[![Twitter: JMousqueton](https://img.shields.io/twitter/follow/JMousqueton.svg?style=social)](https://twitter.com/JMousqueton)

> Ransomware Demonstration for Customer Experience Center

## Description

Quick & Dirty ransomware written in Powershell for the purpose of demonstrations at Customer Experience Center.

This Powershell ransomware encrypts files using an X.509 public key certificate generated on the host :) 

By Default the ransomware will cenrypt files in the C:\Data folder and save the X.509 public key certificate which is auto-generated in C:\YYYY-MM-DD-HHMM folder

This "ransomware" was inspired by [Phirautee](https://github.com/Viralmaniar/Phirautee)

```
__________    _____  ________     __      __  _____ _____________________
\______   \  /  _  \ \______ \   /  \    /  \/  _  \\______   \_   _____/
|    |  _/ /  /_\  \ |    |  \  \   \/\/   /  /_\  \|       _/|    __)_
|    |   \/    |    \|       \  \        /    |    \    |   \|        \
|______  /\____|__  /_______  /   \__/\  /\____|__  /____|_  /______JM /
       \/         \/        \/         \/         \/       \/        \/  2.3
[+] Let the carnage begin !!!
[+] Prepating Directory
[+] Init Certificate ...
[+] Init Encryption ...
[!] C:\Data\1.txt is now encrypted
[!] C:\Data\2.txt is now encrypted
[!] C:\Data\3.txt is now encrypted
[!] C:\Data\4.txt is now encrypted
[+] Badware Deployed Successfully...
[+] Cleaning Encryption key ...
[+] Intiating UI...
[+] Creating Badware.txt on Desktop ...
[+] Clean up the mess ...
[+] Exiting and waiting for the money
``` 

- [Changelog](https://github.com/JMousqueton/Badware/blob/main/CHANGELOG.md)
- [Todo](https://github.com/JMousqueton/Badware/blob/main/TODO.md)

## Usage 

- Simply modifiy variables at the begining of the script 

```
# Directory Target to crypt 
$TargetEncr = "C:\Data" 

# Define the DN of the certificate 
$CertName = "DEMO CEC"

# UI  
$btc_addr = '538f15c2-07ed-4cbe-8f37-efd0ecce1165' # Who knows perhaps I'll get rich 💰 
$delay = 60  # Delay to show the UI 
``` 

- Execute the script badware.ps1 

## Legal Disclaimer

This project must not be used for illegal purposes or for hacking into system where you do not have permission, it is strictly for educational purposes.
Performing any hack attempts or tests without written permission from the owner of the computer system is illegal.
Badware project must not be used for illegal purposes. It is strictly for educational purposes. 

## Author

👤 **Julien Mousqueton**

* Website: <https://www.julien.io>
* Twitter: [@JMousqueton](https://twitter.com/JMousqueton)
* Github: [@JMousqueton](https://github.com/JMousqueton)
* LinkedIn: [Julien Mousqueton](https://linkedin.com/in/julienmousqueton)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check [issues page](https://github.com/JMousqueton/Badware/issues).

## Show your support

Give a ⭐️ if this project helped you!

## 📝 License

Copyright © 2021 [Julien Mousqueton](https://github.com/JMousqueton).

This project is [Apache 2.0](https://github.com/JMousqueton/Badware/blob/main/LICENSE) licensed.
