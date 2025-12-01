venv\Scripts\activate



for calculating calories and ingredients we use apininjas.

api key: R5ziit5uFOfnr8WbA0ByDA==YZF0Iw5BQ1JniSAw

in run.py must be connected test data

app/
│
├── routes/
│   └── __init__.py
│
├── static/
│   ├── css/
│   │   └── styles.css
│   └── js/
│       └── script.js
│
├── templates/
│   ├── base.html
│   ├── fridge.html
│   └── index.html
├── venv/
└──instance/

│   ├── db.db

│   └── tdb.sql
└── run.py

db:

| Field         | Type         | Description        |
| ------------- | ------------ | ------------------ |
| id            | INTEGER (PK) | Unique user ID     |
| username      | TEXT         | Username           |
| email         | TEXT         | User email         |
| password_hash | TEXT         | Encrypted password |

| Field    | Type                    | Description                                             |
| -------- | ----------------------- | ------------------------------------------------------- |
| id       | INTEGER (PK)            | Ingredient ID                                           |
| name     | TEXT                    | Ingredient name                                         |
| amount   | TEXT                    | User-defined quantity (e.g., “2 eggs”, “200g milk”) |
| user_id  | INTEGER (FK → User.id) | Owner of this ingredient                                |
| calories | REAL                    | Cached calories (optional)                              |
| protein  | REAL                    | Cached protein                                          |
| carbs    | REAL                    | Cached carbohydrates                                    |
| fat      | REAL                    | Cached fat                                              |
