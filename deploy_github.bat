@echo off
echo ========================================
echo GitHub Pages 배포 스크립트
echo ========================================
echo.

REM Flutter 경로 설정
set "PATH=C:\src\flutter\flutter\bin;%PATH%"

REM 1. 웹 빌드
echo [1/4] 웹 빌드 생성 중...
flutter build web --release --base-href /golf-stats-app/
if %ERRORLEVEL% NEQ 0 (
    echo 빌드 실패!
    pause
    exit /b 1
)
echo 빌드 완료!
echo.

REM 2. gh-pages 브랜치 확인/생성
echo [2/4] gh-pages 브랜치 준비 중...
git show-ref --verify --quiet refs/heads/gh-pages
if %ERRORLEVEL% EQU 0 (
    echo gh-pages 브랜치가 이미 존재합니다.
    git checkout gh-pages
) else (
    echo gh-pages 브랜치를 새로 생성합니다.
    git checkout --orphan gh-pages
    git rm -rf .
)
echo.

REM 3. 빌드 파일 복사
echo [3/4] 빌드 파일 복사 중...
xcopy /E /I /Y build\web\* .
echo 복사 완료!
echo.

REM 4. 커밋 및 푸시
echo [4/4] GitHub에 배포 중...
git add .
git commit -m "Deploy to GitHub Pages"
git push origin gh-pages
echo.

REM main 브랜치로 복귀
git checkout main

echo ========================================
echo 배포 완료!
echo ========================================
echo.
echo 약 1-2분 후 다음 URL에서 확인하세요:
echo https://YOUR_USERNAME.github.io/golf-stats-app/
echo.
echo GitHub Pages 설정:
echo 1. GitHub 저장소 페이지 방문
echo 2. Settings - Pages
echo 3. Branch: gh-pages 선택
echo 4. Save 클릭
echo.
pause
