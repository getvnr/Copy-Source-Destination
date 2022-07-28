#Backup Location Creation.

$FolderName = (Get-Date).tostring("dd-MM-yyyy-hh-mm-ss")            
$location =  New-Item -itemType Directory -Path $pwd\Backup\ -Name ($FolderName + ".Backup")

#Warning message

 Write-Host Step 1 Below files will be taken backup.........
 
#Import file.csv and Backup path
$path = "$pwd\input.csv"
$backup = "$location\"
$jobs = Import-CSV $path -Verbose
Import-Csv $path | select Destination | FT

# Warning about files avaliablity in the destination

$jobs | ForEach-Object{ 
  if ((Test-Path $_.Destination) -eq $true) {
    Write-Host "The files which you are going to deploy. With same name already exists in the destination directory still do you want to replace it"
} 
else {
    Write-Host "The files which you are going to deploy doesn't seems to exists in Destination. Do you want to still deploy the files to the destination" }
}
    
 Start-Sleep -Seconds 5

#Taking backup before execution
$jobs | ForEach-Object{ 

# Taking backup before execution. 
  If(Test-Path $_.Destination){Copy-Item $_.Destination $backup  -Force}

  }

Write-Host Step 2 Backup completed and listing files.......


Get-ChildItem $backup | FT

Start-Sleep -Seconds 5


Write-Host "Step 3 Below Source files will be deployed to destination please validate once before you proceed further........"
$Source = "$pwd\Source\"
Get-ChildItem $Source | FT

Start-Sleep -Seconds 5

Write-Host "Step 4 Please validate the source and destination before you deploy and Enter to continue Press Ctrl+C to Cancel"

Import-Csv $path | select Source, Destination | FT

Start-Sleep -Seconds 5
pause

#Taking backup before execution
$jobs | ForEach-Object{ 
# Execution of Source to Destination.
  If(Test-Path $_.Source){Copy-Item $_.Source $_.Destination -Force}
}

Write-Host Step 5 Change executed successfuly please do the health check........
Start-Sleep -Seconds 1