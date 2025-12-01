# 샘플 데이터 확장 가이드

## 📋 개요

`expand_sample_data.py` 스크립트는 기존 골프 라운드 데이터를 기반으로 다양한 실력 수준의 가상 사용자 데이터를 생성합니다.

## 🎯 목적

비교 통계 기능 구현을 위해 다양한 실력 레벨의 사용자 데이터가 필요합니다. 이 스크립트는:
- 기존 데이터 구조를 100% 유지
- 통계적으로 현실적인 데이터 생성
- 기존 프레임워크를 전혀 수정하지 않음

## 🚀 사용 방법

### 1. 스크립트 실행

```bash
cd docs/dev
python expand_sample_data.py
```

### 2. 출력 확인

스크립트 실행 후 다음 파일이 생성됩니다:
- `assets/data/all_sample_rounds_expanded.json`

### 3. 파일 교체

```bash
# 기존 파일 백업
mv ../../assets/data/all_sample_rounds.json ../../assets/data/all_sample_rounds_original.json

# 확장된 파일로 교체
mv ../../assets/data/all_sample_rounds_expanded.json ../../assets/data/all_sample_rounds.json
```

또는 Windows에서:
```powershell
# 기존 파일 백업
Move-Item ..\..\assets\data\all_sample_rounds.json ..\..\assets\data\all_sample_rounds_original.json

# 확장된 파일로 교체
Move-Item ..\..\assets\data\all_sample_rounds_expanded.json ..\..\assets\data\all_sample_rounds.json
```

## 📊 생성되는 데이터

### 실력 레벨

스크립트는 3가지 실력 레벨의 사용자를 생성합니다:

#### 1. 초급 (Beginner)
- **user_id**: `beginner.user001` ~ `beginner.user010`
- **스코어**: 원본 + 10~15타
- **페어웨이**: 원본 × 60%
- **GIR**: 원본 × 50%
- **퍼팅**: 원본 + 4~6개
- **드라이버 거리**: 원본 × 85%

#### 2. 중급 (Intermediate)
- **user_id**: `inter.user001` ~ `inter.user010`
- **스코어**: 원본 ± 3타
- **페어웨이**: 원본 × 100%
- **GIR**: 원본 × 100%
- **퍼팅**: 원본 ± 2개
- **드라이버 거리**: 원본 × 100%

#### 3. 상급 (Advanced)
- **user_id**: `advanced.user001` ~ `advanced.user010`
- **스코어**: 원본 - 8~12타
- **페어웨이**: 원본 × 135%
- **GIR**: 원본 × 150%
- **퍼팅**: 원본 - 3~5개
- **드라이버 거리**: 원본 × 115%

### 데이터 규모

기본 설정 (`users_per_level=10`):
- **총 사용자**: 30명 (각 레벨 10명)
- **총 라운드**: 원본 라운드 수 × 30
- **예상 파일 크기**: 약 200MB

## ⚙️ 설정 조정

`expand_sample_data.py` 파일의 마지막 부분에서 사용자 수를 조정할 수 있습니다:

```python
expand_sample_data(
    input_file=str(input_file),
    output_file=str(output_file),
    users_per_level=10  # 이 값을 변경 (5, 10, 15 등)
)
```

### 권장 설정

| 목적 | users_per_level | 총 사용자 | 예상 크기 |
|------|-----------------|-----------|-----------|
| 빠른 테스트 | 3 | 9명 | ~60MB |
| 프로토타입 (권장) | 10 | 30명 | ~200MB |
| 풍부한 데이터 | 20 | 60명 | ~400MB |

## 🔍 데이터 검증

생성된 데이터는 다음을 보장합니다:

✅ **구조 무결성**
- 모든 ID가 고유함 (UUID 사용)
- 외래 키 관계 유지 (round_id, hole_score_id)
- 필수 필드 모두 포함

✅ **통계적 현실성**
- 실력 레벨에 따른 일관된 변형
- 랜덤 변동으로 자연스러운 분포
- 골프 규칙 준수 (최소 퍼팅, 스코어 범위 등)

✅ **데이터 다양성**
- 날짜 분산 (최근 6개월)
- 사용자별 고유 ID
- 실력 레벨별 균등 분포

## 📝 주의사항

### 실행 전
- Python 3.7 이상 필요
- 충분한 디스크 공간 확보 (~500MB)
- 기존 데이터 백업 권장

### 실행 중
- 데이터 양에 따라 1-5분 소요
- 메모리 사용량: 약 500MB-1GB

### 실행 후
- 생성된 파일 크기 확인
- Flutter 앱에서 로딩 테스트
- 필요시 `users_per_level` 조정

## 🐛 문제 해결

### 파일을 찾을 수 없음
```
❌ 오류: 입력 파일을 찾을 수 없습니다
```
**해결**: 스크립트를 `docs/dev/` 폴더에서 실행하세요.

### 메모리 부족
```
MemoryError
```
**해결**: `users_per_level`을 줄이세요 (예: 5로 설정).

### 파일 크기가 너무 큼
**해결**: `users_per_level`을 줄이거나, 생성 후 일부 라운드를 제거하세요.

## 📈 예상 결과

### 통계 분포 (users_per_level=10 기준)

**스코어 분포:**
- 70-80타: ~10% (상급)
- 80-90타: ~30% (중상급)
- 90-100타: ~30% (중급)
- 100-110타: ~20% (초중급)
- 110타+: ~10% (초급)

**페어웨이 적중률:**
- 70%+: ~10%
- 60-70%: ~20%
- 50-60%: ~40%
- 40-50%: ~20%
- 40% 미만: ~10%

## ✅ 완료 후 확인사항

1. ✅ 파일 크기가 적절한지 확인
2. ✅ Flutter 앱 실행하여 로딩 테스트
3. ✅ 대시보드에서 통계 정상 표시 확인
4. ✅ 비교 통계 기능 개발 시작 가능

---

**작성일**: 2025-11-28  
**버전**: 1.0
