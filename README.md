# Golf Stats App

Flutter로 구축된 종합 골프 통계 애플리케이션으로, 라운드 데이터를 분석하고 실질적인 인사이트를 제공합니다.

## 🌟 주요 기능

### 1. 스코어 분석
- **평균 스코어**: 시간 경과에 따른 스코어 성과를 추적합니다.
- **최고/최저 스코어**: 최고 및 최저 라운드를 확인합니다.
- **스코어 추세**: 스코어 진행 상황을 시각화합니다.

### 2. 퍼팅 분석
- **거리별 성공률**: 거리별(0-1m, 1-3m 등) 퍼팅 성과를 분석합니다.
- **쓰리 퍼트 비율**: 3퍼트 발생 빈도를 모니터링합니다.
- **첫 퍼트 성공률**: 첫 퍼트 성공 빈도를 추적합니다.

### 3. 라운드 관리
- **필터링**: 최근 10, 20, 30 라운드 또는 전체 기록에 대한 통계를 확인합니다.
- **데이터 생성**: 현실적인 샘플 데이터를 생성하는 Python 스크립트를 제공합니다.

## 🛠 기술 스택

- **프레임워크**: Flutter (Dart)
- **상태 관리**: Riverpod
- **차트**: fl_chart
- **데이터 형식**: JSON (로컬 저장소)

## 🚀 시작하기

### 사전 요구사항
- Flutter SDK 설치
- Python 3.x (데이터 생성용)

### 설치 방법

1. 저장소 복제:
   ```bash
   git clone <repository-url>
   ```

2. 샘플 데이터 생성:
   ```bash
   # 프로젝트 루트에서 실행
   python generate_sample_data.py
   ```
   이 명령은 `golf_stats_app/assets/data/all_sample_rounds.json` 파일을 생성합니다.

3. 앱 실행:
   ```bash
   cd golf_stats_app
   # Chrome에서 실행
   flutter run -d chrome
   
   # 또는 Windows에서 실행
   flutter run -d windows
   ```

## 📂 프로젝트 구조

```
lib/
├── models/          # 데이터 모델 (Round, Hole, Shot 등)
├── repositories/    # 데이터 접근 계층 (StatsRepository, AssetRepository)
├── viewmodels/      # 상태 관리 (Riverpod Providers)
├── views/           # UI 화면 및 위젯
│   ├── widgets/     # 재사용 가능한 UI 컴포넌트
│   └── ...
├── utils/           # 헬퍼 함수 및 상수
└── main.dart        # 앱 진입점
```

## 📝 인수인계 참고사항

- **데이터 생성**: `generate_sample_data.py` 스크립트는 `examples/` 폴더의 Excel 파일을 사용하여 현실적인 라운드 데이터를 생성합니다. 플레이어 이름이나 라운드 수를 변경하려면 스크립트의 `SCENARIOS`를 수정하세요.
- **통계 계산**: 모든 통계 로직은 `StatsRepository`에 있습니다. 추가 분석이 필요한 경우 여기에 새 메서드를 추가하세요.
- **UI 커스터마이징**: 색상 및 스타일은 `lib/utils/app_constants.dart`에 정의되어 있습니다.

## 🔜 향후 계획

- 드라이버 & 티샷 분석 구현 (페어웨이 적중률, 거리)
- 어프로치 샷 분석 추가 (GIR, 근접도)
- 좌표 기반 샷 추적 통합 (히트맵)
