[DSCLocalConfigurationManager()]
configuration PullClientConfig
{
  Node localhost
  {
    Settings
    {
      RefreshMode = 'Pull'
      RefreshFrequencyMins = 30
      RebootNodeIfNeeded = $true
      # Automatically correct configurations that drift from the desired state
      ConfigurationMode = 'ApplyAndAutoCorrect'
    }
    
    ConfigurationRepositoryWeb CA-PullServer
    {
      ServerURL = 'http://ca-lab-vm:8080/PSDSCPullServer.svc'
      AllowUnsecureConnection = $true
      RegistrationKey = "INSERT_YOUR_REGISTRATION_KEY"
      ConfigurationNames = @("files")
    }
  }
}