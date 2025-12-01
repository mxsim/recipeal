import sqlite3
from flask import Blueprint, render_template, current_app, g

feed_bp = Blueprint('feed', __name__, url_prefix='/feed')

# --- DB helper ---
def get_db():
    db_path = current_app.config['DATABASE']
    conn = getattr(g, '_database', None)
    if conn is None:
        conn = g._database = sqlite3.connect(db_path)
        conn.row_factory = sqlite3.Row
    return conn

@feed_bp.teardown_request
def close_connection(exception):
    conn = getattr(g, '_database', None)
    if conn is not None:
        conn.close()

# --- Feed page ---
@feed_bp.route('/')
def feed_page():
    db = get_db()
    recipes = db.execute("SELECT id, title, image FROM recipes").fetchall()

    # Example filter options (could be fetched from DB in the future)
    dish_types = ['Pasta', 'Salad', 'Soup', 'Dessert']
    countries = ['Italy', 'France', 'Japan', 'Mexico']

    # Selected filters (mock, for MVP)
    selected_dish_types = []
    selected_countries = []

    return render_template(
        'feed.html',
        recipes=recipes,
        dish_types=dish_types,
        countries=countries,
        selected_dish_types=selected_dish_types,
        selected_countries=selected_countries
    )
