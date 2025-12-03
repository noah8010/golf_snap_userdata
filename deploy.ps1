# Golf Stats App - GitHub Pages 배포 스크립트 (PowerShell)
# 사용법: .\deploy.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Golf Stats App - GitHub Pages 배포" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 현재 브랜치 확인
$currentBranch = git branch --show-current
Write-Host "현재 브랜치: $currentBranch" -ForegroundColor Yellow
Write-Host ""

# main 브랜치가 아니면 경고
if ($currentBranch -ne "main") {
    Write-Host "[경고] main 브랜치가 아닙니다. 현재 브랜치: $currentBranch" -ForegroundColor Yellow
    Write-Host "[경고] 계속 진행합니다..." -ForegroundColor Yellow
}

Write-Host "[1/5] Flutter 웹 빌드 실행 중..." -ForegroundColor Green
Write-Host ""
& flutter build web --release --base-href /golf_snap_userdata/

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[오류] 빌드 실패! 배포를 중단합니다." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[2/5] gh-pages 브랜치로 전환 중..." -ForegroundColor Green
Write-Host ""
$checkoutResult = & git checkout gh-pages 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "gh-pages 브랜치가 없습니다. 생성합니다..." -ForegroundColor Yellow
    & git checkout -b gh-pages
}

Write-Host ""
Write-Host "[3/5] 빌드된 파일 복사 중..." -ForegroundColor Green
Write-Host ""

# 기존 파일 삭제 (.git 제외)
Get-ChildItem -Path . -Exclude .git | Remove-Item -Recurse -Force

# build/web의 모든 파일 복사
Copy-Item -Path "build\web\*" -Destination . -Recurse -Force

Write-Host ""
Write-Host "[4/5] 변경사항 커밋 중..." -ForegroundColor Green
Write-Host ""
& git add .
$commitMessage = "Deploy: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
& git commit -m $commitMessage

if ($LASTEXITCODE -eq 0) {
    Write-Host "[성공] 커밋 완료!" -ForegroundColor Green
} else {
    Write-Host "[정보] 커밋할 변경사항이 없습니다." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[5/5] gh-pages 브랜치에 푸시 중..." -ForegroundColor Green
Write-Host ""
& git push origin gh-pages

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[오류] 푸시 실패! 수동으로 푸시해주세요." -ForegroundColor Red
    Write-Host ""
    Write-Host "main 브랜치로 돌아가는 중..." -ForegroundColor Yellow
    & git checkout main
    exit 1
}

Write-Host ""
Write-Host "[완료] main 브랜치로 돌아가는 중..." -ForegroundColor Green
Write-Host ""
& git checkout main

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "배포 완료!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "GitHub Pages가 업데이트되는데 몇 분 정도 걸릴 수 있습니다." -ForegroundColor Yellow
Write-Host "URL: https://noah8010.github.io/golf_snap_userdata/" -ForegroundColor Cyan
Write-Host ""

