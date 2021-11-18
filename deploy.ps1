$ErrorActionPreference = "Inquire"

Get-Content "${PSScriptRoot}\config.ini" | foreach-object -begin {$config=@{}} -process {
	$k = [regex]::split($_,'=');
	if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True) -and ($k[0].StartsWith("#") -ne $True)) {
		$config.Add($k[0], $k[1])
	}
}

$zip_filename = "${PSScriptRoot}\$($config['mod_name'])-$($config['version']).zip"

if (Test-Path -Path $zip_filename) {
    & "$($config['modiom'])" upload $config['game_id'] $config['mod_id'] $zip_filename
} else {
    Write-Host "ERROR: ${zip_filename} does not exist."
}
pause