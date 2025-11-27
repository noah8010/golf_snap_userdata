# GitHub Pages 배포 가이드

## 📋 사전 준비사항

### 1. GitHub 계정 및 저장소
- [ ] GitHub 계정 생성 (없는 경우)
- [ ] 새 저장소 생성 (예: `golf-stats-app`)
- [ ] 저장소를 Public으로 설정 (GitHub Pages 무료 사용)

### 2. Git 설치 확인
```bash
git --version
```
설치되지 않았다면: https://git-scm.com/download/win

### 3. 프로젝트 정리
- [ ] `.gitignore` 파일 확인
- [ ] 민감한 정보 제거 (API 키 등)
- [ ] 불필요한 파일 제거

## 🚀 배포 단계

### Step 1: Git 초기화 및 커밋

```bash
# 프로젝트 폴더로 이동
cd e:\flutter_projects\user_data\golf_stats_app

# Git 초기화 (처음인 경우)
git init

# 사용자 정보 설정 (처음인 경우)
git config user.name "Your Name"
git config user.email "your.email@example.com"

# 모든 파일 추가
git add .

# 첫 커밋
git commit -m "Initial commit: Golf Stats App with Driver Analysis"
```

### Step 2: GitHub 저장소 연결

```bash
# GitHub에서 생성한 저장소 URL로 변경
git remote add origin https://github.com/YOUR_USERNAME/golf-stats-app.git

# 메인 브랜치로 변경 (필요시)
git branch -M main

# 푸시
git push -u origin main
```

### Step 3: 웹 빌드 생성

```bash
# 웹용 릴리즈 빌드 생성
flutter build web --release --base-href /golf-stats-app/
```

> **중요**: `--base-href`는 GitHub Pages URL 구조에 맞춰야 합니다.
> - 형식: `/저장소이름/`
> - 예: `/golf-stats-app/`

### Step 4: gh-pages 브랜치 생성 및 배포

#### 방법 1: 수동 배포
```bash
# gh-pages 브랜치 생성
git checkout --orphan gh-pages

# 기존 파일 모두 제거
git rm -rf .

# build/web 내용을 현재 디렉토리로 복사
xcopy /E /I build\web\* .

# .gitignore 임시 제거 (필요시)
del .gitignore

# 커밋 및 푸시
git add .
git commit -m "Deploy to GitHub Pages"
git push origin gh-pages

# 다시 main 브랜치로 돌아가기
git checkout main
```

#### 방법 2: 자동화 스크립트 사용
이미 생성된 `build_for_github.bat` 파일을 실행:
```bash
.\build_for_github.bat
```

### Step 5: GitHub Pages 활성화

1. GitHub 저장소 페이지 접속
2. **Settings** 탭 클릭
3. 왼쪽 메뉴에서 **Pages** 클릭
4. **Source** 섹션에서:
   - Branch: `gh-pages` 선택
   - Folder: `/ (root)` 선택
5. **Save** 클릭

### Step 6: 배포 확인

약 1-2분 후 다음 URL에서 확인:
```
https://YOUR_USERNAME.github.io/golf-stats-app/
```

## 🔧 문제 해결

### 빌드 오류 발생 시
```bash
# 캐시 정리
flutter clean

# 패키지 재설치
flutter pub get

# 다시 빌드
flutter build web --release --base-href /golf-stats-app/
```

### 페이지가 로드되지 않을 때
1. `--base-href` 값이 저장소 이름과 일치하는지 확인
2. GitHub Pages 설정에서 브랜치가 `gh-pages`인지 확인
3. 브라우저 캐시 삭제 후 재시도

### 데이터 파일이 로드되지 않을 때
`pubspec.yaml`의 assets 경로 확인:
```yaml
flutter:
  assets:
    - assets/data/
```

## 📝 추가 팁

### 업데이트 배포
코드 수정 후 재배포:
```bash
# main 브랜치에서 커밋
git add .
git commit -m "Update: 변경 내용 설명"
git push origin main

# 웹 빌드
flutter build web --release --base-href /golf-stats-app/

# gh-pages 브랜치로 전환 및 배포
git checkout gh-pages
xcopy /E /I /Y build\web\* .
git add .
git commit -m "Deploy updates"
git push origin gh-pages
git checkout main
```

### 자동 배포 (GitHub Actions)
더 편리한 자동 배포를 원하시면 GitHub Actions 워크플로우를 설정할 수 있습니다.

## ✅ 체크리스트

배포 전 확인사항:
- [ ] Git 설치 및 설정 완료
- [ ] GitHub 저장소 생성
- [ ] 프로젝트 커밋 및 푸시
- [ ] 웹 빌드 성공
- [ ] gh-pages 브랜치 생성 및 배포
- [ ] GitHub Pages 설정 완료
- [ ] 배포된 URL에서 정상 작동 확인

## 🎯 예상 결과

배포 성공 시:
- URL: `https://YOUR_USERNAME.github.io/golf-stats-app/`
- 대시보드 정상 표시
- 스코어 분석, 퍼팅 분석, 드라이버 분석 모두 작동
- 데이터 정상 로딩
