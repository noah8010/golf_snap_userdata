@echo off
set "PATH=C:\src\flutter\flutter\bin;%PATH%"
echo Building web app for GitHub Pages...
flutter build web --release --base-href /golf_stats_app/

echo.
echo Build complete!
echo.
echo Next steps to deploy to GitHub Pages:
echo 1. Create a GitHub repository named 'golf_stats_app'
echo 2. Push your code to GitHub
echo 3. Copy the contents of 'build\web' to a 'gh-pages' branch
echo 4. Enable GitHub Pages in repository settings
echo.
echo Or use this automated deployment:
echo   git checkout -b gh-pages
echo   git rm -rf .
echo   xcopy /E /I build\web\* .
echo   git add .
echo   git commit -m "Deploy to GitHub Pages"
echo   git push origin gh-pages
echo.
pause
