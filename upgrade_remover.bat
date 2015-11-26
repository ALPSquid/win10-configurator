:: Removes the Windows 10 update notification from machines that have not, and probably will not, be upgraded.
@echo off

call:uninstallPatch 3035583
call:uninstallPatch 2952664
call:uninstallPatch 2976978
call:uninstallPatch 3021917
call:uninstallPatch 3044374
call:uninstallPatch 2990214
call:uninstallPatch 3022345
goto:eof


:uninstallPatch
echo Removing KB%~1
wusa /uninstall /kb:%~1
goto:eof