
 
param (
 
    [Parameter(Mandatory=$false)]
    [String] $VMName ,
 
    [Parameter(Mandatory=$false)]
    [String] $ResourceGroupName
)
 
$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName        
 
    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}
 
 
# If there is a specific resource group, then get all VMs in the resource group,
# otherwise get all VMs in the subscription.
if ($ResourceGroupName -And $VMName)
{
    $VMs = Get-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $VMName
}
elseif ($ResourceGroupName)
{
    $VMs = Get-AzureRmVM -ResourceGroupName $ResourceGroupName
 
}
else
{
    $VMs = Get-AzureRmVM
}
# Start each of the VMs
foreach ($VM in $VMs)
{
   
   
            $StartRtn = $VM | Start-AzureRmVM -ErrorAction Continue
 
            if ($StartRtn.Status -ne 'Succeeded')
            {
                # The VM failed to start, so send notice
                Write-Output ($VM.Name + " failed to start")
                Write-Error ($VM.Name + " failed to start. Error was:") -ErrorAction Continue
                Write-Error ("Status was "+ $StartRtn.Status) -ErrorAction Continue
                Write-Error (ConvertTo-Json $StartRtn.Error) -ErrorAction Continue
            }
            else
            {
                # The VM stopped, so send notice
                Write-Output ($VM.Name + " has been started")
            }
   
 
}