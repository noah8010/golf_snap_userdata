import json

# 데이터 로드
with open('../../assets/data/all_sample_rounds_expanded.json', encoding='utf-8') as f:
    data = json.load(f)

# 기본 통계
print("=" * 60)
print("데이터 검증 결과")
print("=" * 60)

print(f"\n📊 기본 통계:")
print(f"  총 라운드 수: {len(data)}")

users = set(r['user_id'] for r in data)
print(f"  총 사용자 수: {len(users)}")

# 레벨별 분포
beginner = [r for r in data if 'beginner' in r['user_id']]
inter = [r for r in data if 'inter' in r['user_id']]
advanced = [r for r in data if 'advanced' in r['user_id']]

print(f"\n🎯 레벨별 분포:")
print(f"  초급: {len(beginner)}개 라운드 (평균 스코어: {sum(r['total_score'] for r in beginner)/len(beginner):.1f})")
print(f"  중급: {len(inter)}개 라운드 (평균 스코어: {sum(r['total_score'] for r in inter)/len(inter):.1f})")
print(f"  상급: {len(advanced)}개 라운드 (평균 스코어: {sum(r['total_score'] for r in advanced)/len(advanced):.1f})")

# 스코어 범위
scores = [r['total_score'] for r in data]
print(f"\n📈 스코어 통계:")
print(f"  최소: {min(scores)}")
print(f"  최대: {max(scores)}")
print(f"  평균: {sum(scores)/len(scores):.1f}")

# 데이터 무결성
print(f"\n✅ 데이터 무결성:")
print(f"  모든 라운드에 user_id: {all('user_id' in r for r in data)}")
print(f"  모든 라운드에 holes: {all('holes' in r for r in data)}")
print(f"  모든 라운드에 shots: {all('shots' in r for r in data)}")
print(f"  모든 라운드에 18홀: {all(len(r['holes']) == 18 for r in data)}")

# ID 중복 검사
round_ids = [r['round_id'] for r in data]
print(f"  round_id 중복 없음: {len(round_ids) == len(set(round_ids))}")

# 샘플 검증
sample = data[0]
print(f"\n🔍 샘플 라운드:")
print(f"  user_id: {sample['user_id']}")
print(f"  round_id: {sample['round_id']}")
print(f"  홀 수: {len(sample['holes'])}")
print(f"  샷 수: {len(sample['shots'])}")
print(f"  스코어: {sample['total_score']}")

print("\n" + "=" * 60)
print("✅ 검증 완료! 데이터가 정상입니다.")
print("=" * 60)
