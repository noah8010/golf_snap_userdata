# Golf Stats App - GitHub Pages 배포 스크립트
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Golf Stats App 배포 시작" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 현재 브랜치 확인
$currentBranch = git branch --show-current
Write-Host "현재 브랜치: $currentBranch" -ForegroundColor Yellow

# main 브랜치로 이동
if ($currentBranch -ne "main") {
    Write-Host "main 브랜치로 전환 중..." -ForegroundColor Yellow
    git checkout main
}

Write-Host ""
Write-Host "[1/6] Flutter 웹 빌드 실행 중..." -ForegroundColor Green
flutter build web --release --base-href /golf_snap_userdata/

if ($LASTEXITCODE -ne 0) {
    Write-Host "[오류] 빌드 실패!" -ForegroundColor Red
    exit 1
}
Write-Host "[완료] 빌드 성공" -ForegroundColor Green

Write-Host ""
Write-Host "[2/6] gh-pages 브랜치로 전환 중..." -ForegroundColor Green
$checkout = git checkout gh-pages 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "gh-pages 브랜치 생성 중..." -ForegroundColor Yellow
    git checkout -b gh-pages
}
Write-Host "[완료] gh-pages 브랜치로 전환됨" -ForegroundColor Green

Write-Host ""
Write-Host "[3/6] 기존 파일 삭제 중..." -ForegroundColor Green
Get-ChildItem -Path . -Exclude .git | Remove-Item -Recurse -Force
Write-Host "[완료] 기존 파일 삭제됨" -ForegroundColor Green

Write-Host ""
Write-Host "[4/6] 빌드된 파일 복사 중..." -ForegroundColor Green
Copy-Item -Path "build\web\*" -Destination . -Recurse -Force
Write-Host "[완료] 파일 복사됨" -ForegroundColor Green

Write-Host ""
Write-Host "[5/6] 변경사항 커밋 중..." -ForegroundColor Green
git add -A
$commitMsg = "Deploy: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git commit -m $commitMsg
if ($LASTEXITCODE -eq 0) {
    Write-Host "[완료] 커밋 성공: $commitMsg" -ForegroundColor Green
} else {
    Write-Host "[정보] 커밋할 변경사항 없음" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[6/6] 원격 저장소에 푸시 중..." -ForegroundColor Green
git push origin gh-pages
if ($LASTEXITCODE -eq 0) {
    Write-Host "[완료] 푸시 성공!" -ForegroundColor Green
} else {
    Write-Host "[오류] 푸시 실패!" -ForegroundColor Red
    Write-Host "main 브랜치로 복귀 중..." -ForegroundColor Yellow
    git checkout main
    exit 1
}

Write-Host ""
Write-Host "main 브랜치로 복귀 중..." -ForegroundColor Yellow
git checkout main

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "배포 완료!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "배포 URL: https://noah8010.github.io/golf_snap_userdata/" -ForegroundColor Cyan
Write-Host "GitHub에서 1-2분 후 업데이트 확인 가능" -ForegroundColor Yellow
Write-Host ""

