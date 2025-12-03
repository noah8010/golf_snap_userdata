# 배포 상태 확인 스크립트
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "배포 상태 확인" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 현재 브랜치 확인
Write-Host "[1] 현재 브랜치:" -ForegroundColor Yellow
$currentBranch = git branch --show-current
Write-Host "   $currentBranch" -ForegroundColor White
Write-Host ""

# 2. 빌드 디렉토리 확인
Write-Host "[2] 빌드 파일 확인:" -ForegroundColor Yellow
if (Test-Path "build\web\index.html") {
    Write-Host "   ✅ 빌드 파일 존재: build\web\index.html" -ForegroundColor Green
    $buildSize = (Get-ChildItem "build\web" -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
    Write-Host "   빌드 크기: $([math]::Round($buildSize, 2)) MB" -ForegroundColor White
} else {
    Write-Host "   ❌ 빌드 파일 없음" -ForegroundColor Red
}
Write-Host ""

# 3. Git 원격 저장소 확인
Write-Host "[3] Git 원격 저장소:" -ForegroundColor Yellow
$remote = git remote -v
if ($remote) {
    Write-Host "   $remote" -ForegroundColor White
} else {
    Write-Host "   ❌ 원격 저장소 없음" -ForegroundColor Red
}
Write-Host ""

# 4. gh-pages 브랜치 확인
Write-Host "[4] gh-pages 브랜치 확인:" -ForegroundColor Yellow
$branches = git branch -a
if ($branches -match "gh-pages") {
    Write-Host "   ✅ gh-pages 브랜치 존재" -ForegroundColor Green
    
    # gh-pages 브랜치로 전환하여 파일 확인
    $originalBranch = git branch --show-current
    git checkout gh-pages 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        $files = Get-ChildItem -File | Select-Object -First 5
        if ($files.Count -gt 0) {
            Write-Host "   gh-pages 브랜치 파일:" -ForegroundColor White
            $files | ForEach-Object { Write-Host "   - $($_.Name)" -ForegroundColor White }
            
            if (Test-Path "index.html") {
                Write-Host "   ✅ index.html 존재" -ForegroundColor Green
            } else {
                Write-Host "   ❌ index.html 없음" -ForegroundColor Red
            }
        } else {
            Write-Host "   ❌ gh-pages 브랜치에 파일 없음" -ForegroundColor Red
        }
        
        # 원래 브랜치로 복귀
        git checkout $originalBranch 2>&1 | Out-Null
    }
} else {
    Write-Host "   ❌ gh-pages 브랜치 없음" -ForegroundColor Red
}
Write-Host ""

# 5. 최근 커밋 확인
Write-Host "[5] 최근 커밋:" -ForegroundColor Yellow
$commits = git log --oneline -3
if ($commits) {
    $commits | ForEach-Object { Write-Host "   $_" -ForegroundColor White }
} else {
    Write-Host "   커밋 없음" -ForegroundColor Yellow
}
Write-Host ""

# 6. 배포 URL 확인
Write-Host "[6] 배포 URL:" -ForegroundColor Yellow
Write-Host "   https://noah8010.github.io/golf_snap_userdata/" -ForegroundColor Cyan
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "확인 완료" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

