# Golf Stats App ⛳

골프 라운드 데이터를 분석하여 스코어, 퍼팅, 드라이버 통계를 제공하는 Flutter 웹 애플리케이션입니다.

## 🌐 라이브 데모

**배포 URL**: https://noah8010.github.io/golf_snap_userdata/

## ✨ 주요 기능

### 1. 스코어 분석
- 📊 평균 스코어, 베스트/워스트 스코어
- 📈 스코어 추세 그래프
- 🎯 Par별 평균 스코어
- 📉 스코어 분포 (버디, 파, 보기 등)
- 🏌️ 페어웨이 적중률, GIR 통계

### 2. 퍼팅 분석
- 📏 거리별 퍼팅 성공률 (0-1m, 1-3m, 3-5m, 5-10m, 10m+)
- 🎯 첫 퍼팅 성공률
- ⚠️ 3퍼트 발생률
- 📊 퍼팅 통계 차트

### 3. 드라이버 분석 (신규 기능)
- 🚀 **비거리 분석**: 평균/최장 비거리, 캐리, 런, 일관성
- 🎯 **정확도 분석**: 페어웨이 적중률, 좌우 편차
- ⚠️ **페널티 분석**: OB/해저드 발생률
- 🌀 **구질 분석**: 드로우/페이드/스트레이트 분포 및 평균 비거리
- ⚡ **스윙 효율성**: 볼/클럽 스피드, 스매시 팩터
- 📐 **발사 조건**: 발사각, 스핀량, 어택 앵글

## 🛠️ 기술 스택

- **Framework**: Flutter 3.x
- **상태 관리**: Riverpod 2.x
- **차트**: fl_chart
- **폰트**: Google Fonts (Outfit)
- **데이터**: JSON (로컬 assets)

## 📁 프로젝트 구조

```
lib/
├── models/              # 데이터 모델
│   ├── round.dart       # 라운드 데이터
│   ├── hole.dart        # 홀 데이터
│   ├── shot.dart        # 샷 데이터
│   ├── putt_analysis.dart    # 퍼팅 분석 모델
│   └── driver_analysis.dart  # 드라이버 분석 모델
│
├── repositories/        # 데이터 처리 로직
│   ├── asset_repository.dart  # 데이터 로딩
│   ├── stats_repository.dart  # 통계 계산
│   └── driver_repository.dart # 드라이버 통계 계산
│
├── viewmodels/          # 상태 관리
│   ├── providers.dart         # 메인 Providers
│   └── putting_providers.dart # 퍼팅 Providers
│
├── views/               # UI 화면
│   ├── dashboard_screen.dart         # 대시보드
│   ├── score_stats_screen.dart       # 스코어 분석
│   ├── putting_analysis_screen.dart  # 퍼팅 분석
│   ├── driver_analysis_screen.dart   # 드라이버 분석
│   └── widgets/                      # UI 컴포넌트
│
├── utils/               # 유틸리티
│   ├── app_constants.dart  # 상수 정의
│   └── format_utils.dart   # 포맷 유틸
│
└── main.dart            # 앱 진입점

assets/data/             # 샘플 데이터
├── all_sample_rounds.json    # 라운드 데이터
└── code_master_data.json     # 코드 마스터

docs/                    # 문서
├── 인수인계_문서.md      # 한글 핸드오버 문서
└── dev/                 # 개발 문서
    ├── 골프 통계 서비스 데이터 정의서.txt
    ├── 개발_준비사항_체크리스트.md
    ├── 준비사항_요약.md
    ├── generate_sample_data.py    # 샘플 데이터 생성 스크립트
    └── prepare_project.py         # 프로젝트 준비 스크립트
```

## 🚀 로컬 실행 방법

### 사전 요구사항
- Flutter SDK 3.0 이상
- Chrome 브라우저

### 실행 단계

1. **저장소 클론**
```bash
git clone https://github.com/noah8010/golf_snap_userdata.git
cd golf_snap_userdata
```

2. **의존성 설치**
```bash
flutter pub get
```

3. **웹 실행 (개발 모드)**
```bash
flutter run -d chrome
```

4. **웹 빌드 (프로덕션)**
```bash
flutter build web --release
```

## 📊 데이터 구조

### Round (라운드)
- 18홀 전체 라운드 요약 정보
- 총 스코어, 퍼팅 수, 페어웨이 적중 등

### Hole (홀)
- 각 홀별 상세 정보
- 스코어, 퍼팅 수, GIR, 페널티 등

### Shot (샷)
- 모든 샷의 상세 데이터
- 클럽 종류, 거리, 볼/클럽 센서 데이터
- 퍼팅 정보 (거리, 성공 여부)

## 🎨 주요 컴포넌트

### 드라이버 분석 위젯
- `DistanceStatsCard`: 비거리 통계 카드
- `AccuracyStatsCard`: 정확도 통계 카드
- `PenaltyStatsCard`: 페널티 통계 카드
- `BallFlightChart`: 구질 분포 파이 차트

### 퍼팅 분석 위젯
- `DistanceSuccessChart`: 거리별 성공률 차트
- `ThreePuttPieChart`: 3퍼트율 파이 차트
- `FirstPuttCard`: 첫 퍼팅 성공률 카드

## 🔧 개발 가이드

### 새로운 통계 추가하기

1. **모델 생성** (`lib/models/`)
```dart
class NewAnalysis {
  final double someMetric;
  // ...
}
```

2. **Repository 생성** (`lib/repositories/`)
```dart
class NewRepository {
  NewAnalysis getAnalysis(List<Round> rounds) {
    // 통계 계산 로직
  }
}
```

3. **Provider 추가** (`lib/viewmodels/providers.dart`)
```dart
final newAnalysisProvider = Provider<AsyncValue<NewAnalysis>>((ref) {
  final roundsAsync = ref.watch(filteredRoundsProvider);
  final repo = ref.watch(newRepositoryProvider);
  return roundsAsync.whenData((rounds) => repo.getAnalysis(rounds));
});
```

4. **UI 화면 생성** (`lib/views/`)
```dart
class NewAnalysisScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysis = ref.watch(newAnalysisProvider);
    // UI 구현
  }
}
```

## 📝 코드 스타일

- **주석**: 모든 public 클래스와 메서드에 문서화 주석 작성
- **네이밍**: camelCase (변수/함수), PascalCase (클래스)
- **포맷**: `dart format .` 사용

## 🌐 GitHub Pages 배포

### 자동 배포 (권장)

1. **코드 수정 및 커밋**
```bash
git add .
git commit -m "Update features"
git push origin main
```

2. **웹 빌드**
```bash
flutter build web --release --base-href /golf_snap_userdata/
```

3. **gh-pages 브랜치에 배포**
```bash
git checkout gh-pages
xcopy /E /I /Y build\web\* .
git add .
git commit -m "Deploy updates"
git push origin gh-pages
git checkout main
```

### GitHub Pages 설정

1. GitHub 저장소 → **Settings** → **Pages**
2. **Source**: `gh-pages` 브랜치 선택
3. **Save** 클릭
4. 약 1-2분 후 배포 완료

## 📱 지원 플랫폼

- ✅ Web (Chrome, Firefox, Safari, Edge)
- ✅ Mobile Web (iOS Safari, Android Chrome)
- ⚠️ Desktop (Windows, macOS, Linux) - 빌드 가능하나 웹 우선

## 🐛 알려진 이슈

- Chrome 디버그 모드에서 "Cannot send Null" 에러 발생 가능 → Release 모드 사용 권장

## 📄 라이선스

이 프로젝트는 개인 학습 및 포트폴리오 목적으로 제작되었습니다.

## 👤 개발자

- **noah.nam**
- GitHub: [@noah8010](https://github.com/noah8010)

## 📚 참고 문서

- [Flutter 공식 문서](https://flutter.dev/docs)
- [Riverpod 가이드](https://riverpod.dev/)
- [fl_chart 문서](https://github.com/imaNNeo/fl_chart)

---

**Last Updated**: 2025-11-28
