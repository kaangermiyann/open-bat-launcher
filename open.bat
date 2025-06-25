@echo off
setlocal enabledelayedexpansion

:: Yardım ekranı
for %%a in (%*) do (
    if /I "%%a"=="-help" goto showhelp
)

if "%~1"=="" (
    echo Arama yapmak icin: open [kelime veya adres] [arama_turu] [-i]
    echo Detayli bilgi icin: open -help
    exit /b
)

set "incognito="
set "tbm="
set "maps="
set "mode=normal"
set "sitecheck=1"

:: Parametreleri tara
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

:: Parametreleri query'den çıkar
set "query=%query: -i=%"
set "query=%query: -g=%"
set "query=%query: -h=%"
set "query=%query: -v=%"
set "query=%query: -s=%"
set "query=%query: -b=%"
set "query=%query: -m=%"
set "query=%query: -help=%"

:: Google Maps ise
if defined maps (
    set "link=https://www.google.com/maps/search/%query%"
    goto launch
)

:: Diğer Google arama türleri
if defined tbm (
    set "link=https://www.google.com/search?tbm=%tbm%&q=%query%"
    goto launch
)

:: Nokta içeriyor mu kontrolü (site ise doğrudan git, değilse arama yap)
echo %query% | findstr "\." >nul
if errorlevel 1 (
    set "link=https://www.google.com/search?q=%query%"
    goto launch
)

:: Siteye doğrudan git
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
echo open.bat - Akilli Google ve Site Komut Satiri Yardimcisi
echo.
echo Kullanim: open [arama veya site] [arama_turu] [-i]
echo.
echo Arama Turu Anahtarlari:
echo   -g    Google Gorseller'de arar
echo   -h    Google Haberler'de arar
echo   -v    Google Videolar'da arar
echo   -s    Google Alisveris'te arar
echo   -b    Google Kitaplar'da arar
echo   -m    Google Haritalar'da arar
echo.
echo Gizli Sekme:
echo   -i    Chrome'da gizli sekmede acar (her arama turunde kullanabilirsin)
echo.
echo Ornekler:
echo   open youtube           youtube.com'u acar
echo   open youtube -i        youtube.com'u gizli sekmede acar
echo   open beşiktaş -g    Google Gorseller'de arar
echo   open beşiktaş -g -i Google Gorseller'de gizli sekmede arar
echo   open istanbul -m       Google Haritalar'da arar
echo   open ataturk -h        Google Haberler'de arar
echo   open kitap -b -i       Google Kitaplar'da gizli sekmede arar
echo   open futbol -v         Google Videolar'da arar
echo   open -help             Bu yardimi gosterir
echo.
exit /b