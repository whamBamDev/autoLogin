cscript /E:vbscript plugins\autoLogin\autoLogin.vbs %1 %2 %3
ECHO EL = %ERRORLEVEL%
IF %ERRORLEVEL% NEQ 0 pause
rem pause