# GitHub Desktop 배포 가이드

## 🎯 목표
GitHub에 코드를 올리고 GitHub Pages로 웹 배포하여 다른 PC에서도 접근 가능하게 만들기

## 📋 단계별 가이드

### Step 1: GitHub Desktop으로 저장소 생성

1. **GitHub Desktop 실행**

2. **로컬 저장소 추가**
   - `File` → `Add local repository`
   - 폴더 선택: `e:\flutter_projects\user_data\golf_stats_app`
   - "This directory does not appear to be a Git repository" 메시지가 나오면
   - `create a repository` 클릭

3. **저장소 정보 입력**
   - Name: `golf_stats_app` (자동 입력됨)
   - Description: "Golf statistics analysis app with Flutter"
   - `Create repository` 클릭

4. **첫 커밋**
   - 왼쪽에 모든 변경 파일이 표시됨
   - Summary 입력: `Initial commit: Golf Stats App with Driver Analysis`
   - Description (선택): `Features: Score analysis, Putting analysis, Driver statistics`
   - `Commit to main` 버튼 클릭

5. **GitHub에 발행**
   - 상단 `Publish repository` 버튼 클릭
   - Repository name: `golf-stats-app` (원하는 이름으로 변경 가능)
   - Description: "Golf statistics analysis web app"
   - **⚠️ "Keep this code private" 체크 해제** (Public으로 설정)
   - `Publish repository` 클릭

### Step 2: 웹 빌드 및 배포

1. **자동 배포 스크립트 실행**
   ```
   .\deploy_github.bat
   ```
   
   이 스크립트는 자동으로:
   - 웹 빌드 생성
   - gh-pages 브랜치 생성/전환
   - 빌드 파일 복사
   - GitHub에 푸시

2. **저장소 이름 확인**
   - 스크립트 실행 전에 `deploy_github.bat` 파일을 열어
   - `--base-href /golf-stats-app/` 부분을 실제 저장소 이름으로 변경
   - 예: 저장소 이름이 `my-golf-app`이면 `--base-href /my-golf-app/`

### Step 3: GitHub Pages 활성화

1. **GitHub 웹사이트 접속**
   - https://github.com/YOUR_USERNAME/golf-stats-app

2. **Settings 탭 클릭**

3. **왼쪽 메뉴에서 Pages 클릭**

4. **Source 설정**
   - Branch: `gh-pages` 선택
   - Folder: `/ (root)` 선택
   - `Save` 클릭

5. **배포 완료 대기**
   - 약 1-2분 소요
   - 페이지 상단에 배포 URL이 표시됨
   - 예: `https://YOUR_USERNAME.github.io/golf-stats-app/`

### Step 4: 접속 확인

배포된 URL로 접속하여 확인:
- 대시보드 정상 표시
- 스코어 분석, 퍼팅 분석, 드라이버 분석 모두 작동
- 다른 PC의 브라우저에서도 동일하게 접속 가능

## 🔄 업데이트 배포 방법

코드 수정 후 재배포:

1. **GitHub Desktop에서 변경사항 확인**
   - 수정된 파일들이 자동으로 표시됨

2. **커밋**
   - Summary 입력: 예) "Add driver statistics feature"
   - `Commit to main` 클릭

3. **푸시**
   - 상단 `Push origin` 버튼 클릭

4. **재배포**
   - `.\deploy_github.bat` 다시 실행

## ⚠️ 주의사항

### base-href 설정
`deploy_github.bat` 파일에서 저장소 이름과 일치해야 함:
```bash
flutter build web --release --base-href /실제저장소이름/
```

### Public 저장소
GitHub Pages 무료 사용을 위해 저장소를 Public으로 설정해야 함

### 데이터 파일
`assets/data/` 폴더의 JSON 파일들이 포함되어 있는지 확인

## 🎉 완료!

성공적으로 배포되면:
- ✅ GitHub에 코드 백업
- ✅ 웹 URL로 어디서나 접속 가능
- ✅ 다른 PC에서도 테스트 가능
- ✅ 모바일에서도 접속 가능

## 📞 문제 해결

### 페이지가 비어있을 때
- `--base-href` 값 확인
- GitHub Pages 설정에서 브랜치 확인

### 데이터가 로드되지 않을 때
- 브라우저 개발자 도구(F12) → Console 탭에서 에러 확인
- Network 탭에서 파일 로딩 상태 확인

### 빌드 실패 시
```bash
flutter clean
flutter pub get
flutter build web --release --base-href /저장소이름/
```
