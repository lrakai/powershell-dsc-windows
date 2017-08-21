Configuration CopyFiles
{ 
  param
  (
    [ValidateNotNullOrEmpty()]
    [string] $NodeName = 'localhost'
 )

 Import-DscResource –ModuleName 'PSDesiredStateConfiguration'

 Node $NodeName
  { 
    File FileCopy 
    { 
      Ensure          = "Present" # You can also set Ensure to "Absent" 
      Type            = "File"    # You can also set to "Directory"
      Contents        = "Configured via pull server"
      DestinationPath = "C:\Users\student\Desktop\file.txt"
    } 
  }
}