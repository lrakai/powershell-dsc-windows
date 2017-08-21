# DSC configuration for Pull Server using registration
configuration New_xDscPullServer
{
  param 
  (
    # Use localhost as the default node
    [string[]]$NodeName = 'localhost',
 
    # A unique ID that clients use to initiate conversation with pull server
    [ValidateNotNullOrEmpty()]
    [string] $RegistrationKey 
  )

  # Explicitly import depended upon modules
  Import-DscResource –ModuleName PSDesiredStateConfiguration
  Import-DSCResource -ModuleName xPSDesiredStateConfiguration

  Node $NodeName
  {
    # Ensure the DSC Windows feature is installed
    WindowsFeature DSCServiceFeature
    {
      Ensure = "Present"
      Name = "DSC-Service" 
    }

    # Ensure the web pull server is started on port 8080 over HTTP
    xDscWebService DSCWebPullServer
    {
      Ensure = "Present"
      EndpointName = "DSCPullServer"
      Port = 8080
      PhysicalPath = "$env:SystemDrive\inetpub\DSCPullServer"
      CertificateThumbPrint = "AllowUnencryptedTraffic" # Using HTTP
      ModulePath = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
      # Where configurations hosted by the pull server are located
      ConfigurationPath = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration" 
      State = "Started"
      DependsOn = "[WindowsFeature]DSCServiceFeature" 
      RegistrationKeyPath = "$env:PROGRAMFILES\WindowsPowerShell\DscService"
      UseSecurityBestPractices = $false # for demonstration purposes
    }

    # Create a file that stores the provided $RegistrationKey
    File RegistrationKeyFile
    {
      Ensure = 'Present'
      Type = 'File'
      DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
      Contents = $RegistrationKey
    }
  }
}