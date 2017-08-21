### Pull Server Configuration


# Open PowerShell ISE on ca-lab-vm

# Install xPSDesiredStateConfiguration for its xDscWebService resource (pull server)
Install-Module xPSDesiredStateConfiguration -SkipPublisherCheck -Force

# List all available DSC resources
Get-DscResource

# Create a DSC working directory
mkdir C:\DSC
cd C:\DSC

# Paste the pull server configuration (in configurations/pull-server.ps1) into a script file (ctrl+R)

# Save it (ctrl+S) as C:\DSC\DscPullServerConfig.ps1

# Create a registration ID for the pull server
$registrationkey =  (New-Guid).Guid
$registrationkey

# Load the configuration to make it available in the PowerShell session
. .\DscPullServerConfig.ps1

# Run the configuration to configure the local node
New_xDscPullServer -RegistrationKey $registrationkey -OutputPath C:\DSC\PullServer

# Run the compiled configuration using DSC to make the local node a DSC Pull Server
Start-DscConfiguration -Path C:\DSC\PullServer -Wait -Verbose

# Manually verify that the DSC-Service is present
Get-WindowsFeature -Name DSC-Service

# Confirm that the DSC pull server is listening on port 8080
Get-Website

# Confirm that the registration key was output to a file
psEdit "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"

# Now that the node is configured, use the following command to get the node's current configuration
Get-DscConfiguration

# Note the pull server URL is listed: http://ca-lab-vm:8080/PSDSCPullServer.svc


### Publish Node Configuration File


# Paste the contents of configurations/node.ps1 into a new PowerShell script file

# Save the file as C:\DSC\CreateFilesConfig.ps1

# Compile the configuration into a MOF file
. .\CreateFilesConfig.ps1
CreateFiles -OutputPath C:\DSC\CreateFiles

# Rename the MOF file to something more meaningful
move CreateFiles\localhost.mof CreateFiles\files.mof

# Publish the configuration
Publish-DSCModuleAndMof -Source C:\Dsc\CreateFiles -Force


###  Configure a Node to Pull the Configuration on the Pull Server


# Open PowerShell ISE on the dsc-node VM

# Create a working directory
mkdir C:\DSC
cd C:\DSC

# Paste the contents of configuration/lcm.ps1 into a script file

# Save the file as C:\DSC\LCMConfig.ps1

# Source the file to make the configuration available to the PowerShell session
. .\LCMConfig.ps1

# Change INSERT_YOUR_REGISTRATION_KEY with the registration key you created on the pull server ($registrationKey)

# Compile the configuration
PullClientConfig

# Configure the node's LCM by entering
Set-DscLocalConfigurationManager .\PullClientConfig

# View the current LCM configuration by entering
Get-DscLocalConfigurationManager

# Double click the file on your Desktop and confirm its contents match what was in the configuration

# Change the file's contents and save the file

# Return to PowerShell and enter the following to run the version of the configuration stored on the node
Start-DscConfiguration -UseExisting -Wait -Verbose

# Switch the to ca-lab-vm (pull server) Remote Desktop session, and change Ensure value from Present to Absent in CreateFilesConfig.ps1 to configure the node to remove the file on the Desktop

# Save the file and run the following commands to update the version of the served configuration
. .\CreateFilesConfig.ps1
CreateFiles -OutputPath C:\DSC\CreateFiles
move CreateFiles\localhost.mof CreateFiles\files.mof -Force
Publish-DSCModuleAndMof -Source C:\Dsc\CreateFiles -Force

# Return to the dsc-node Remote Desktop session, and update the configuration
Update-DscConfiguration -Verbose -Wait