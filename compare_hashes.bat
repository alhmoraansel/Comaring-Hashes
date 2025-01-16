@echo off
setlocal

rem Prompt user for the APK file name
set /p apkFile="Enter the APK file name (with extension): "

rem Prompt user for the SHA256 hash file name
set /p hashFile="Enter the SHA256 hash file name (with extension): "

rem Generate SHA-256 hash of the APK file
certutil -hashfile "%apkFile%" SHA256 > hash1.txt

rem Remove the last line from hash1.txt
for /f "delims=" %%a in ('find /v /c "" ^< hash1.txt') do set lines=%%a
set /a lines-=1
more +1 hash1.txt | findstr /v /r /c:"CertUtil: .*-hashfile .* completed successfully." > hash1_cleaned.txt

rem Read the provided SHA-256 hash from the hash file
for /f "tokens=*" %%i in (%hashFile%) do set hash2=%%i

rem Read the generated hash from hash1_cleaned.txt
for /f "tokens=*" %%i in (hash1_cleaned.txt) do set hash1=%%i

rem Compare the two hashes
if "%hash1%"=="%hash2%" (
    echo The hashes match! The file is authentic.
) else (
    echo The hashes do not match! The file may be corrupted or altered.
)

endlocal
