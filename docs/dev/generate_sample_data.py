import os
import json
import uuid
import random
import pandas as pd
from datetime import datetime, timedelta

# --- 설정 ---
OUTPUT_DIR = "golf_stats_app/assets/data"
EXAMPLES_DIR = "examples"
EXCEL_FILE = "test_golf_data_v2_20251027.xlsx"  # 사용할 엑셀 파일

# 시나리오 설정
SCENARIOS = [
    {
        "name": "scenario_1_single",
        "players": ["noah.nam"],
        "num_rounds": 10,
        "num_courses": 2,
        "game_mode": "SINGLE",
        "game_rule": "RULE_STROKE"
    },
    {
        "name": "scenario_2_duo",
        "players": ["noah.nam", "kakao"],
        "num_rounds": 10,
        "num_courses": 3,
        "game_mode": "LOCAL",
        "game_rule": "RULE_STROKE" # 로컬 플레이도 기본은 스트로크로 설정
    },
    {
        "name": "scenario_3_trio",
        "players": ["noah.nam", "kakao", "kent"],
        "num_rounds": 10,
        "num_courses": 2,
        "game_mode": "LOCAL",
        "game_rule": "RULE_STROKE"
    }
]

# --- 유틸리티 함수 ---

def load_golf_courses():
    """Excel 파일에서 골프장 및 홀 정보를 읽어옵니다."""
    file_path = os.path.join(EXAMPLES_DIR, EXCEL_FILE)
    if not os.path.exists(file_path):
        print(f"[ERROR] Excel file not found: {file_path}")
        return None, None

    try:
        xl = pd.ExcelFile(file_path)
        print(f"[INFO] Sheets: {xl.sheet_names}")
        
        # 시트 이름 정규화 (공백 제거)
        sheet_map = {name.strip(): name for name in xl.sheet_names}
        print(f"[DEBUG] Normalized Sheets: {list(sheet_map.keys())}")

        # 1. CC Master 읽기
        if 'CC_Master' in sheet_map:
            df_cc = pd.read_excel(file_path, sheet_name=sheet_map['CC_Master'])
            df_cc.columns = [c.lower() for c in df_cc.columns]
            print(f"[INFO] CC Columns: {list(df_cc.columns)}")
        else:
            print("[ERROR] 'CC_Master' sheet not found")
            return None, None

        # 2. Course Master 읽기
        if 'Course_Master' in sheet_map:
            df_course = pd.read_excel(file_path, sheet_name=sheet_map['Course_Master'])
            df_course.columns = [c.lower() for c in df_course.columns]
            print(f"[INFO] Course Columns: {list(df_course.columns)}")
        else:
            print("[ERROR] 'Course_Master' sheet not found")
            return None, None
            
        # 3. Hole Master 읽기
        # Hole_Master 시트명이 'Hole_Master ' 처럼 공백이 있을 수 있음
        if 'Hole_Master' in sheet_map:
            df_hole = pd.read_excel(file_path, sheet_name=sheet_map['Hole_Master'])
            df_hole.columns = [c.lower() for c in df_hole.columns]
            print(f"[INFO] Hole Columns: {list(df_hole.columns)}")
        else:
            # 혹시 다른 이름일 수 있으니 확인
            possible_names = [s for s in sheet_map.keys() if 'Hole' in s]
            if possible_names:
                print(f"[WARN] 'Hole_Master' not found, trying: {possible_names[0]}")
                df_hole = pd.read_excel(file_path, sheet_name=sheet_map[possible_names[0]])
                df_hole.columns = [c.lower() for c in df_hole.columns]
            else:
                print("[ERROR] 'Hole_Master' sheet not found")
                return None, None

        # 컬럼 찾기 헬퍼 함수
        def find_col(df, candidates):
            for col in candidates:
                if col in df.columns:
                    return col
            return None

        # CC ID 컬럼 찾기
        cc_id_col = find_col(df_cc, ['cc_seq', 'cc_id', 'id', 'no'])
        cc_name_col = find_col(df_cc, ['cc_name_ko', 'cc_name', 'name', 'title'])
        
        if not cc_id_col:
            print(f"[ERROR] Cannot find CC ID column in {df_cc.columns}")
            return None, None
            
        # Course ID 컬럼 찾기
        course_id_col = find_col(df_course, ['course_seq', 'course_id', 'id'])
        course_cc_id_col = find_col(df_course, ['cc_seq', 'cc_id', 'parent_id'])
        course_name_col = find_col(df_course, ['course_name_ko', 'course_name', 'name'])
        
        if not course_id_col or not course_cc_id_col:
            print(f"[ERROR] Cannot find Course ID columns in {df_course.columns}")
            return None, None

        # 데이터프레임 병합
        print(f"[DEBUG] Merging on {cc_id_col} (CC) and {course_cc_id_col} (Course)")
        
        # 타입 불일치 방지를 위해 문자열로 변환
        df_cc[cc_id_col] = df_cc[cc_id_col].astype(str)
        df_course[course_cc_id_col] = df_course[course_cc_id_col].astype(str)
        
        courses_df = pd.merge(df_course, df_cc, left_on=course_cc_id_col, right_on=cc_id_col, how='left')
        
        # 필요한 컬럼만 추출하여 딕셔너리 리스트로 변환
        courses = []
        for _, row in courses_df.iterrows():
            courses.append({
                'cc_id': str(row.get(cc_id_col)),
                'cc_name': row.get(cc_name_col, 'Unknown CC'),
                'course_id': str(row.get(course_id_col)),
                'course_name': row.get(course_name_col, 'Unknown Course')
            })
            
        # 홀 정보도 매핑 준비
        hole_course_id_col = find_col(df_hole, ['course_seq', 'course_id', 'parent_id'])
        hole_seq_col = find_col(df_hole, ['hole_seq', 'hole_id', 'id'])
        hole_no_col = find_col(df_hole, ['hole_no', 'no', 'number'])
        hole_par_col = find_col(df_hole, ['par'])
        hole_dist_col = find_col(df_hole, ['distance_m', 'distance', 'dist'])

        if not hole_course_id_col:
             print(f"[ERROR] Cannot find Hole's Course ID column in {df_hole.columns}")
             return None, None

        holes = []
        for _, row in df_hole.iterrows():
            # cc_id를 찾기 위해 course_seq로 courses_df 참조
            course_val = row.get(hole_course_id_col)
            course_info = courses_df[courses_df[course_id_col] == course_val]
            
            if not course_info.empty:
                cc_id = str(course_info.iloc[0][cc_id_col])
            else:
                cc_id = "UNKNOWN"
                
            holes.append({
                'hole_id': str(row.get(hole_seq_col)) if hole_seq_col else generate_uuid(),
                'cc_id': cc_id,
                'course_id': str(course_val),
                'hole_no': row.get(hole_no_col, 0),
                'par': row.get(hole_par_col, 4),
                'distance': row.get(hole_dist_col, 350)
            })
            
        print(f"[INFO] Loaded {len(courses)} courses and {len(holes)} holes.")
        return courses, holes

    except Exception as e:
        print(f"[ERROR] Failed to load Excel: {e}")
        import traceback
        traceback.print_exc()
        return None, None

def generate_uuid():
    return str(uuid.uuid4())

def random_date(start_date, end_date):
    time_between_dates = end_date - start_date
    days_between_dates = time_between_dates.days
    random_number_of_days = random.randrange(days_between_dates)
    return start_date + timedelta(days=random_number_of_days)

def generate_shot_data(hole_score_id, user_id, par, strokes, start_time):
    """홀 스코어에 맞는 가상의 샷 데이터를 생성합니다."""
    shots = []
    
    putts = random.randint(1, 3) # 1~3 퍼트
    real_strokes = strokes - putts
    if real_strokes < 1: real_strokes = 1 
    
    current_shot_no = 1
    current_time = start_time
    
    # 샷 간격 (약 2~5분)
    def next_time():
        nonlocal current_time
        current_time += timedelta(seconds=random.randint(120, 300))
        return current_time.isoformat()

    # 1. 티샷
    shot_dist = round(random.uniform(200, 250) if par > 3 else random.uniform(130, 180), 2)
    shots.append({
        "shot_id": generate_uuid(),
        "hole_score_id": hole_score_id,
        "user_id": user_id,
        "shot_number": current_shot_no,
        "club_type": "CLUB_D" if par > 3 else "CLUB_I7",
        "shot_type": "SHOT_T",
        "lie": "LIE_TEE",
        "is_putt": False,
        "putt_made": False,
        "putt_length": 0.0,
        "is_mulligan": False,
        "shot_at": next_time(),
        "TOTAL": shot_dist,
        "CARRY": round(shot_dist * 0.9, 2),
        "HEIGHT": round(random.uniform(20, 30), 2),
        "LAND_ANG": round(random.uniform(30, 45), 2),
        "SIDE": round(random.uniform(-10, 10), 2),
        "SIDE_TOT": round(random.uniform(-15, 15), 2),
        "HANG_TIME": round(random.uniform(5, 7), 2),
        "FROM_PIN": round(random.uniform(100, 200) if par > 3 else random.uniform(5, 15), 2),
        # 센서 데이터 (Ball)
        "BALL_SPEED": round(random.uniform(60, 75), 2),
        "LAUNCH_ANG": round(random.uniform(10, 15), 2),
        "LAUNCH_DIR": round(random.uniform(-2, 2), 2),
        "SPIN_RATE": round(random.uniform(2000, 3000), 2),
        "SPIN_AXIS": round(random.uniform(-5, 5), 2),
        "BACK_SPIN": round(random.uniform(2000, 3000), 2),
        "SIDE_SPIN": round(random.uniform(-500, 500), 2),
        "SMASH_FAC": round(random.uniform(1.4, 1.5), 2),
        # 센서 데이터 (Club)
        "ATTACK_ANG": round(random.uniform(-2, 2), 2),
        "CLUB_PATH": round(random.uniform(-3, 3), 2),
        "DYN_LOFT": round(random.uniform(10, 15), 2),
        "SPIN_LOFT": round(random.uniform(10, 15), 2),
        "FACE_ANG": round(random.uniform(-2, 2), 2),
        "FACE_TO_PATH": round(random.uniform(-2, 2), 2),
        "CLUB_SPEED": round(random.uniform(40, 50), 2)
    })
    current_shot_no += 1
    
    # 2. 세컨/서드 샷 (퍼팅 전까지)
    for i in range(real_strokes - 1):
        dist_remain = round(random.uniform(10, 150), 2)
        shots.append({
            "shot_id": generate_uuid(),
            "hole_score_id": hole_score_id,
            "user_id": user_id,
            "shot_number": current_shot_no,
            "club_type": random.choice(["CLUB_I5", "CLUB_I7", "CLUB_I9", "CLUB_PW"]),
            "shot_type": "SHOT_A",
            "lie": "LIE_FAIR",
            "is_putt": False,
            "putt_made": False,
            "putt_length": 0.0,
            "is_mulligan": False,
            "shot_at": next_time(),
            "TOTAL": round(random.uniform(100, 150), 2),
            "CARRY": round(random.uniform(90, 140), 2),
            "HEIGHT": round(random.uniform(15, 25), 2),
            "LAND_ANG": round(random.uniform(40, 50), 2),
            "SIDE": round(random.uniform(-5, 5), 2),
            "SIDE_TOT": round(random.uniform(-10, 10), 2),
            "HANG_TIME": round(random.uniform(4, 6), 2),
            "FROM_PIN": dist_remain, # 남은 거리
             # 센서 데이터 (Ball)
            "BALL_SPEED": round(random.uniform(40, 60), 2),
            "LAUNCH_ANG": round(random.uniform(15, 25), 2),
            "LAUNCH_DIR": round(random.uniform(-2, 2), 2),
            "SPIN_RATE": round(random.uniform(4000, 7000), 2),
            "SPIN_AXIS": round(random.uniform(-5, 5), 2),
            "BACK_SPIN": round(random.uniform(4000, 7000), 2),
            "SIDE_SPIN": round(random.uniform(-300, 300), 2),
            "SMASH_FAC": round(random.uniform(1.3, 1.4), 2),
            # 센서 데이터 (Club)
            "ATTACK_ANG": round(random.uniform(-4, -1), 2),
            "CLUB_PATH": round(random.uniform(-2, 2), 2),
            "DYN_LOFT": round(random.uniform(20, 30), 2),
            "SPIN_LOFT": round(random.uniform(20, 30), 2),
            "FACE_ANG": round(random.uniform(-2, 2), 2),
            "FACE_TO_PATH": round(random.uniform(-2, 2), 2),
            "CLUB_SPEED": round(random.uniform(30, 40), 2)
        })
        current_shot_no += 1
        
    # 3. 퍼팅
    first_putt_dist = 0.0
    first_putt_made = False
    
    for i in range(putts):
        is_last = (i == putts - 1)
        dist = round(random.uniform(1.0, 15.0) if i == 0 else random.uniform(0.1, 2.0), 2)
        
        if i == 0:
            first_putt_dist = dist
            first_putt_made = is_last

        shots.append({
            "shot_id": generate_uuid(),
            "hole_score_id": hole_score_id,
            "user_id": user_id,
            "shot_number": current_shot_no,
            "club_type": "CLUB_P",
            "shot_type": "SHOT_P",
            "lie": "LIE_GREEN",
            "is_putt": True,
            "putt_made": is_last,
            "putt_length": dist,
            "is_mulligan": False,
            "shot_at": next_time(),
            "TOTAL": dist if is_last else round(dist - random.uniform(0.1, 1.0), 2),
            "CARRY": 0,
            "HEIGHT": 0,
            "LAND_ANG": 0,
            "SIDE": round(random.uniform(-0.1, 0.1), 2),
            "SIDE_TOT": round(random.uniform(-0.1, 0.1), 2),
            "HANG_TIME": 0,
            "FROM_PIN": 0 if is_last else round(random.uniform(0.1, 1.5), 2),
             # 센서 데이터 (Ball) - 퍼팅은 단순화
            "BALL_SPEED": round(random.uniform(2, 5), 2),
            "LAUNCH_ANG": 0,
            "LAUNCH_DIR": round(random.uniform(-1, 1), 2),
            "SPIN_RATE": round(random.uniform(10, 50), 2),
            "SPIN_AXIS": 0,
            "BACK_SPIN": round(random.uniform(10, 50), 2),
            "SIDE_SPIN": 0,
            "SMASH_FAC": 1.0,
            # 센서 데이터 (Club)
            "ATTACK_ANG": 0,
            "CLUB_PATH": round(random.uniform(-1, 1), 2),
            "DYN_LOFT": 3,
            "SPIN_LOFT": 3,
            "FACE_ANG": round(random.uniform(-1, 1), 2),
            "FACE_TO_PATH": 0,
            "CLUB_SPEED": round(random.uniform(1, 3), 2)
        })
        current_shot_no += 1
        
    return shots, putts, current_time, first_putt_dist, first_putt_made

def generate_round_data(scenario, courses, all_holes):
    """시나리오에 따른 라운드 데이터를 생성합니다."""
    rounds_data = []
    
    selected_courses = random.sample(courses, min(scenario['num_courses'], len(courses)))
    
    start_date = datetime.now() - timedelta(days=90)
    end_date = datetime.now()
    
    for i in range(scenario['num_rounds']):
        course = random.choice(selected_courses)
        cc_id = course['cc_id']
        course_id = course['course_id']
        
        target_holes = [h for h in all_holes if h.get('cc_id') == cc_id and h.get('course_id') == course_id]
        
        if len(target_holes) < 18:
            target_holes = []
            for h_no in range(1, 19):
                target_holes.append({
                    'hole_id': f"{cc_id}_{course_id}_{h_no}",
                    'hole_no': h_no,
                    'par': random.choice([3, 4, 4, 4, 4, 4, 4, 5, 5]),
                    'distance': 350
                })
        else:
            target_holes = target_holes[:18]
            
        game_session_id = generate_uuid() if len(scenario['players']) > 1 else None
        simulator_id = "SIM_001" if scenario['game_mode'] != 'SINGLE' else None
        
        round_start_time = random_date(start_date, end_date)
        
        for player in scenario['players']:
            round_id = generate_uuid()
            
            # 통계 집계 변수
            total_score = 0
            total_putts = 0
            fairways_hit = 0
            fairways_attempted = 0
            greens_in_regulation = 0
            mulligans_used = 0
            birdies_or_better = 0
            pars_count = 0
            bogeys = 0
            double_bogey_or_worse = 0
            
            holes_data = []
            shots_data = []
            
            current_hole_time = round_start_time
            
            for hole in target_holes:
                par = hole.get('par', 4)
                score_diff = random.randint(-1, 3)
                strokes = par + score_diff
                
                hole_score_id = generate_uuid()
                
                # 샷 데이터 생성
                hole_shots, hole_putts, next_time_val, f_putt_dist, f_putt_made = generate_shot_data(hole_score_id, player, par, strokes, current_hole_time)
                current_hole_time = next_time_val # 다음 홀 시작 시간 업데이트
                
                shots_data.extend(hole_shots)
                
                # 홀 통계 계산
                is_fairway_hit = random.choice([True, False]) if par > 3 else None
                is_gir = (strokes - hole_putts) <= (par - 2)
                
                holes_data.append({
                    "hole_score_id": hole_score_id,
                    "round_id": round_id,
                    "hole_number": hole.get('hole_no'),
                    "hole_id": hole.get('hole_id'),
                    "par": par,
                    "distance": hole.get('distance'),
                    "strokes": strokes,
                    "putts": hole_putts,
                    "fairway_hit": is_fairway_hit,
                    "green_in_regulation": is_gir,
                    "penalties": 0, # 단순화
                    "penalty_details": [],
                    "first_putt_distance": f_putt_dist,
                    "first_putt_made": f_putt_made
                })
                
                # 라운드 통계 누적
                total_score += strokes
                total_putts += hole_putts
                if par > 3:
                    fairways_attempted += 1
                    if is_fairway_hit: fairways_hit += 1
                if is_gir: greens_in_regulation += 1
                
                if strokes <= par - 1: birdies_or_better += 1
                elif strokes == par: pars_count += 1
                elif strokes == par + 1: bogeys += 1
                else: double_bogey_or_worse += 1
            
            round_record = {
                "game_session_id": game_session_id,
                "game_mode": scenario['game_mode'],
                "game_rule": scenario['game_rule'],
                "simulator_id": simulator_id,
                "round_id": round_id,
                "user_id": player,
                "team_id": None, # 개인전 가정
                "played_at": round_start_time.isoformat(),
                "cc_id": cc_id,
                "cc_name": course.get('cc_name'),
                "course_id": course_id,
                "course_name": course.get('course_name'),
                "tee_box": "TB_WHITE",
                "total_par": sum(h.get('par', 4) for h in target_holes),
                "total_score": total_score,
                "rank": 1, # 임시
                "ranking_eligible": True,
                "total_putts": total_putts,
                "fairways_hit": fairways_hit,
                "fairways_attempted": fairways_attempted,
                "greens_in_regulation": greens_in_regulation,
                "mulligans_used": mulligans_used,
                "birdies_or_better": birdies_or_better,
                "pars": pars_count,
                "bogeys": bogeys,
                "double_bogey_or_worse": double_bogey_or_worse,
                "play_end_time": current_hole_time.isoformat(),
                "holes": holes_data,
                "shots": shots_data
            }
            rounds_data.append(round_record)
            
    return rounds_data

def main():
    print("Generating sample data...")
    
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)
        
    courses, holes = load_golf_courses()
    if not courses:
        print("[ERROR] Cannot generate data without course info.")
        return

    all_rounds = []
    
    for scenario in SCENARIOS:
        print(f"Processing scenario: {scenario['name']}")
        scenario_rounds = generate_round_data(scenario, courses, holes)
        all_rounds.extend(scenario_rounds)
        
        # 시나리오별 파일 저장 (선택사항)
        # with open(os.path.join(OUTPUT_DIR, f"{scenario['name']}.json"), 'w', encoding='utf-8') as f:
        #     json.dump(scenario_rounds, f, indent=2, ensure_ascii=False)
            
    # 전체 데이터 통합 저장
    output_file = os.path.join(OUTPUT_DIR, "all_sample_rounds.json")
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(all_rounds, f, indent=2, ensure_ascii=False)
        
    print(f"\n[SUCCESS] Generated {len(all_rounds)} rounds in {output_file}")

if __name__ == "__main__":
    main()
