@echo off
set "PATH=C:\src\flutter\flutter\bin;%PATH%"
echo Building web app...
flutter build web --release

echo.
echo Build complete! Starting local server...
echo.
echo Access from this PC: http://localhost:8000
echo Access from other PCs: http://YOUR_LOCAL_IP:8000
echo (Replace YOUR_LOCAL_IP with your actual IP address)
echo.
echo To find your IP address, run: ipconfig
echo Look for "IPv4 Address" under your active network adapter
echo.

cd build\web
python -m http.server 8000
