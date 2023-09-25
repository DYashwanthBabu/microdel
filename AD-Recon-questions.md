### AD-Recon Questions

##### Navigate to **C:\Tools**. and use the **PowerView.ps1** script present here for the AD enumeration.

```
cd C:\Tools
powershell -ep bypass 
. .\PowerView.ps1
```

##### What is the SID of the current domain and the current user?
```
Get-DomainSID

whoami /all
```

##### What is the FQDN and the IP address of the current domain’s Domain Controller?

```
Get-DomainController 
```

##### What is the name of the Parent domain and what is the OS version of its Domain Controller?
```
Get-Domain
```
```
Get-DomainController -Domain SECURITY.local
```

##### When was the password last set for the domain user named “DAVID_WONG”?
```
Get-DomainUser -Identity DAVID_WONG -Properties DisplayName,pwdlastset,objectsid,useraccountcontrol | Format-List
```

##### How many computers are there in the Parent domain?
```
Get-NetComputer -Domain SECURITY.local | select cn, operatingsystem
```

##### List all the groups that contain the word “admin” in the group name.

```
Get-NetGroupMember "LO-val-admingroup1" | select MemberName
```

##### List the groups to which a user named “ALVARO_DRAKE” belongs to.
```
Get-NetGroup -UserName "ALVARO_DRAKE" | select name
```

##### What is the display name corresponding to the GPO “{E4DA53D8-7B02-438D-8A6D-84685663CFE4}”?

```
Get-NetForestDomain
```

##### What is the name of the forest to which a trust has been established and what is the trust direction?

```
Get-NetForestTrust
```

##### What is the FQDN of the Domain Controller in the trust forest?

```
Get-NetForestDomain -Forest tech.local
```

##### List the ACLs associated with a user named CLARA_MEYER where the Active Directory Rights are “GenericAll”.

```
Get-ObjectAcl -SamAccountName CLARA_MEYER -ResolveGUIDs | ? {$_.ActiveDirectoryRights -eq "GenericAll"}
```

##### Is the HELENA_THOMPSON user account Kerberoastable?
```
Get-DomainUser -Identity HELENA_THOMPSON | select samaccountname, serviceprincipalname
```

##### Is the RICKY_CONLEY user account AS-REP roastable?
```
Get-DomainUser -Identity RICKY_CONLEY | select samaccountname, useraccountcontrol
```