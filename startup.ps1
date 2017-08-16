$Region = "WestUS2"
Login-AzureRmAccount
New-AzureRmResourceGroup -Name powershell-dsc-lab -Location $Region
New-AzureRmResourceGroupDeployment -ResourceGroupName powershell-dsc-lab -Name dsc-resources -TemplateFile .\infrastructure\arm-template.json
Get-AzureRmPublicIpAddress -Name ca-lab-vm-ip -ResourceGroupName powershell-dsc-lab | Select -ExpandProperty IpAddress