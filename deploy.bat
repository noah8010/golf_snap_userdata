@echo off
echo ========================================
echo Golf Stats App - GitHub Pages 배포
echo ========================================
echo.

REM 현재 브랜치 확인
git branch --show-current > temp_branch.txt
set /p CURRENT_BRANCH=<temp_branch.txt
del temp_branch.txt

echo 현재 브랜치: %CURRENT_BRANCH%
echo.

REM main 브랜치가 아니면 경고
if not "%CURRENT_BRANCH%"=="main" (
    echo [경고] main 브랜치가 아닙니다. 계속하시겠습니까? (Y/N)
    set /p CONTINUE=
    if /i not "%CONTINUE%"=="Y" (
        echo 배포를 취소했습니다.
        exit /b 1
    )
)

echo.
echo [1/5] Flutter 웹 빌드 실행 중...
echo.
flutter build web --release --base-href /golf_snap_userdata/

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [오류] 빌드 실패! 배포를 중단합니다.
    exit /b 1
)

echo.
echo [2/5] gh-pages 브랜치로 전환 중...
echo.
git checkout gh-pages 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo gh-pages 브랜치가 없습니다. 생성합니다...
    git checkout -b gh-pages
)

echo.
echo [3/5] 빌드된 파일 복사 중...
echo.
REM 기존 파일 삭제 (숨김 파일 제외)
for /f "delims=" %%i in ('dir /b /a-d') do (
    if not "%%i"==".git" del /q "%%i" 2>nul
)
for /d /r %%i in (*) do (
    if not "%%i"==".git" rd /s /q "%%i" 2>nul
)

REM build/web의 모든 파일 복사
xcopy /E /I /Y /Q build\web\* . >nul 2>&1

echo.
echo [4/5] 변경사항 커밋 중...
echo.
git add .
git commit -m "Deploy: %date% %time%"

if %ERRORLEVEL% NEQ 0 (
    echo [정보] 커밋할 변경사항이 없습니다.
) else (
    echo [성공] 커밋 완료!
)

echo.
echo [5/5] gh-pages 브랜치에 푸시 중...
echo.
git push origin gh-pages

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [오류] 푸시 실패! 수동으로 푸시해주세요.
    echo.
    echo main 브랜치로 돌아가는 중...
    git checkout main
    exit /b 1
)

echo.
echo [완료] main 브랜치로 돌아가는 중...
echo.
git checkout main

echo.
echo ========================================
echo 배포 완료!
echo ========================================
echo.
echo GitHub Pages가 업데이트되는데 몇 분 정도 걸릴 수 있습니다.
echo URL: https://noah8010.github.io/golf_snap_userdata/
echo.
pause

