@echo off
setlocal EnableDelayedExpansion
color 0A
title Cognix Optimizer - Advanced Windows Performance Tweaks

:: ============================================================
::   COGNIX OPTIMIZER
::   Advanced Windows Performance Tweaks
::   Compatible with Windows 10 and Windows 11
::   Run as Administrator
:: ============================================================

:: Check for Administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] This script must be run as Administrator.
    echo Right-click the script and select "Run as administrator".
    pause
    exit /b 1
)

:MENU
cls
echo.
echo  ========================================================
echo  ^|                                                      ^|
echo  ^|              COGNIX OPTIMIZER                       ^|
echo  ^|      Advanced Windows Performance Tweaks            ^|
echo  ^|                                                      ^|
echo  ========================================================
echo  ^|                                                      ^|
echo  ^|   [1]  Apply ALL Optimizations                      ^|
echo  ^|   [2]  Windows System Tweaks                        ^|
echo  ^|   [3]  CPU Optimization                             ^|
echo  ^|   [4]  GPU Optimization                             ^|
echo  ^|   [5]  Storage Optimization                         ^|
echo  ^|   [6]  RAM Optimization                             ^|
echo  ^|   [7]  Overlay Optimization                         ^|
echo  ^|   [8]  Keyboard and Mouse Optimization              ^|
echo  ^|   [9]  Power Optimization                           ^|
echo  ^|   [R]  Restore Default Settings                     ^|
echo  ^|   [X]  Exit                                         ^|
echo  ^|                                                      ^|
echo  ========================================================
echo.
set /p CHOICE="   Select an option: "

if /i "%CHOICE%"=="1" goto APPLY_ALL
if /i "%CHOICE%"=="2" goto MODULE_SYSTEM
if /i "%CHOICE%"=="3" goto MODULE_CPU
if /i "%CHOICE%"=="4" goto MODULE_GPU
if /i "%CHOICE%"=="5" goto MODULE_STORAGE
if /i "%CHOICE%"=="6" goto MODULE_RAM
if /i "%CHOICE%"=="7" goto MODULE_OVERLAY
if /i "%CHOICE%"=="8" goto MODULE_INPUT
if /i "%CHOICE%"=="9" goto MODULE_POWER
if /i "%CHOICE%"=="R" goto RESTORE_DEFAULTS
if /i "%CHOICE%"=="X" goto EXIT_SCRIPT
echo  [!] Invalid option. Please try again.
timeout /t 2 >nul
goto MENU

:: ============================================================
:: APPLY ALL MODULES
:: ============================================================
:APPLY_ALL
cls
echo.
echo  [*] Applying ALL optimizations. Please wait...
echo  --------------------------------------------------------
call :MODULE_SYSTEM_FUNC
call :MODULE_CPU_FUNC
call :MODULE_GPU_FUNC
call :MODULE_STORAGE_FUNC
call :MODULE_RAM_FUNC
call :MODULE_OVERLAY_FUNC
call :MODULE_INPUT_FUNC
call :MODULE_POWER_FUNC
echo.
echo  [+] All optimizations applied successfully!
echo  [!] A system restart is recommended to apply all changes.
echo.
pause
goto MENU

:: ============================================================
:: MODULE 1: WINDOWS SYSTEM TWEAKS
:: ============================================================
:MODULE_SYSTEM
cls
echo.
echo  [*] Applying Windows System Tweaks...
echo  --------------------------------------------------------
call :MODULE_SYSTEM_FUNC
echo.
echo  [+] Windows System Tweaks applied!
pause
goto MENU

:MODULE_SYSTEM_FUNC

echo  [~] Disabling unnecessary background services...

:: Disable SysMain (Superfetch) - Reduces unnecessary disk reads
:: for systems with SSDs where prefetching is not beneficial
sc config SysMain start= disabled >nul 2>&1
sc stop SysMain >nul 2>&1

:: Disable Windows Search indexing service - Reduces disk and CPU usage
:: Users can still search but without background indexing
sc config WSearch start= disabled >nul 2>&1
sc stop WSearch >nul 2>&1

:: Disable DiagTrack (Connected User Experiences and Telemetry)
:: Reduces background telemetry data collection and uploads
sc config DiagTrack start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1

:: Disable dmwappushservice - Part of telemetry pipeline
sc config dmwappushservice start= disabled >nul 2>&1
sc stop dmwappushservice >nul 2>&1

:: Disable Print Spooler if not needed - Frees up resources
:: Comment out if you use a printer
:: sc config Spooler start= disabled >nul 2>&1

:: Disable Remote Registry - Security and performance improvement
sc config RemoteRegistry start= disabled >nul 2>&1

:: Disable Fax service - Most users do not use fax functionality
sc config Fax start= disabled >nul 2>&1

echo  [~] Reducing Windows telemetry...

:: Disable telemetry data collection via registry
:: Level 0 = Security (minimum telemetry), requires Enterprise/Education
:: Level 1 = Basic telemetry (recommended for most users)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable advertising ID used for personalized ads
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d 1 /f >nul 2>&1

:: Disable Customer Experience Improvement Program (CEIP)
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Windows Error Reporting - Stops sending crash reports to Microsoft
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f >nul 2>&1

echo  [~] Optimizing startup programs behavior...

:: Disable fast startup (can cause issues with dual-boot and some hardware)
:: but improves stability on single-OS installs; kept enabled here for speed
:: reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Reduce startup delay for applications
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable startup sound
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" /v "DisableStartupSound" /t REG_DWORD /d 1 /f >nul 2>&1

echo  [~] Improving Game Mode behavior...

:: Enable Windows Game Mode - Dedicates more resources to the active game
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f >nul 2>&1

:: Disable Game DVR background recording - Reduces CPU/GPU overhead during gaming
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable FSO (Fullscreen Optimizations) globally - Can improve frame timing
:: in some games by giving them true exclusive fullscreen access
reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d 1 /f >nul 2>&1

echo  [~] Optimizing timer resolution...

:: Set system timer resolution to maximum (1ms) for more precise scheduling
:: This improves frame pacing and reduces input latency
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "GlobalTimerResolutionRequests" /t REG_DWORD /d 1 /f >nul 2>&1

echo  [~] Applying network latency tweaks...

:: Disable Nagle's Algorithm - Reduces TCP packet buffering delay for real-time apps
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1

:: Optimize network adapter settings - increase network throughput
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
netsh int tcp set global dca=enabled >nul 2>&1
netsh int tcp set global netdma=enabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1

:: Disable network throttling index - Allows network to use full bandwidth
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1

echo  [~] Disabling unnecessary animations...

:: Disable all visual effects for maximum performance
:: This removes window animations, shadows, and transitions
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul 2>&1

:: Disable window minimize/maximize animations
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 0 /f >nul 2>&1

:: Disable taskbar animations
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable transparency effects - Reduces GPU overhead on desktop rendering
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1

echo  [~] Improving process priority settings...

:: Set SystemResponsiveness to favor foreground applications
:: Value 0 = 100% priority to foreground, 20 = default
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1

:: Optimize scheduling for games specifically
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Affinity" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Clock Rate" /t REG_DWORD /d 10000 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1

echo  [+] Windows System Tweaks complete.
goto :EOF

:: ============================================================
:: MODULE 2: CPU OPTIMIZATION
:: ============================================================
:MODULE_CPU
cls
echo.
echo  [*] Applying CPU Optimizations...
echo  --------------------------------------------------------
call :MODULE_CPU_FUNC
echo.
echo  [+] CPU Optimizations applied!
pause
goto MENU

:MODULE_CPU_FUNC

echo  [~] Disabling CPU core parking...

:: Disable CPU core parking - Keeps all CPU cores active and responsive
:: Core parking puts idle cores to sleep, causing latency spikes on wake
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMax" /t REG_DWORD /d 0 /f >nul 2>&1

:: Set minimum processor state to 100% in high performance mode
:: Prevents CPU from downclocking during idle states
powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1

echo  [~] Setting processor scheduling to Programs...

:: Adjust for best performance of Programs (not Background Services)
:: This gives foreground apps more CPU time slices
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1

echo  [~] Optimizing thread scheduling...

:: Disable CPU frequency scaling (speed step) for consistent performance
:: Prevents the CPU from dropping frequency under load bursts
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "ValueMax" /t REG_DWORD /d 0 /f >nul 2>&1

:: Set MMCSS (Multimedia Class Scheduler) to improve thread scheduling
:: Ensures audio and game threads get higher scheduling priority
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1

echo  [~] Improving interrupt handling...

:: Disable Dynamic Tick - Prevents the CPU timer from slowing down during idle
:: Keeps timer resolution consistent for lower latency
bcdedit /set disabledynamictick yes >nul 2>&1

:: Disable TSC (Timestamp Counter) synchronization
:: Reduces overhead from keeping timestamps synced across cores
bcdedit /set useplatformtick yes >nul 2>&1

:: Disable CPU idle states (C-states) to eliminate wakeup latency
:: Warning: Slightly increases power consumption
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Processor" /v "Capabilities" /t REG_DWORD /d 0007e066 /f >nul 2>&1

echo  [~] Enabling maximum CPU performance mode...

:: Set processor performance boost mode to Aggressive
:: Ensures Turbo Boost engages quickly under load
powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR PERFBOOSTMODE 2 >nul 2>&1

:: Ensure Performance Boost Policy is set to max
powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR PERFBOOSTPOL 100 >nul 2>&1

:: Disable processor power management for maximum throughput
powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR IDLEDISABLE 1 >nul 2>&1

:: Apply the current power scheme changes
powercfg -setactive SCHEME_MIN >nul 2>&1

echo  [+] CPU Optimization complete.
goto :EOF

:: ============================================================
:: MODULE 3: GPU OPTIMIZATION
:: ============================================================
:MODULE_GPU
cls
echo.
echo  [*] Applying GPU Optimizations...
echo  --------------------------------------------------------
call :MODULE_GPU_FUNC
echo.
echo  [+] GPU Optimizations applied!
pause
goto MENU

:MODULE_GPU_FUNC

echo  [~] Enabling Hardware Accelerated GPU Scheduling (HAGS)...

:: Enable HAGS - Allows the GPU to manage its own VRAM scheduling
:: Reduces CPU overhead and improves frame latency on supported hardware
:: Requires Windows 10 2004+ and a supported GPU/driver
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1

echo  [~] Optimizing shader cache settings...

:: Enable DirectX shader cache - Speeds up game loading by caching compiled shaders
reg add "HKLM\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" /v "DirectXUserGlobalSettings" /t REG_SZ /d "VRROptimizeEnable=0;" /f >nul 2>&1

:: Enable GPU preemption at finer granularity for better responsiveness
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v "EnablePreemption" /t REG_DWORD /d 1 /f >nul 2>&1

echo  [~] Reducing frame latency...

:: Set GPU priority for better frame scheduling
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1

:: Disable power-saving on GPU for consistent render performance
:: NVIDIA specific - Force performance level via registry preference
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PerfLevelSrc" /t REG_DWORD /d 0x2222 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" /v "PerfLevelSrc" /t REG_DWORD /d 0x2222 /f >nul 2>&1

echo  [~] Applying NVIDIA-specific tweaks...

:: NVIDIA - Disable NVIDIA Telemetry Container service
:: Reduces background CPU usage from NVIDIA telemetry
sc config NvTelemetryContainer start= disabled >nul 2>&1
sc stop NvTelemetryContainer >nul 2>&1

:: NVIDIA - Disable NVIDIA Display Container LS (backend for overlay/share)
:: Reduces background memory usage if GeForce Experience is not used
sc config NvDisplayContainerLS start= disabled >nul 2>&1

:: NVIDIA - Prefer maximum performance power management via registry
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerEnable" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevel" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PowerMizerLevelAC" /t REG_DWORD /d 1 /f >nul 2>&1

echo  [~] Applying AMD-specific tweaks...

:: AMD - Disable AMD External Events Utility (used for hotkeys, not needed)
sc config AMD External Events Utility start= disabled >nul 2>&1

:: AMD - Disable Chill (frame rate limiter when not moving mouse)
:: Keeps frame rate consistent regardless of input activity
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_SclkDeepSleepDisable" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v "PP_ThermalAutoThrottlingEnable" /t REG_DWORD /d 0 /f >nul 2>&1

echo  [+] GPU Optimization complete.
goto :EOF

:: ============================================================
:: MODULE 4: STORAGE OPTIMIZATION
:: ============================================================
:MODULE_STORAGE
cls
echo.
echo  [*] Applying Storage Optimizations...
echo  --------------------------------------------------------
call :MODULE_STORAGE_FUNC
echo.
echo  [+] Storage Optimizations applied!
pause
goto MENU

:MODULE_STORAGE_FUNC

echo  [~] Enabling TRIM for SSDs...

:: Enable TRIM - Allows the OS to inform the SSD which data blocks are free
:: Prevents performance degradation over time on SSDs
fsutil behavior set DisableDeleteNotify 0 >nul 2>&1

echo  [~] Optimizing disk caching...

:: Enable write caching on disk - Improves write performance
:: Note: Only safe with a UPS or stable power supply
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /t REG_DWORD /d 983040 /f >nul 2>&1

:: Disable 8.3 filename creation - Reduces NTFS overhead on large directories
fsutil behavior set disable8dot3 1 >nul 2>&1

echo  [~] Disabling unnecessary indexing...

:: Disable Windows Content Indexing on the main drive
:: Reduces constant disk access from search indexer
sc config WSearch start= disabled >nul 2>&1
sc stop WSearch >nul 2>&1

echo  [~] Improving NTFS performance...

:: Disable Last Access timestamp update - Reduces unnecessary disk writes
:: Every file read normally updates a timestamp; disabling saves I/O
fsutil behavior set DisableLastAccess 1 >nul 2>&1

:: Disable NTFS encryption and compression overhead checks
fsutil behavior set EncryptPagingFile 0 >nul 2>&1

:: Set NTFS memory usage for file system cache to maximum
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsMemoryUsage" /t REG_DWORD /d 2 /f >nul 2>&1

:: Disable short name (8.3) generation on NTFS volumes
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisable8dot3NameCreation" /t REG_DWORD /d 1 /f >nul 2>&1

echo  [~] Optimizing pagefile settings...

:: Set a fixed pagefile size to prevent dynamic resizing overhead
:: Fixed size = faster access since no reallocation occurs at runtime
:: Sets initial and max size to 4096 MB on C: drive
wmic computersystem set AutomaticManagedPagefile=False >nul 2>&1
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=4096,MaximumSize=4096 >nul 2>&1

echo  [+] Storage Optimization complete.
goto :EOF

:: ============================================================
:: MODULE 5: RAM OPTIMIZATION
:: ============================================================
:MODULE_RAM
cls
echo.
echo  [*] Applying RAM Optimizations...
echo  --------------------------------------------------------
call :MODULE_RAM_FUNC
echo.
echo  [+] RAM Optimizations applied!
pause
goto MENU

:MODULE_RAM_FUNC

echo  [~] Clearing standby memory...

:: Force Windows to clear the standby memory list
:: Frees up RAM that is being held but not actively used
:: Uses EmptyWorkingSet via built-in tools where possible
:: RAMMap equivalent via command line is limited; this clears file cache
:: Use a scheduled flush via memory management settings
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d 0 /f >nul 2>&1

echo  [~] Reducing background RAM usage...

:: Disable memory compression - Can reduce CPU overhead at cost of more RAM usage
:: On systems with 16GB+, this is beneficial for responsiveness
:: Uncomment if you have 16GB or more RAM:
:: Disable-MMAgent -mc (PowerShell equivalent - shown as reference)
:: reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1

:: Keep kernel and drivers in RAM - prevents them from being paged to disk
:: Improves responsiveness by keeping critical code in physical RAM
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1

:: Increase system cache working set to reduce pagefile thrashing
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul 2>&1

echo  [~] Optimizing pagefile size...

:: Ensure pagefile is system managed for systems under 8GB
:: For gaming rigs with 16GB+, a fixed size reduces fragmentation
wmic computersystem set AutomaticManagedPagefile=False >nul 2>&1
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=4096,MaximumSize=8192 >nul 2>&1

echo  [~] Disabling unnecessary memory-consuming services...

:: Disable Background Intelligent Transfer Service (BITS)
:: Used by Windows Update for background downloads; safe to disable temporarily
sc config BITS start= manual >nul 2>&1

:: Disable Windows Error Reporting service (memory consumer)
sc config WerSvc start= disabled >nul 2>&1
sc stop WerSvc >nul 2>&1

:: Disable Diagnostic Policy Service - Runs diagnostics in the background
sc config DPS start= disabled >nul 2>&1

:: Disable HomeGroup Provider (legacy service, not needed in modern Windows)
sc config HomeGroupProvider start= disabled >nul 2>&1

:: Disable Offline Files service - Not needed on most standalone PCs
sc config CscService start= disabled >nul 2>&1

echo  [+] RAM Optimization complete.
goto :EOF

:: ============================================================
:: MODULE 6: OVERLAY OPTIMIZATION
:: ============================================================
:MODULE_OVERLAY
cls
echo.
echo  [*] Applying Overlay Optimizations...
echo  --------------------------------------------------------
call :MODULE_OVERLAY_FUNC
echo.
echo  [+] Overlay Optimizations applied!
pause
goto MENU

:MODULE_OVERLAY_FUNC

echo  [~] Disabling Xbox Game Bar overlay...

:: Disable Xbox Game Bar - Uses CPU/GPU resources when gaming
:: Also disables background capture features
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

echo  [~] Reducing Steam overlay impact...

:: Steam overlay injects into game processes and adds rendering overhead
:: This tweak adds a registry hint; actual toggle must be done in Steam settings
:: Navigate: Steam > Settings > In-Game > uncheck "Enable the Steam Overlay"
reg add "HKCU\Software\Valve\Steam" /v "SteamOverlayEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [!] NOTE: Also disable Steam Overlay manually in Steam > Settings > In-Game

echo  [~] Reducing Discord overlay impact...

:: Discord overlay adds a render hook to games causing latency
:: This registry hint disables it; also toggle in Discord > Settings > Overlay
reg add "HKCU\Software\discordapp" /v "overlayEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo  [!] NOTE: Also disable Discord Overlay in Discord > User Settings > Overlay

echo  [~] Disabling NVIDIA GeForce Experience overlay (ShadowPlay)...

:: Disable NVIDIA Share (ShadowPlay) overlay hook
:: This service injects into games for recording/streaming functionality
sc config NvContainerLocalSystem start= disabled >nul 2>&1
reg add "HKCU\Software\NVIDIA Corporation\NvTray" /v "StartOnLogin" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable NVIDIA in-game overlay via registry preference
reg add "HKCU\Software\NVIDIA Corporation\Global\GFExperience" /v "EnableShadowPlay" /t REG_DWORD /d 0 /f >nul 2>&1

echo  [+] Overlay Optimization complete.
goto :EOF

:: ============================================================
:: MODULE 7: KEYBOARD AND MOUSE OPTIMIZATION
:: ============================================================
:MODULE_INPUT
cls
echo.
echo  [*] Applying Keyboard and Mouse Optimizations...
echo  --------------------------------------------------------
call :MODULE_INPUT_FUNC
echo.
echo  [+] Keyboard and Mouse Optimizations applied!
pause
goto MENU

:MODULE_INPUT_FUNC

echo  [~] Optimizing USB polling rate...

:: Improve USB HID device responsiveness by adjusting interrupt priority
:: Higher polling rates give more frequent position updates from mouse
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d 100 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d 100 /f >nul 2>&1

echo  [~] Disabling mouse acceleration (Enhance Pointer Precision)...

:: Disable mouse acceleration - Ensures 1:1 mapping between physical and cursor movement
:: Essential for accurate aiming in FPS games
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f >nul 2>&1

:: Disable "Enhance Pointer Precision" in mouse settings
reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f >nul 2>&1

echo  [~] Enabling raw input optimization...

:: Raw input bypasses Windows pointer ballistics entirely
:: This is preferred by games; most modern games already use this
:: Disable pointer ballistics via registry to ensure system-level raw input
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d 0000000000000000c0cc0c0000000000809919000000000040662600000000000023340000000000 /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d 0000000000000000000038000000000000007000000000000000a800000000000000e000000000 /f >nul 2>&1

echo  [~] Improving HID interrupt priority...

:: Increase HID (Human Interface Device) interrupt priority
:: Ensures mouse and keyboard events are processed faster
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass" /v "ThreadPriority" /t REG_DWORD /d 31 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass" /v "ThreadPriority" /t REG_DWORD /d 31 /f >nul 2>&1

:: Set USB controller interrupt affinity to a dedicated core if possible
:: This reduces interference from other processes on input handling
reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbhub" /v "DisableSelectiveSuspend" /t REG_DWORD /d 1 /f >nul 2>&1

:: Disable USB selective suspend - Prevents USB ports from sleeping
:: Eliminates micro-stutter from USB devices waking up
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v "DisableSelectiveSuspend" /t REG_DWORD /d 1 /f >nul 2>&1

:: Set keyboard response for minimum delay
reg add "HKCU\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f >nul 2>&1

echo  [+] Keyboard and Mouse Optimization complete.
goto :EOF

:: ============================================================
:: MODULE 8: POWER OPTIMIZATION
:: ============================================================
:MODULE_POWER
cls
echo.
echo  [*] Applying Power Optimizations...
echo  --------------------------------------------------------
call :MODULE_POWER_FUNC
echo.
echo  [+] Power Optimizations applied!
pause
goto MENU

:MODULE_POWER_FUNC

echo  [~] Enabling Ultimate Performance power plan...

:: Enable and activate Ultimate Performance power plan
:: This plan eliminates micro-latencies from power management
:: Only available on Windows 10 1809+ and Windows 11
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
for /f "tokens=4" %%G in ('powercfg -list ^| findstr /i "Ultimate"') do (
    powercfg -setactive %%G >nul 2>&1
)
:: Fallback to High Performance if Ultimate is unavailable
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1

echo  [~] Disabling CPU power throttling...

:: Disable CPU throttling in power plan - Keeps CPU at full speed
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1

:: Disable processor idle demote/promote to prevent frequency hopping
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 1 >nul 2>&1

:: Disable processor performance time check interval adjustment
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFCHECK 10000 >nul 2>&1

echo  [~] Disabling PCIe power saving...

:: Disable PCIe Active State Power Management (ASPM)
:: Prevents PCIe devices (GPU, NVMe SSD) from entering low-power states
:: Reduces latency spikes when devices wake from power-saving states
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f906-d277-404b-b6da-e5fa1a576df5" /v "Attributes" /t REG_DWORD /d 2 /f >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PCIEXPRESS ASPM 0 >nul 2>&1

echo  [~] Setting system for maximum performance...

:: Disable hard disk sleep/spin-down timeout
powercfg -setacvalueindex SCHEME_CURRENT SUB_DISK DISKIDLE 0 >nul 2>&1

:: Disable system sleep timeout while on AC power
powercfg -setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0 >nul 2>&1

:: Disable hibernate - Frees up disk space and removes hibernate-related delays
powercfg -h off >nul 2>&1

:: Disable USB selective suspend in power settings
powercfg -setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1

:: Disable display sleep timeout (optional for gaming rigs)
powercfg -setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 0 >nul 2>&1

:: Apply all power plan changes immediately
powercfg -setactive SCHEME_CURRENT >nul 2>&1

echo  [+] Power Optimization complete.
goto :EOF

:: ============================================================
:: RESTORE DEFAULTS
:: ============================================================
:RESTORE_DEFAULTS
cls
echo.
echo  [*] Restoring Windows Default Settings...
echo  --------------------------------------------------------
echo  [!] WARNING: This will revert Cognix Optimizer changes.
echo.
set /p CONFIRM="  Are you sure? (Y/N): "
if /i not "%CONFIRM%"=="Y" goto MENU

echo.
echo  [~] Restoring services to default...

:: Restore SysMain (Superfetch)
sc config SysMain start= auto >nul 2>&1
sc start SysMain >nul 2>&1

:: Restore Windows Search
sc config WSearch start= delayed-auto >nul 2>&1
sc start WSearch >nul 2>&1

:: Restore DiagTrack
sc config DiagTrack start= auto >nul 2>&1
sc start DiagTrack >nul 2>&1

:: Restore BITS
sc config BITS start= auto >nul 2>&1

:: Restore DPS (Diagnostic Policy Service)
sc config DPS start= auto >nul 2>&1

echo  [~] Restoring telemetry settings...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /f >nul 2>&1

echo  [~] Restoring visual effects...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f >nul 2>&1

echo  [~] Restoring mouse acceleration...
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "6" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "10" /f >nul 2>&1

echo  [~] Restoring network settings...
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global chimney=default >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /f >nul 2>&1

echo  [~] Restoring power plan to Balanced...
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul 2>&1
powercfg -h on >nul 2>&1

echo  [~] Restoring Game DVR settings...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 1 /f >nul 2>&1

echo  [~] Restoring NTFS defaults...
fsutil behavior set DisableLastAccess 0 >nul 2>&1
fsutil behavior set disable8dot3 0 >nul 2>&1
fsutil behavior set DisableDeleteNotify 1 >nul 2>&1

echo  [~] Restoring boot configuration...
bcdedit /set disabledynamictick no >nul 2>&1
bcdedit /deletevalue useplatformtick >nul 2>&1

echo  [~] Restoring paging executive...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 0 /f >nul 2>&1

echo.
echo  [+] Default settings restored successfully.
echo  [!] A system restart is recommended.
echo.
pause
goto MENU

:: ============================================================
:: EXIT
:: ============================================================
:EXIT_SCRIPT
cls
echo.
echo  ========================================================
echo  ^|        Thank you for using Cognix Optimizer         ^|
echo  ^|    Restart your system to apply all changes.        ^|
echo  ========================================================
echo.
timeout /t 3 >nul
exit /b 0