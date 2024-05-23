@echo off
setlocal enabledelayedexpansion

REM Path to handle.exe
set HANDLE_PATH=C:\Users\admin\Downloads\Handle\handle64.exe

REM Loop through each directory
for %%d in ("C:\Users\admin\Desktop\devops\tempDir" "C:\Users\admin\Desktop\devops\tempDir2") do (
    REM Change the directory to the current folder
    cd "%%d"

    REM Initialize counters
    set /a count=0
    set /a file_count=0

    REM Create a list of files sorted by creation time, last access time, and last write time
    set "file_list="
    for /f "delims=" %%i in ('dir /b /a:-d /o-d /tc *.*') do (
        set "file_list=!file_list! "%%i""
    )

    REM Skip the first 3 files (latest ones)
    set /a skip_count=0
    for %%i in (!file_list!) do (
        set /a skip_count+=1
        if !skip_count! leq 3 (
            echo Skipping file "%%i", it is one of the three latest files.
        ) else (
            echo Attempting to delete file "%%i"
            :retry
            REM Attempt to delete the file
            del /f /q "%%i" >nul 2>&1
            if exist "%%i" (
                echo File "%%i" could not be deleted. Attempting to resolve...
                REM Use handle.exe to find the process locking the file
                for /f "tokens=3 delims= " %%p in ('%HANDLE_PATH% "%%i" ^| findstr "pid:"') do (
                    echo Found process %%p using file "%%i"
                    REM Terminate the process
                    taskkill /F /PID %%p >nul 2>&1
                    if not errorlevel 1 (
                        echo Terminated process %%p for file "%%i"
                    ) else (
                        echo Failed to terminate process %%p for file "%%i"
                    )
                )
                REM Retry deletion
                del /f /q "%%i" >nul 2>&1
                if exist "%%i" (
                    echo Failed to delete file "%%i" after terminating processes.
                ) else (
                    echo Successfully deleted file "%%i" after resolving issues
                    set /a count+=1
                )
            ) else (
                echo Successfully deleted file "%%i"
                set /a count+=1
            )
        )
    )

    REM Echo how many files were deleted
    echo !count! files deleted from path "%%d"
)

endlocal
