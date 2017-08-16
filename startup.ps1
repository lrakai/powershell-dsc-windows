$Region = "WestUS2"
Login-AzureRmAccount
New-AzureRmResourceGroup -Name dsc-lab -Location $Region
New-AzureRmResourceGroupDeployment -ResourceGroupName dsc-lab -Name dsc-resources -TemplateFile .\infrastructure\arm-template.json
Get-AzureRmPublicIpAddress -Name ca-lab-vm-ip -ResourceGroupName dsc-lab | Select -ExpandProperty IpAddress