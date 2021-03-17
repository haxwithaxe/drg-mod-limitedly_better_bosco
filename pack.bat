call config.bat
echo "%~dp0pak\" "../../../FSD/" > "%~dp0response.txt"
"%unrealpak%" "%~dp0%mod_name%-dev_P.pak" -Create="%~dp0response.txt" -compress
pause