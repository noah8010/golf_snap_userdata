# 골프 통계 앱 (Golf Stats App)

골프 라운드 데이터 구조에 맞게 동작하는 **프로토타입 웹 애플리케이션**입니다.
한국 출시를 목표로 UI가 한국어로 구성되어 있습니다.

## 라이브 데모

https://noah8010.github.io/golf_snap_userdata/

## 주요 기능

### 대시보드
- 평균 타수, 퍼팅, 드라이버 비거리 개요
- 베스트/워스트 스코어
- 전체 평균 대비 비교 분석
- 상위 10% 대비 비교
- 레이더 차트 시각화

### 스코어 분석
- 스코어 추이 그래프
- 스코어 분포 (이글, 버디, 파, 보기, 더블보기+)
- Par별 평균 타수
- 최근 스코어카드

### 퍼팅 분석
- 거리별 퍼팅 성공률 (0-1m, 1-3m, 3-5m, 5-10m, 10m+)
- 첫 퍼트 성공률
- 3퍼트 발생률

### 드라이버 분석
- 비거리 분석 (평균/최장/캐리/런/일관성)
- 정확도 분석 (페어웨이 적중률, 좌우 편차)
- 구질 분석 (드로우/페이드/스트레이트)
- 페널티 분석 (OB/해저드)

## 기술 스택

| 항목 | 기술 |
|------|------|
| 프레임워크 | Flutter 3.x (웹) |
| 언어 | Dart 3.9.0 |
| 상태 관리 | Riverpod 2.5.1 |
| 차트 | fl_chart 0.68.0 |
| 폰트 | Google Fonts (Outfit) |
| 아키텍처 | Repository Pattern + MVVM |

## 프로젝트 구조

```
lib/
├── main.dart              # 앱 진입점
├── models/                # 데이터 모델 (Round, Hole, Shot 등)
├── repositories/          # 데이터 처리 로직
│   ├── asset_repository.dart      # JSON 데이터 로딩
│   ├── stats_repository.dart      # 기본 통계 계산
│   ├── driver_repository.dart     # 드라이버 통계
│   ├── putting_repository.dart    # 퍼팅 통계
│   └── benchmark_repository.dart  # 벤치마크 비교
├── viewmodels/            # Riverpod Providers
├── views/                 # UI 화면
│   ├── dashboard_screen.dart
│   ├── score_stats_screen.dart
│   ├── putting_analysis_screen.dart
│   ├── driver_analysis_screen.dart
│   └── widgets/           # 재사용 위젯
└── utils/                 # 유틸리티

assets/data/
├── all_sample_rounds.json # 샘플 라운드 데이터
└── code_master_data.json  # 코드 마스터 데이터
```

## 로컬 실행

```bash
# 의존성 설치
flutter pub get

# 웹 실행 (개발)
flutter run -d chrome

# 웹 빌드 (배포)
flutter build web --release --base-href /golf_snap_userdata/
```

## 브랜치 구조

| 브랜치 | 용도 |
|--------|------|
| `main` | 소스 코드 |
| `gh-pages` | 빌드된 웹 파일 (GitHub Pages 배포용) |

## 버전 히스토리

| 버전 | 날짜 | 변경 사항 |
|------|------|----------|
| 1.1.0 | 2025-01-30 | UI 한국어화, 불필요 파일 정리, 웹 전용 구조 |
| 1.0.0 | 2024-12-08 | 초기 프로토타입 배포 |

---

**마지막 업데이트**: 2025-01-30
