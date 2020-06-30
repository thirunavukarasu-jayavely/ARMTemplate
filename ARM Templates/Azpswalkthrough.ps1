#Getting all Azure locations 

Get-AzLocation | Format-Table Location, DisplayName -AutoSize

# List resoure providers on the locations

Get-AzResourceProvider -Location "southindia" | Format-Table ProviderNamespace, ResourceTypes, RegistrationState, Locations -AutoSize | Measure-Object

Get-AzResourceProvider -Location "southindia" -ListAvailable | Where-Object {$_.RegistrationState -eq "NotRegistered"} | Measure-Object

#Registering all the Resource Provider
Get-AzResourceProvider -ListAvailable | ForEach-Object {register-azresourceprovider -ProviderNamespace $_.ProviderNamespace}

# Customm role for Regsiter

$subid = "cf2d98a6-ee54-4638-b644-58856fcb522e"
$role = Get-AzRoleDefinition -Name "Virtual Machine Contributor"
$role.Id = $null
$role.Name = "Resource Provider Regiterer"
$role.Description ="Can Register Resource Providers"
$role.Actions.RemoveRange(0,$role.Actions.Count)
$role.Actions.Add("*/register/action")
$role.AssignableScopes.Clear()
$role.AssignableScopes.Add("/subscriptions/$subid")
New-AzRoleDefinition -Role $role 

#Assign to a group

$group = Get-AzADGroup -SearchString "GroupName"

New-AzRoleAssignment -ObjectId $group.Id -Scope $subid -RoleDefinitionName $role.Name

#look inside a Resource Provider

Get-AzResourceProvider | ? {$_.ProviderNamespace -like "*Compute*"}
Get-AzResourceProvider -ProviderNamespace "Microsoft.Compute"
(Get-AzResourceProvider -ProviderNamespace "Microsoft.Compute").ResourceTypes.ResourceTypeName

#Getting where the Resources are availble 

(Get-AzResourceProvider -ProviderNamespace "Microsoft.Compute" | Where-Object {$_.ResourceTypes.ResourceTypeName -eq "VirtualMachines"}).Locations

#Specific permission require to register
Get-AzResourceProviderAction -OperationSearchString "Microsoft.Compute/*" | Select  Operation
Get-AzResourceProviderAction -OperationSearchString "Microsoft.Compute/register/action" | Format-Table OperationName, Description -AutoSize

#Action available for specific type of resorce
Get-AzResourceProviderAction -OperationSearchString "Microsoft.Compute/virtualMachines/*" | Format-Table Operation, Description -AutoSize

#Getting API version of resouce

((Get-AzResourceProvider -ProviderNamespace "Microsoft.Compute").ResourceTypes | Where-Object ResourceTypeName -EQ "VirtualMachines").ApiVersions

