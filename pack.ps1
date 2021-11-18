$ErrorActionPreference = "Inquire"

Get-Content "${PSScriptRoot}\config.ini" | foreach-object -begin {$config=@{}} -process {
	$k = [regex]::split($_,'=');
	if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True) -and ($k[0].StartsWith("#") -ne $True)) {
		$config.Add($k[0], $k[1])
	}
}

$pak_filename = "${PSScriptRoot}\build\$($config['mod_name'])-$($config['version']).pak"
$output_filename = "${PSScriptRoot}\$($config['mod_name'])-$($config['version']).zip"

trap [System.Management.Automation.ItemNotFoundException] {
    Remove-Item -Force $output_filename
}
trap [System.Management.Automation.ItemNotFoundException] {
    Remove-Item -Force "${PSScriptRoot}/response.txt"
}
trap [System.Management.Automation.ItemNotFoundException] {
    Remove-Item -Force "${PSScriptRoot}\build"
}
New-Item -Path "${PSScriptRoot}\build" -Type Directory -Force

"`"${PSScriptRoot}/pak/`" ../../../FSD/" | Out-File -FilePath "${PSScriptRoot}/response.txt"

Write-Host -NoNewline "Packing ..."
& $config['unrealpak'] "$pak_filename" "-Create=`"${PSScriptRoot}/response.txt`"" "-compress"
Write-Host "done"

Write-Host -NoNewline "Zipping ..."
Compress-Archive -Force -Path "${PSScriptRoot}\build" -DestinationPath "$output_filename"
Write-Host "done"
pause