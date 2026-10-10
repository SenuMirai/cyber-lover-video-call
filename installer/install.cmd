@echo off
setlocal
title 安装 - 赛博恋人

set "SRC=%~dp0app.exe"
set "DESTDIR=%LOCALAPPDATA%\Programs\CyberLover"
set "DEST=%DESTDIR%\赛博恋人.exe"

echo.
echo   ================================
echo      正在安装  赛博恋人
echo   ================================
echo.

if not exist "%SRC%" (
  echo   [错误] 安装包里的 app.exe 不见了，请重新下载安装包。
  echo.
  pause
  exit /b 1
)

rem ---- 复制程序本体 ----
if not exist "%DESTDIR%" mkdir "%DESTDIR%" >nul 2>nul
copy /Y "%SRC%" "%DEST%" >nul
if errorlevel 1 (
  echo   [错误] 复制文件失败，可能被杀毒软件拦住了，关掉杀软再试一次。
  echo.
  pause
  exit /b 1
)

rem ---- 使用说明也留一份（安装包的临时目录会被清掉，不复制就看不到）----
if exist "%~dp0readme.txt" copy /Y "%~dp0readme.txt" "%DESTDIR%\使用说明.txt" >nul 2>nul

rem ---- 升级清理：老版本（赛博女友）残留的程序目录与快捷方式 ----
rem      只清程序，不动数据 —— 数据目录由主程序自己改名迁移过去。
if exist "%LOCALAPPDATA%\Programs\CyberGirlfriend" rd /s /q "%LOCALAPPDATA%\Programs\CyberGirlfriend" >nul 2>nul
del /q "%USERPROFILE%\Desktop\赛博女友.lnk" >nul 2>nul
del /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\赛博女友.lnk" >nul 2>nul

rem ---- 创建桌面 + 开始菜单快捷方式 ----
powershell -NoProfile -Command "$s=New-Object -ComObject WScript.Shell; $tgt=$env:LOCALAPPDATA+'\Programs\CyberLover\赛博恋人.exe'; $work=$env:LOCALAPPDATA+'\Programs\CyberLover'; $d=$s.CreateShortcut([Environment]::GetFolderPath('Desktop')+'\赛博恋人.lnk'); $d.TargetPath=$tgt; $d.WorkingDirectory=$work; $d.Description='赛博恋人'; $d.Save(); $m=$s.CreateShortcut([Environment]::GetFolderPath('Programs')+'\赛博恋人.lnk'); $m.TargetPath=$tgt; $m.WorkingDirectory=$work; $m.Description='赛博恋人'; $m.Save()" >nul 2>nul

echo   安装完成！
echo.
echo   · 桌面和开始菜单都有「赛博恋人」图标，双击即可启动
echo   · 程序装在：%DESTDIR%
echo   · 使用说明：%DESTDIR%\使用说明.txt
echo   · 你的数据（角色、形象图、设置、证书）在：
echo       %LOCALAPPDATA%\赛博恋人
echo   · 卸载：直接删掉上面这两个文件夹就行
echo.
echo   现在自动启动一次，浏览器会自动打开……
ping -n 3 127.0.0.1 >nul
start "" "%DEST%"
exit /b 0
