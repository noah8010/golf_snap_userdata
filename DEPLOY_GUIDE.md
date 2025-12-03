# Golf Stats App 배포 가이드

## 📋 배포 전 확인사항

### 1. 현재 브랜치 확인
```bash
git branch --show-current
```
- **main 브랜치**에 있어야 합니다.

### 2. 변경사항 커밋 확인
```bash
git status
```
- 모든 변경사항이 커밋되어 있어야 합니다.

### 3. Flutter 환경 확인
```bash
flutter doctor
flutter --version
```

---

## 🚀 배포 방법

### 방법 1: 배포 스크립트 사용 (권장)

#### Windows (PowerShell)
```powershell
.\deploy.ps1
```

#### Windows (CMD)
```cmd
.\deploy.bat
```

### 방법 2: 수동 배포

#### 1단계: 웹 빌드
```bash
flutter build web --release --base-href /golf_snap_userdata/
```

#### 2단계: gh-pages 브랜치로 전환
```bash
git checkout gh-pages
```
- gh-pages 브랜치가 없으면 생성:
```bash
git checkout -b gh-pages
```

#### 3단계: 빌드된 파일 복사
```bash
# Windows (PowerShell)
Get-ChildItem -Path . -Exclude .git | Remove-Item -Recurse -Force
Copy-Item -Path "build\web\*" -Destination . -Recurse -Force

# Windows (CMD)
xcopy /E /I /Y build\web\* .
```

#### 4단계: 변경사항 커밋
```bash
git add .
git commit -m "Deploy: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
```

#### 5단계: 푸시
```bash
git push origin gh-pages
```

#### 6단계: main 브랜치로 복귀
```bash
git checkout main
```

---

## ✅ 배포 확인

1. GitHub 저장소 → **Settings** → **Pages** 확인
   - Source: `gh-pages` 브랜치 선택되어 있는지 확인

2. 배포 URL 접속 (약 1-2분 후)
   - https://noah8010.github.io/golf_snap_userdata/

3. 브라우저 캐시 클리어 (필요시)
   - Ctrl + Shift + R (강력 새로고침)

---

## 🐛 문제 해결

### 빌드 실패
- `flutter clean` 실행 후 다시 빌드
- `flutter pub get` 실행

### 푸시 실패
- Git 인증 확인
- 원격 저장소 설정 확인: `git remote -v`

### 배포 후 변경사항이 반영되지 않음
- GitHub Pages 빌드 시간 대기 (1-2분)
- 브라우저 캐시 클리어
- gh-pages 브랜치에 파일이 제대로 있는지 확인

---

## 📝 배포 체크리스트

- [ ] main 브랜치에 있음
- [ ] 모든 변경사항 커밋됨
- [ ] Flutter 빌드 성공
- [ ] gh-pages 브랜치에 파일 복사됨
- [ ] 커밋 및 푸시 완료
- [ ] main 브랜치로 복귀 완료
- [ ] 배포 URL에서 확인 완료

---

**마지막 업데이트**: 2025-01-XX

