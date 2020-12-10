@echo off

set EMACS_HOME=C:\Users\aditya\AppData\Roaming
set EMACS_CONFIG=..\configs\.config

IF %1.==. GOTO Noarg
IF "%1" == "f" GOTO Copyfrom
IF "%1" == "t" GOTO Copyto

:Copyto
copy %EMACS_CONFIG%\.emacs %EMACS_HOME%\
GOTO End

:Copyfrom
copy %EMACS_HOME%\.emacs %EMACS_CONFIG%\
pushd ..\
git add .
git commit -m "Updated emacs config"
git push
popd
GOTO End

:Noarg
ECHO No param
ECHO t: copy from configs to the user home
ECHO f: copy from user home to the configs
GOTO End

:End
