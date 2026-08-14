@echo off

:: Importing Synez Power Plan & Setting to Active
echo Importing Synez Power Plan

powershell "ForEach($v in (Get-Command -Name \"Set-ProcessMitigation\").Parameters[\"Disable\"].Attributes.ValidValues){Set-ProcessMitigation -System -Disable $v.ToString() -ErrorAction SilentlyContinue}" >> Synez.txt

:: Download Synez Power Plan
curl -g -k -L -# -o "C:\Windows\Temp\Synez_Public_Power.pow" "https://github.com/synez-os/power-synez/raw/refs/heads/main/Synez_Public_Power.pow" >> Synez.txt

:: Import and activate the new power plan
powercfg -import "C:\Windows\Temp\Synez_Public_Power.pow" 22222222-2222-2222-2222-222222222222 >> Synez.txt
powercfg -setactive 22222222-2222-2222-2222-222222222222 >> Synez.txt

echo Finished