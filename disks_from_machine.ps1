#Subskrypcje
$Azure_ITM =    "674acf34-1194-4817-aa60-e3a0c392bf93"
$Azure_Bios =   "3e46a98f-4f47-4112-9601-54e837c1aeb0"
$Azure_IO =     "b0e380cd-aa13-4740-9663-56fa093cdfae"
$Azure_ITK =    "fbf837af-6589-4580-9e33-2253b6fa98e5"
$Azure_Ogolne = "d3d4df2b-1371-4876-92ae-f7b0b12820a7"

#Wybór subskrypcji
$subscriptionId = $Azure_Bios
Select-AzureRmSubscription -SubscriptionId $Azure_Bios

#Ogolne
$ResourceGroupName = "" #Nazwa ResourceGroupy
$VMName="" #Nazwa Maszyny z jakiej robimy obraz
$Location = "NorthEurope" #Lokacja dysku i snapshota
$SnapshotName = "" #Nazwa Snapshota
 
#Snapshot z dysku
$VMOSDisk=(Get-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $VMName).StorageProfile.OsDisk.Name
$Disk = Get-AzureRmDisk -ResourceGroupName $ResourceGroupName -DiskName $VMOSDisk
$SnapshotConfig =  New-AzureRmSnapshotConfig -SourceUri $Disk.Id -CreateOption Copy -Location $Location
$Snapshot=New-AzureRmSnapshot -Snapshot $SnapshotConfig -SnapshotName $SnapshotName -ResourceGroupName $ResourceGroupName

#Dysk ze snapshota
$Ile_dyskow = "" #Ile tworzymy dysków
$NewDiskName ="" # Nazwa dysków
$DiskSize ="128" #Rozmiar dysku w GB
$Sku = "StandardSSD_LRS" #Rodzaj dysku
$StorageType = "StandardSSD_LRS" 




for($i=0; $i -le $Ile_dyskow -1; $i++){
$NameSuffix = $i + 1
$NewerDiskName = $NewDiskName + $NameSuffix
$NewOSDiskConfig = New-AzureRmDiskConfig -AccountType $StorageType -Location $Location -CreateOption Copy -SourceResourceId $Snapshot.Id -DiskSizeGB $DiskSize
$newOSDisk=New-AzureRmDisk -Disk $NewOSDiskConfig -ResourceGroupName $ResourceGroupName -DiskName $NewerDiskName

}

