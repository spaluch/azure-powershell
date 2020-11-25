$ResourceGroupName = 'SQL'

$Location = "westeurope"

$ServerName = 'ms55268' #nie moze istniec w sieci

$Username =   'sposqladmin'

$Password = 'Pa$$w0rd'

 

Connect-AzAccount

New-AzResourceGroup -Name $ResourceGroupName -Location $Location

$passwd = $Password | ConvertTo-SecureString -AsPlainText -Force

$cred = New-Object System.Management.Automation.PSCredential $Username, $passwd

New-AzSqlServer -ResourceGroupName $ResourceGroupName -Location $Location -ServerName $ServerName  -SqlAdministratorCredentials $cred

 

New-AzSqlServerFirewallRule -FirewallRuleName 'PowerAppsR1' -StartIpAddress '13.69.227.208' -EndIpAddress '13.69.227.223' -ServerName $ServerName  -ResourceGroupName $ResourceGroupName

New-AzSqlServerFirewallRule -FirewallRuleName 'PowerAppsR2' -StartIpAddress '52.178.150.68' -EndIpAddress '52.178.150.68' -ServerName $ServerName  -ResourceGroupName $ResourceGroupName

New-AzSqlServerFirewallRule -FirewallRuleName 'PowerAppsR3' -StartIpAddress '13.69.64.208' -EndIpAddress '13.69.64.223' -ServerName $ServerName  -ResourceGroupName $ResourceGroupName

New-AzSqlServerFirewallRule -FirewallRuleName 'PowerAppsR4' -StartIpAddress '52.174.88.118' -EndIpAddress '52.174.88.118' -ServerName $ServerName  -ResourceGroupName $ResourceGroupName

New-AzSqlServerFirewallRule -FirewallRuleName 'PowerAppsR5' -StartIpAddress '137.117.161.181' -EndIpAddress '137.117.161.181' -ServerName $ServerName  -ResourceGroupName $ResourceGroupName

 

New-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $ServerName  -DatabaseName "Adventureworks" -SampleName AdventureWorksLT -Edition "Basic"