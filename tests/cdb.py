import sqlite3
import os

# Connect to database in instance folder
conn = sqlite3.connect('instance/recipes.db')

# Check where the SQL file actually is
sql_file_path = 'instance/tdb.sql'  # or 'app/tdb.sql' or 'instance/tdb.sql'

with open(sql_file_path, 'r') as f:
    conn.executescript(f.read())

conn.commit()
conn.close()
print('Database created successfully!')