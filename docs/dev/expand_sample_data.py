"""
골프 샘플 데이터 확장 스크립트

기존 all_sample_rounds.json을 기반으로 다양한 실력 수준의 가상 사용자 데이터를 생성합니다.
기존 프레임워크를 전혀 수정하지 않으며, 데이터 구조를 완벽하게 유지합니다.

사용법:
    python expand_sample_data.py

출력:
    - all_sample_rounds_expanded.json (확장된 데이터)
    - 기존 파일은 all_sample_rounds_original.json으로 백업
"""

import json
import copy
import random
import uuid
from datetime import datetime, timedelta
from pathlib import Path

# 실력 레벨별 변형 계수
SKILL_LEVELS = {
    'beginner': {
        'name': '초급',
        'score_adjust': (10, 15),      # +10~15타
        'fairway_mult': 0.6,            # 60%
        'gir_mult': 0.5,                # 50%
        'putt_adjust': (4, 6),          # +4~6개
        'driver_dist_mult': 0.85,       # 85%
        'putt_success_mult': 0.7,       # 70%
    },
    'intermediate': {
        'name': '중급',
        'score_adjust': (-3, 3),        # ±3타
        'fairway_mult': 1.0,            # 100%
        'gir_mult': 1.0,                # 100%
        'putt_adjust': (-2, 2),         # ±2개
        'driver_dist_mult': 1.0,        # 100%
        'putt_success_mult': 1.0,       # 100%
    },
    'advanced': {
        'name': '상급',
        'score_adjust': (-12, -8),      # -8~12타
        'fairway_mult': 1.35,           # 135%
        'gir_mult': 1.5,                # 150%
        'putt_adjust': (-5, -3),        # -3~5개
        'driver_dist_mult': 1.15,       # 115%
        'putt_success_mult': 1.3,       # 130%
    }
}


def generate_user_id(skill_level, index):
    """가상 사용자 ID 생성"""
    level_prefix = {
        'beginner': 'beginner',
        'intermediate': 'inter',
        'advanced': 'advanced'
    }
    return f"{level_prefix[skill_level]}.user{index:03d}"


def adjust_score_distribution(original, skill_level):
    """스코어 분포 재계산"""
    config = SKILL_LEVELS[skill_level]
    
    # 원본 비율 유지하면서 조정
    total = (original['birdies_or_better'] + original['pars'] + 
             original['bogeys'] + original['double_bogey_or_worse'])
    
    if skill_level == 'beginner':
        # 초급: 보기/더블보기 증가
        return {
            'birdies_or_better': max(0, original['birdies_or_better'] - 1),
            'pars': max(0, original['pars'] - 2),
            'bogeys': original['bogeys'] + 1,
            'double_bogey_or_worse': original['double_bogey_or_worse'] + 2
        }
    elif skill_level == 'advanced':
        # 상급: 버디/파 증가
        return {
            'birdies_or_better': original['birdies_or_better'] + 2,
            'pars': original['pars'] + 2,
            'bogeys': max(0, original['bogeys'] - 2),
            'double_bogey_or_worse': max(0, original['double_bogey_or_worse'] - 2)
        }
    else:
        # 중급: 약간의 랜덤 변동
        return {
            'birdies_or_better': max(0, original['birdies_or_better'] + random.randint(-1, 1)),
            'pars': max(0, original['pars'] + random.randint(-2, 2)),
            'bogeys': max(0, original['bogeys'] + random.randint(-1, 1)),
            'double_bogey_or_worse': max(0, original['double_bogey_or_worse'] + random.randint(-1, 1))
        }


def transform_hole(hole, skill_level, new_round_id):
    """홀 데이터 변형"""
    new_hole = copy.deepcopy(hole)
    config = SKILL_LEVELS[skill_level]
    
    # ID 갱신
    new_hole['hole_score_id'] = str(uuid.uuid4())
    new_hole['round_id'] = new_round_id
    
    # 스트로크 조정
    stroke_adjust = random.randint(*config['score_adjust']) // 18
    new_hole['strokes'] = max(new_hole['par'], new_hole['strokes'] + stroke_adjust)
    
    # 퍼팅 조정
    putt_adjust = random.randint(*config['putt_adjust']) // 18
    new_hole['putts'] = max(1, new_hole['putts'] + putt_adjust)
    
    # 페어웨이/GIR 조정
    if new_hole['par'] >= 4:  # Par 3는 페어웨이 없음
        if random.random() < config['fairway_mult']:
            new_hole['fairway_hit'] = True
        else:
            new_hole['fairway_hit'] = False
    
    if random.random() < config['gir_mult']:
        new_hole['green_in_regulation'] = True
    else:
        new_hole['green_in_regulation'] = False
    
    return new_hole


def transform_shot(shot, skill_level, new_user_id):
    """샷 데이터 변형"""
    new_shot = copy.deepcopy(shot)
    config = SKILL_LEVELS[skill_level]
    
    # ID 갱신
    new_shot['shot_id'] = str(uuid.uuid4())
    new_shot['user_id'] = new_user_id
    
    # 드라이버 샷 변형
    if new_shot['club_type'] == 'CLUB_D' and new_shot['TOTAL']:
        mult = config['driver_dist_mult']
        variation = random.uniform(0.95, 1.05)  # ±5% 랜덤 변동
        
        new_shot['TOTAL'] = round(new_shot['TOTAL'] * mult * variation, 2)
        if new_shot['CARRY']:
            new_shot['CARRY'] = round(new_shot['CARRY'] * mult * variation, 2)
        
        # 볼/클럽 스피드도 조정
        if new_shot['BALL_SPEED']:
            new_shot['BALL_SPEED'] = round(new_shot['BALL_SPEED'] * mult * variation, 2)
        if new_shot['CLUB_SPEED']:
            new_shot['CLUB_SPEED'] = round(new_shot['CLUB_SPEED'] * mult * variation, 2)
    
    # 퍼팅 성공률 조정
    if new_shot['is_putt']:
        success_mult = config['putt_success_mult']
        if random.random() < success_mult:
            # 성공률 향상
            if new_shot['putt_length'] and new_shot['putt_length'] < 3:
                new_shot['putt_made'] = True
        else:
            # 성공률 하락
            if new_shot['putt_length'] and new_shot['putt_length'] > 5:
                new_shot['putt_made'] = False
    
    return new_shot


def transform_round(round_data, skill_level, user_index):
    """라운드 데이터 전체 변형"""
    new_round = copy.deepcopy(round_data)
    config = SKILL_LEVELS[skill_level]
    
    # 새 ID 생성
    new_round_id = str(uuid.uuid4())
    new_user_id = generate_user_id(skill_level, user_index)
    
    # 기본 정보 갱신
    new_round['round_id'] = new_round_id
    new_round['user_id'] = new_user_id
    
    # 날짜 랜덤 조정 (최근 6개월 내)
    base_date = datetime.fromisoformat(round_data['played_at'].replace('Z', '+00:00'))
    days_offset = random.randint(-180, 0)
    new_date = base_date + timedelta(days=days_offset)
    new_round['played_at'] = new_date.isoformat()
    if 'play_end_time' in new_round:
        end_date = base_date + timedelta(days=days_offset, hours=5)
        new_round['play_end_time'] = end_date.isoformat()
    
    # 스코어 조정
    score_adjust = random.randint(*config['score_adjust'])
    new_round['total_score'] = max(new_round['total_par'], new_round['total_score'] + score_adjust)
    
    # 페어웨이 조정
    new_fairways = int(new_round['fairways_hit'] * config['fairway_mult'])
    new_round['fairways_hit'] = max(0, min(new_fairways, new_round['fairways_attempted']))
    
    # GIR 조정
    new_gir = int(new_round['greens_in_regulation'] * config['gir_mult'])
    new_round['greens_in_regulation'] = max(0, min(new_gir, 18))
    
    # 퍼팅 조정
    putt_adjust = random.randint(*config['putt_adjust'])
    new_round['total_putts'] = max(18, new_round['total_putts'] + putt_adjust)
    
    # 스코어 분포 재계산
    score_dist = adjust_score_distribution(new_round, skill_level)
    new_round['birdies_or_better'] = score_dist['birdies_or_better']
    new_round['pars'] = score_dist['pars']
    new_round['bogeys'] = score_dist['bogeys']
    new_round['double_bogey_or_worse'] = score_dist['double_bogey_or_worse']
    
    # 홀 데이터 변형
    new_round['holes'] = [
        transform_hole(hole, skill_level, new_round_id)
        for hole in new_round['holes']
    ]
    
    # 샷 데이터 변형 및 hole_score_id 매핑
    hole_id_map = {
        old['hole_score_id']: new['hole_score_id']
        for old, new in zip(round_data['holes'], new_round['holes'])
    }
    
    new_round['shots'] = []
    for shot in round_data['shots']:
        new_shot = transform_shot(shot, skill_level, new_user_id)
        new_shot['hole_score_id'] = hole_id_map[shot['hole_score_id']]
        new_round['shots'].append(new_shot)
    
    return new_round


def expand_sample_data(input_file, output_file, users_per_level=10):
    """
    샘플 데이터 확장
    
    Args:
        input_file: 원본 데이터 파일 경로
        output_file: 출력 파일 경로
        users_per_level: 실력 레벨당 생성할 사용자 수
    """
    print("=" * 60)
    print("골프 샘플 데이터 확장 스크립트")
    print("=" * 60)
    
    # 원본 데이터 로드
    print(f"\n1. 원본 데이터 로딩: {input_file}")
    with open(input_file, 'r', encoding='utf-8') as f:
        base_rounds = json.load(f)
    
    print(f"   ✓ 원본 라운드 수: {len(base_rounds)}개")
    
    # 확장 데이터 생성
    print(f"\n2. 데이터 확장 중...")
    print(f"   - 실력 레벨: 3단계 (초급/중급/상급)")
    print(f"   - 레벨당 사용자: {users_per_level}명")
    print(f"   - 예상 총 라운드: {len(base_rounds) * 3 * users_per_level}개")
    
    expanded_rounds = []
    user_counter = {'beginner': 1, 'intermediate': 1, 'advanced': 1}
    
    for skill_level in ['beginner', 'intermediate', 'advanced']:
        level_name = SKILL_LEVELS[skill_level]['name']
        print(f"\n   [{level_name}] 데이터 생성 중...")
        
        for user_idx in range(users_per_level):
            for round_data in base_rounds:
                new_round = transform_round(
                    round_data,
                    skill_level,
                    user_counter[skill_level]
                )
                expanded_rounds.append(new_round)
            
            user_counter[skill_level] += 1
            print(f"      사용자 {user_idx + 1}/{users_per_level} 완료")
    
    print(f"\n   ✓ 총 생성된 라운드: {len(expanded_rounds)}개")
    print(f"   ✓ 총 사용자 수: {sum(user_counter.values()) - 3}명")
    
    # 데이터 저장
    print(f"\n3. 데이터 저장 중: {output_file}")
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(expanded_rounds, f, ensure_ascii=False, indent=2)
    
    # 파일 크기 확인
    file_size = Path(output_file).stat().st_size / (1024 * 1024)
    print(f"   ✓ 파일 크기: {file_size:.2f} MB")
    
    # 통계 요약
    print("\n" + "=" * 60)
    print("생성 완료!")
    print("=" * 60)
    print(f"\n📊 통계 요약:")
    print(f"   - 초급 사용자: {users_per_level}명 × {len(base_rounds)}라운드 = {users_per_level * len(base_rounds)}개")
    print(f"   - 중급 사용자: {users_per_level}명 × {len(base_rounds)}라운드 = {users_per_level * len(base_rounds)}개")
    print(f"   - 상급 사용자: {users_per_level}명 × {len(base_rounds)}라운드 = {users_per_level * len(base_rounds)}개")
    print(f"   - 총계: {len(expanded_rounds)}개 라운드")
    
    print(f"\n📁 출력 파일: {output_file}")
    print(f"   파일 크기: {file_size:.2f} MB")
    
    print("\n✅ 다음 단계:")
    print("   1. 기존 파일 백업:")
    print("      mv assets/data/all_sample_rounds.json assets/data/all_sample_rounds_original.json")
    print("   2. 새 파일로 교체:")
    print("      mv assets/data/all_sample_rounds_expanded.json assets/data/all_sample_rounds.json")


if __name__ == "__main__":
    # 파일 경로 설정
    script_dir = Path(__file__).parent
    project_root = script_dir.parent.parent
    
    input_file = project_root / "assets" / "data" / "all_sample_rounds.json"
    output_file = project_root / "assets" / "data" / "all_sample_rounds_expanded.json"
    
    # 파일 존재 확인
    if not input_file.exists():
        print(f"❌ 오류: 입력 파일을 찾을 수 없습니다: {input_file}")
        exit(1)
    
    # 데이터 확장 실행
    # users_per_level을 조정하여 데이터 양 조절 가능 (기본: 10명)
    expand_sample_data(
        input_file=str(input_file),
        output_file=str(output_file),
        users_per_level=10  # 레벨당 10명 = 총 30명
    )
