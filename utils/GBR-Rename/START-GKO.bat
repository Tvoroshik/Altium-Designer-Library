setlocal enableextensions
@set src=GERBER
@set resultdir=OK
@set resultgerb="%resultdir%"\GERBER
@set resultnc="%resultdir%"\NCDRILL
@set batname=%~n0
@set layer=%batname:~-3%

@if not exist "%resultdir%" md "%resultdir%"
@if not exist "%resultgerb%" md "%resultgerb%"
@if not exist "%resultnc%" md "%resultnc%"

@if exist "%src%"\*.GTL COPY "%src%"\*.GTL /B "%resultgerb%"\TOP.GBR
@if exist "%src%"\*.GBL COPY "%src%"\*.GBL /B "%resultgerb%"\BOT.GBR
@if exist "%src%"\*.GTS COPY "%src%"\*.GTS /B "%resultgerb%"\TOPMASK.GBR
@if exist "%src%"\*.GBS COPY "%src%"\*.GBS /B "%resultgerb%"\BOTMASK.GBR
@if exist "%src%"\*.GTO COPY "%src%"\*.GTO /B "%resultgerb%"\TOPMARK.GBR
@if exist "%src%"\*.GBO COPY "%src%"\*.GBO /B "%resultgerb%"\BOTMARK.GBR
@if exist "%src%"\*.%layer% COPY "%src%"\*.%layer% /B "%resultgerb%"\BRDOUT.GBR

@goto :start
:p
@set /a count=%count%+1
@set f=%~1
@echo off
@copy "%src%\%f%" "%resultgerb%"\INT%count%.GBR
@goto :eof
:start
@set /a count=0
@echo off
@for /F "delims=" %%A IN ('dir /B /A-D "%src%\*.*" ^| findstr /R "\.G[P0-9]"') do (call :p "%%A")

@COPY "NC Drill\*.*" "%resultnc%"\*.*
@COPY "NCDrill\*.*" "%resultnc%"\*.*
@CD OK\
@"c:\Program Files\7-Zip\7z.exe" a "..\PROJECT.zip" -r -tzip "GERBER\"
@"c:\Program Files\7-Zip\7z.exe" a "..\PROJECT.zip" -r -tzip "NCDRILL\"
@CD ..
@RD OK /s /q