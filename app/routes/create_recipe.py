import sqlite3
from flask import Blueprint, current_app, g, render_template, request, jsonify

create_recipe_bp = Blueprint('create_recipe', __name__, url_prefix='/create_recipe')

# --- DB helper ---
def get_db():
    db_path = current_app.config['DATABASE']
    conn = getattr(g, '_database', None)
    if conn is None:
        conn = g._database = sqlite3.connect(db_path)
        conn.row_factory = sqlite3.Row
    return conn

@create_recipe_bp.teardown_request
def close_connection(exception):
    conn = getattr(g, '_database', None)
    if conn is not None:
        conn.close()

# --- Pages ---
@create_recipe_bp.route('/')
def create_recipe_page():
    return render_template('create_recipe.html')