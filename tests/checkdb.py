import sqlite3
import os

def check_database():
    db_path = 'instance/recipes.db'
    
    if not os.path.exists(db_path):
        print(f"Database file not found at: {db_path}")
        return
    
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        # 1. Check if tables exist
        print("=== TABLES ===")
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables = cursor.fetchall()
        for table in tables:
            print(f"Table: {table[0]}")
        
        # 2. Check structure of each table
        print("\n=== TABLE STRUCTURES ===")
        for table in tables:
            print(f"\nStructure of '{table[0]}':")
            cursor.execute(f"PRAGMA table_info({table[0]});")
            columns = cursor.fetchall()
            for col in columns:
                print(f"  Column: {col[1]} | Type: {col[2]} | Nullable: {col[3]}")
        
        # 3. Check row counts
        print("\n=== ROW COUNTS ===")
        for table in tables:
            cursor.execute(f"SELECT COUNT(*) FROM {table[0]};")
            count = cursor.fetchone()[0]
            print(f"Table '{table[0]}': {count} rows")
        
        # 4. Sample data from each table (first 2 rows)
        print("\n=== SAMPLE DATA (first 2 rows from each table) ===")
        for table in tables:
            print(f"\n{table[0]} sample data:")
            cursor.execute(f"SELECT * FROM {table[0]} LIMIT 2;")
            rows = cursor.fetchall()
            if rows:
                # Get column names
                cursor.execute(f"PRAGMA table_info({table[0]});")
                columns = [col[1] for col in cursor.fetchall()]
                print(f"Columns: {columns}")
                for row in rows:
                    print(f"  {row}")
            else:
                print("  (No data)")
        
        conn.close()
        print(f"\n✅ Database verification complete!")
        
    except Exception as e:
        print(f"❌ Error checking database: {e}")

if __name__ == "__main__":
    check_database()