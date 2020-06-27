#Getting all Azure locations 

Get-AzLocation | Format-Table Location, DisplayName -AutoSize

# List resoure providers on the locations

Get-AzResourceProvider -Location "southindia" | Format-Table ProviderNamespace, ResourceTypes, RegistrationState, Locations -AutoSize | Measure-Object

Get-AzResourceProvider -Location "southindia" -ListAvailable | Where-Object {$_.RegistrationState -eq "NotRegistered"} | Measure-Object




