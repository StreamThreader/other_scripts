@echo off

rem "Script for completely remove user profile"
rem "Call delete_user_profile.bat with user name as argument"

set "SidValue="
set "USER_NAME=%1"
set "USER_DIR=D:\Users\%USER_NAME%"


IF "%USER_NAME%"=="" (
	echo "USER_NAME is NOT defined, exit"
	pause
	exit
)

rem "get user SID"
for /f %%i in ('wmic useraccount where name^=^'%USER_NAME%^' get sid ^| findstr ^S\-d*') do set SidValue=%%i

rem "delete user"
net user %USER_NAME% /delete

rem "delete user profile directory"
if exist %USER_DIR%\ (
  rd /s /q %USER_DIR%
  echo "folder %USER_DIR% removed"
) else (
  echo "folder %USER_DIR% not exist, skip"
)

if "%SidValue%"=="" (
	echo "SidValue is NOT defined, skip"
	pause
) else (
	rem "delete user from profile list"
	reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\%SidValue%" /f
	echo "sid value %SidValue% removed from registry"
)
