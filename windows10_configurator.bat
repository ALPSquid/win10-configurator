@echo off
setlocal EnableDelayedExpansion
:: ### Variables ###
SET dir=%~dp0data\
SET regDoOff="%dir%registry\delivery_optimisation\download_mode_off.reg"
SET regDoLan="%dir%registry\delivery_optimisation\download_mode_lan.reg"
SET regAu2="%dir%registry\auto_update\au_2.reg"
SET regAu3="%dir%registry\auto_update\au_3.reg"
SET regAu4="%dir%registry\auto_update\au_4.reg"
SET regAu5="%dir%registry\auto_update\au_5.reg"
SET regTelemetry="%dir%registry\telemetry\telemetry.reg"
SET regOnedrive="%dir%registry\onedrive\onedrive.reg"

SET hostEntries="%dir%hosts\entries.txt"

SET psMetro="%dir%metro\remove_apps.ps1"

SET divider=-----
SET skip=0
SET configOption=0
::###

::### Run as Admin by http://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file/10052222#10052222
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
::###


::### Main Program
echo %divider% Windows 10 Privacy Configurator %divider%
echo This tool will disable many questionable privacy settings that come enabled on Windows 10 and allow you to remove Metro apps. You can skip any step if you want to.
echo Mandatory Disclaimer: This software is provided without guarantee or warranty and I (the author) am not responsible for anything that goes wrong (not that it should).
pause
echo.

call:dividerCall deliveryOptimisation
call:dividerCall autoUpdate
call:dividerCall dataCollection
call:dividerCall onedrive
call:dividerCall appExperience
call:dividerCall hosts
call:dividerCall metroApps

echo.
echo Automatic configuration complete^^!
echo There's now several things you should change in the Settings app that couldn't be done automatically
pause

call:dividerCall wifiSense
call:dividerCall syncSettings
call:dividerCall privacy
call:dividerCall cortana
call:dividerCall ccleaner

echo %divider%
echo.
echo All done^^! Thanks for caring about your right to privacy^^!
pause
goto:eof
::###


::### Functions ####

:deliveryOptimisation
echo 1. Delivery Optimisation
echo.
echo Lets Windows share app and update files over the internet and LAN in a peer-to-peer fashion. This is a possible security risk, however you may like to set it to LAN only for faster updates on multiple PCs.
call:checkSkip
IF "!skip!"=="1" (
	echo Options:
	echo   1 = Disable [Recommended]
	echo   2 = LAN only
	echo   3 = Skip setting
	call:getConfigOption 123
	IF NOT "!configOption!"=="3" (
		IF "!configOption!"=="1" (
			call:runReg %regDoOff%
			echo DO disabled
		) ELSE IF "!configOption!"=="2" (
			call:runReg %regDoLan%
			echo DO set to LAN only
		)
	) ELSE (
		echo Setting skipped
	)
)
goto:eof

:autoUpdate
echo 2. Auto Update
echo.
echo Allows you to change how updates are downloaded and whether they are automatically installed. By default they are installed automatically.
call:checkSkip
IF "!skip!"=="1" (
	echo Options:
	echo   1 = Notify before downloading and installing any updates [Recommended]
	echo   2 = Download the updates automatically and notify when they are ready to be installed
	echo   3 = Automatically download updates and install them on the schedule specified
	echo   4 = Allow local administrators to select the configuration mode that Automatic Updates should notify and install updates
	echo   5 = Skip setting
	call:getConfigOption 12345
	IF NOT "!configOption!"=="5" (
		IF "!configOption!"=="1" call:runReg %regAu2%
		IF "!configOption!"=="2" call:runReg %regAu3%
		IF "!configOption!"=="3" call:runReg %regAu4%
		IF "!configOption!"=="4" call:runReg %regAu5%
		echo Done!
	) ELSE (
		echo Setting skipped
	)
)
goto:eof

:dataCollection
echo 3. Data Collection
echo.
echo Windows collects a lot of data about how you use the computer, including things you type, which is uploaded to their servers. It is highly recommended to disable this^^!
call:checkSkip
IF "!skip!"=="1" (
	sc stop diagtrack | REM
	sc stop dmwappushservice | REM
	sc config diagtrack start=disabled | REM
	sc config dmwappushservice start=disabled | REM
	sc delete diagtrack | REM
	sc delete dmwappushservice | REM
	del %programdata%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl | REM 
	echo "" > %programdata%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl | REM
	echo Y | cacls.exe %programdata%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl /d SYSTEM | REM
	call:runReg %regTelemetry%
	echo Done!
)
goto:eof

:onedrive
echo 4. OneDrive
echo.
echo OneDrive (formerly SkyDrive) is Microsoft's cloud sync client which is enabled by default and is plastered everywhere. This setting will disable it. Obviously if you use OneDrive, skip this setting.
call:checkSkip
IF "!skip!"=="1" (
	call:runReg %regOnedrive%
	echo Done!
)
goto:eof

:appExperience
echo 5. Application ^& Customer Experience Logging
echo.
echo Windows has several tasks that perform the gathering and uploading of app usage data. It is recommended to disable these^^!
call:checkSkip
IF "!skip!"=="1" (
	schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable | REM
	schtasks /change /tn "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable  | REM
	schtasks /change /tn "\Microsoft\Windows\Application Experience\StartupAppTask" /disable  | REM
	
	schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\BthSQM" /disable  | REM
	schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable  | REM
	schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /disable  | REM
	schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Uploader" /disable | REM
	schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable | REM
	echo Done!
)
goto:eof

:hosts
echo 6. Hosts File Entries
echo.
echo As an extra precaution, you can prevent Windows from being able to access Microsoft tracking servers. This will redirect all requests to these servers to an invalid IP (0.0.0.0) by editing your hosts file.
call:checkSkip
IF "!skip!"=="1" (
	type %hostEntries% >> "%systemdrive%\Windows\System32\drivers\etc\hosts"
)
goto:eof

:metroApps
echo 7. Metro Apps
echo.
echo Windows comes with a lot of mandatory Metro (tablet) apps which you may not want. You can uninstall them all with this setting. WARNING: there is no easy way of getting these apps back^^!
call:checkSkip
IF "!skip!"=="1" (
	echo Options:
	echo   1 = Remove ALL Metro apps from the system account, including Store [Recommended]
	echo   2 = Remove ALL Metro apps from the signed in user account, including Store
	echo   3 = Remove ALL Metro apps for all users, including Store
	echo   4 = Skip setting
	call:getConfigOption 1234
	IF NOT "!configOption!"=="4" (
		IF "!configOption!"=="1" call:runPS %psMetro% 1
		IF "!configOption!"=="2" call:runPS %psMetro% 2
		IF "!configOption!"=="3" call:runPS %psMetro% 3
		echo Done!
	) ELSE (
		echo Setting skipped
	)
)
goto:eof

:wifiSense
echo 1. WiFi Sense
echo.
echo Windows wants to try and share your WiFi passwords with your contacts, and Facebook and Skype friends. This is a potential security risk.
echo To disable:
echo   1. Go to Start ^> Settings ^> Network ^& Internet ^> Wi-Fi ^> Manage Wi-Fi Settings
echo   2. Disable every option
goto:eof

:syncSettings
echo 2. Sync Settings
echo.
echo When using a Microsoft account, Windows uploads arguably more data than you actually need to sync with your devices. To fix this, you can either use a Local Account (disabling sync completely), or turn off settings you don't need.
echo To change:
echo   1. Go to Start ^> Settings ^> Accounts ^> Sync Your Settings
echo   2. Disable what you don't need
goto:eof

:privacy
echo 3. Privacy ^& Feedback
echo.
echo Apps have access to a lot of data by default, most of which is unnecessary. Also, another Telemetry precaution is to change when and what feedback is sent. Note that Windows should be unable to send feedback at all if you used all of the automatic settings.
echo To change:
echo   1. Go to Start ^> Settings ^> Privacy
echo   2. Disable everything you don't want in each sub-menu
echo   3. In Feedback, set Never and Basic in each box respectively
goto:eof

:adTracking
echo 4. Ad Tracking
echo.
echo Each Windows 10 computer has a unique advertising ID which can be used to track the user and provide targeted ads. You probably disabled this feature in the last step, but if not:
echo   1. Go to Start ^> Settings ^> Privacy ^> General
echo   2. Disable the first option (Let apps use my advertising ID)
goto:eof

:cortana
echo 5. Cortana
echo.
echo If you don't have a burning reason to use Cortana, it's recommended to disable it as Microsoft stores everything you say and type to it.
echo   1. Open the search window from the taskbar (magnifying glass icon, search box or typing in the start menu)
echo   2. Click the Settings Wheel and disable both options
goto:eof

:ccleaner
echo 6. CCleaner Notice
echo.
echo If you use CCleaner and Windows Defender you need to disable the cleaning of Defender files otherwise Windows won't be able to update Defender's malware definitions
echo   1. In CCleaner ^> Cleaner ^> Appplications ^> Utilities untick Windows Defender
goto:eof

:: User input for skipping a setting. 
:: Variable changed = %skip%
:checkSkip
echo.
SET skip=0
CHOICE /M "Would you like to change this setting "
SET skip=%ERRORLEVEL%
goto:eof

:: User input for selecting an option. 
:: Args = available options e.g 123. 
:: Variable changed = %configOption%
:getConfigOption
echo.
SET configOption=0
CHOICE /C %~1 /M "Enter option: "
SET configOption=%ERRORLEVEL%
goto:eof

:: Runs a reg file silently.
:: Args = path to .reg
:runReg
regedit.exe /s "%~1"
goto:eof

:: Runs a PowerShell Script Silently
:: Args = path to .ps1, script arguments
:runPS
powershell -ExecutionPolicy Unrestricted "& '%~1'" %~2 | REM
goto:eof

:: Runs the specified function with a divider print before hand
:: Args = name of function to call
:dividerCall
echo %divider%
echo.
call:%~1
pause
goto:eof