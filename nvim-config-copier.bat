@echo off

set NVIM_HOME=C:\Users\aditya\AppData\Local\nvim
set NVIM_CONFIG=.\configs\.config\nvim

IF %1.==. GOTO Noarg
IF "%1" == "f" GOTO Copyfrom
IF "%1" == "t" GOTO Copyto

:Copyto
copy %NVIM_CONFIG%\init.vim %NVIM_HOME%\
GOTO End

:Copyfrom
copy %NVIM_HOME%\init.vim %NVIM_CONFIG%\
git add .
git commit -m "Updated nvim config"
git push
GOTO End

:Noarg
ECHO No param
ECHO t: copy from configs to the user home
ECHO f: copy from user home to the configs
GOTO End

:End
