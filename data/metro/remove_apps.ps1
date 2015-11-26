<#
	Removes Metro apps
	Options:
		1. Remove ALL Metro apps from the system account(including Store). Recommended.
		2. Remove ALL Metro apps from the signed in user account
		3. Remove ALL Metro apps for all users
#>
Switch ($args[0]) {
	1 { Get-AppXProvisionedPackage -online | Remove-AppXProvisionedPackage -online }
	2 { Get-AppXPackage | Remove-AppXPackage }
	3 { Get-AppXPackage -AllUsers | Remove-AppXPackage }
	default { "Invalid option: "+$args[0] }
}