"""
프로젝트 준비 스크립트
- Excel 파일 구조 확인
- 샘플 데이터 생성 준비
"""
import os
import sys

try:
    import pandas as pd
    import openpyxl
except ImportError:
    print("필요한 패키지 설치 중...")
    print("pip install pandas openpyxl")
    sys.exit(1)

def check_excel_files():
    """examples 폴더의 Excel 파일 구조 확인"""
    examples_dir = "examples"
    
    if not os.path.exists(examples_dir):
        print(f"[ERROR] {examples_dir} folder not found.")
        return
    
    excel_files = [f for f in os.listdir(examples_dir) 
                   if f.endswith('.xlsx') and not f.startswith('~$')]
    
    if not excel_files:
        print(f"[ERROR] No Excel files in {examples_dir} folder.")
        return
    
    print(f"\n[INFO] Found {len(excel_files)} Excel file(s):")
    print("-" * 60)
    
    for file in excel_files:
        file_path = os.path.join(examples_dir, file)
        try:
            # Excel 파일 읽기
            xl_file = pd.ExcelFile(file_path)
            
            print(f"\nFile: {file}")
            print(f"  Sheets: {xl_file.sheet_names}")
            
            # 각 시트의 구조 확인
            for sheet_name in xl_file.sheet_names[:3]:  # 최대 3개 시트만 확인
                df = pd.read_excel(file_path, sheet_name=sheet_name, nrows=5)
                print(f"\n  Sheet: {sheet_name}")
                print(f"  - Columns: {len(df.columns)}")
                print(f"  - Column names: {list(df.columns)[:10]}...")  # 처음 10개만
                print(f"  - Sample rows: {len(df)}")
                
        except Exception as e:
            print(f"  [WARNING] File read error: {e}")
    
    print("\n" + "=" * 60)

if __name__ == "__main__":
    print("=" * 60)
    print("Golf Statistics Service - Project Preparation Script")
    print("=" * 60)
    
    check_excel_files()
    
    print("\n[SUCCESS] Excel file structure check completed")
    print("\nNext steps:")
    print("1. Create CC data parsing script based on Excel structure")
    print("2. Create database schema")
    print("3. Create sample data generation script")

