function Get-CheckSumValid {
param(
  [string] $file,
  [string] $checksum = '',
  [string] $checksumType = 'md5'
)
  Write-Debug "Running 'Get-CheckSumValid' with file:`'$file`', checksum: `'$checksum`', checksumType: `'$checksumType`'";
  if ($checksum -eq '' -or $checksum -eq $null) { return }

  if(!([System.IO.File]::Exists($file))) { Write-Host "Unable to checksum a file that doesn't exist - Could not find file `'$file`'"; return }

  # On first install, env:ChocolateyInstall might be null still - join-path has issues

  $checksumExe =  Join-Path "$env:SystemDrive" 'chocolatey\chocolateyinstall\tools\checksum.exe'
  if ($env:ChocolateyInstall){
    $checksumExe = Join-Path "$env:ChocolateyInstall" 'chocolateyinstall\tools\checksum.exe'
  }

  Write-Debug "Calling command [`'$checksumExe`' -c$checksum `"$file`"] to retrieve checksum"
  $process = Start-Process "$checksumExe" -ArgumentList " -c=`"$checksum`" -t=`"$checksumType`" -f=`"$file`"" -Wait -WindowStyle Hidden -PassThru

  Write-Debug "`'$checksumExe`' exited with $($process.ExitCode)"

  if ($process.ExitCode -ne 0) {
    throw "Checksum for `'$file'` did not meet `'$checksum`' for checksum type `'$checksumType`'."
  }

  #$fileCheckSumActual = $md5Output.Split(' ')[0]
  # if ($fileCheckSumActual -ne $checkSum) {
  #   throw "CheckSum for `'$file'` did not meet `'$checkSum`'."
  # }
}
