# 간단한 배포 상태 확인
$result = @()

# 현재 브랜치
try {
    $branch = git branch --show-current 2>&1
    $result += "현재 브랜치: $branch"
} catch {
    $result += "현재 브랜치: 확인 실패"
}

# 빌드 파일
if (Test-Path "build\web\index.html") {
    $result += "빌드 파일: 존재"
} else {
    $result += "빌드 파일: 없음"
}

# 원격 저장소
try {
    $remote = git remote -v 2>&1 | Out-String
    $result += "원격 저장소: $remote"
} catch {
    $result += "원격 저장소: 확인 실패"
}

# gh-pages 브랜치
try {
    $branches = git branch -a 2>&1 | Out-String
    if ($branches -match "gh-pages") {
        $result += "gh-pages 브랜치: 존재"
    } else {
        $result += "gh-pages 브랜치: 없음"
    }
} catch {
    $result += "gh-pages 브랜치: 확인 실패"
}

# 결과 출력
$result | Out-File -FilePath "deploy_check_result.txt" -Encoding UTF8
$result

