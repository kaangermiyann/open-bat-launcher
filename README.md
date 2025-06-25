# Open.bat – Smart Google & Website Command Line Launcher

![Open.bat badge](https://img.shields.io/badge/BATCH-WINDOWS-blue?style=flat-square)

A powerful and practical Windows batch script that lets you quickly open websites or perform various types of Google searches right from the command line. Perfect for both everyday users and professionals who want fast, keyboard-driven browsing.

---

## Features

- **Direct website opening:**  
  `open besiktas.com.tr` → opens https://besiktas.com.tr

- **Google search types:**  
  - Image search: `open besiktas -g`
  - News search: `open besiktas -h`
  - Video search: `open besiktas videos -v`
  - Shopping search: `open besiktas jersey -s`
  - Books search: `open besiktas history -b`
  - Maps search: `open vodafone park -m`

- **Incognito mode:**  
  Use `-i` to open in Chrome's incognito mode in any search or website (`open besiktas -g -i`).

- **Smart detection:**  
  If the keyword contains a dot (e.g., ".com", ".org"), it opens the site directly; otherwise, it performs a Google search.

- **Help screen:**  
  Use `open -help` to see all available commands and usage examples.

---

## Installation

1. Download the **open.bat** script from [here](./open.bat).
2. Place the file in a folder (e.g., `C:\Scripts`).
3. Add that folder to your **Path** environment variable:  
   - Control Panel > System > Advanced System Settings > Environment Variables
4. You can now type `open` from any command prompt window.

---

## Usage

### Basic Examples

```sh
open besiktas.com.tr
open wikipedia.org -i
open vodafone park -m
open besiktas -g
open besiktas news -h -i
open besiktas videos -v
open besiktas history -b
open besiktas jersey -s
open -help
```

### Parameters

| Parameter | Description |
|-----------|-------------|
| -i        | Opens in incognito mode (Chrome) |
| -g        | Google Images search             |
| -h        | Google News search               |
| -v        | Google Videos search             |
| -s        | Google Shopping search           |
| -b        | Google Books search              |
| -m        | Google Maps search               |

- Parameters can be combined.
- Order does not matter (`open besiktas -g -i` or `open besiktas -i -g` both work).

---

## Script

```bat name=open.bat
@echo off
setlocal enabledelayedexpansion

:: Show help if requested
for %%a in (%*) do (
    if /I "%%a"=="-help" goto showhelp
)

if "%~1"=="" (
    echo Usage: open [keyword or site] [search_type] [-i]
    echo For details: open -help
    exit /b
)

set "incognito="
set "tbm="
set "maps="
set "mode=normal"
set "sitecheck=1"

:: Parse parameters
set "query=%*"
for %%a in (%*) do (
    if /I "%%a"=="-i" set "incognito=1"
    if /I "%%a"=="-g" set "tbm=isch" & set "mode=img" & set "sitecheck=0"
    if /I "%%a"=="-h" set "tbm=nws" & set "mode=news" & set "sitecheck=0"
    if /I "%%a"=="-v" set "tbm=vid" & set "mode=vid" & set "sitecheck=0"
    if /I "%%a"=="-s" set "tbm=shop" & set "mode=shop" & set "sitecheck=0"
    if /I "%%a"=="-b" set "tbm=bks" & set "mode=book" & set "sitecheck=0"
    if /I "%%a"=="-m" set "maps=1" & set "mode=maps" & set "sitecheck=0"
)

:: Remove parameters from query
set "query=%query: -i=%"
set "query=%query: -g=%"
set "query=%query: -h=%"
set "query=%query: -v=%"
set "query=%query: -s=%"
set "query=%query: -b=%"
set "query=%query: -m=%"
set "query=%query: -help=%"

:: Google Maps
if defined maps (
    set "link=https://www.google.com/maps/search/%query%"
    goto launch
)

:: Other Google search types
if defined tbm (
    set "link=https://www.google.com/search?tbm=%tbm%&q=%query%"
    goto launch
)

:: Dot detection: open as site if it contains a dot, else Google search
echo %query% | findstr "\." >nul
if errorlevel 1 (
    set "link=https://www.google.com/search?q=%query%"
    goto launch
)

:: Direct site open
echo %query% | findstr /I "https://" >nul
if errorlevel 1 (
    set "site=https://%query%"
) else (
    set "site=%query%"
)
set "link=%site%"

:launch
if defined incognito (
    start "" "chrome.exe" --incognito "%link%"
    exit /b
) else (
    start "" "%link%"
    exit /b
)

:showhelp
echo.
echo open.bat - Smart Google and Website CLI Launcher
echo.
echo Usage: open [keyword or site] [search_type] [-i]
echo.
echo Search Type Flags:
echo   -g    Search on Google Images
echo   -h    Search on Google News
echo   -v    Search on Google Videos
echo   -s    Search on Google Shopping
echo   -b    Search on Google Books
echo   -m    Search on Google Maps
echo.
echo Incognito:
echo   -i    Opens in Chrome's incognito mode (works with all search types)
echo.
echo Examples:
echo   open besiktas.com.tr              opens besiktas.com.tr
echo   open besiktas.com.tr -i           opens besiktas.com.tr in incognito
echo   open besiktas -g                  Google Images search
echo   open besiktas -g -i               Google Images search in incognito
echo   open vodafone park -m             Google Maps search
echo   open besiktas -h                  Google News search
echo   open besiktas history -b -i       Google Books search in incognito
echo   open besiktas videos -v           Google Videos search
echo   open -help                        Show this help
echo.
exit /b
```

---

## Contributing

Feel free to open an Issue or Pull Request for suggestions or improvements!

## License

MIT License

---

**Enjoy fast browsing and productivity!**
