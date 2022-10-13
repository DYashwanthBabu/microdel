md c:\data
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
wget -OutFile d:\Adventureworks.bak https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2016.bak
sqlcmd -E -S localhost -d master -Q "RESTORE DATABASE Adventureworks FROM Disk='d:\AdventureWorks.bak' WITH MOVE 'AdventureWorks2016_Data' TO 'c:\data\adventureworks.mdf', MOVE 'AdventureWorks2016_Log' TO 'c:\data\Adventureworks.ldf' "