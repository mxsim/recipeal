import sqlite3
from flask import Blueprint, current_app, g, render_template, request, jsonify

book_bp = Blueprint('book', __name__, url_prefix='/book')

def get_db():
    db_path = current_app.config['DATABASE']
    conn = getattr(g, '_database', None)
    if conn is None:
        conn = g._database = sqlite3.connect(db_path)
        conn.row_factory = sqlite3.Row
    return conn

@book_bp.teardown_request
def close_conn(exc):
    conn = getattr(g, '_database', None)
    if conn is not None:
        conn.close()

@book_bp.route('/')
def book_page():
    db = get_db()
    cur = db.execute("SELECT id, title, description, image FROM recipes WHERE user_id=?", (TEST_USER_ID,))
    recipes = [dict(r) for r in cur.fetchall()]
    return render_template('book.html', recipes=recipes)


TEST_USER_ID = 1

@book_bp.route('/api/list')
def api_book_list():
    db = get_db()
    cur = db.execute("SELECT id, title, description, image FROM recipes WHERE user_id=?", (TEST_USER_ID,))
    return jsonify([dict(r) for r in cur.fetchall()])

@book_bp.route('/api/add', methods=['POST'])
def api_book_add():
    data = request.get_json() or {}
    title = (data.get('title') or '').strip()
    desc = (data.get('description') or '').strip()
    img = (data.get('image') or '').strip()
    if not title:
        return jsonify({'error': 'Title required'}), 400
    db = get_db()
    db.execute("INSERT INTO recipes (user_id, title, description, image) VALUES (?,?,?,?)",
               (TEST_USER_ID, title, desc, img))
    db.commit()
    return api_book_list()

@book_bp.route('/api/delete/<int:recipe_id>', methods=['DELETE'])
def api_book_delete(recipe_id):
    db = get_db()
    db.execute("DELETE FROM recipes WHERE id=? AND user_id=?", (recipe_id, TEST_USER_ID))
    db.commit()
    return jsonify({'ok': True})

@book_bp.route('/api/stats')
def api_book_stats():
    db = get_db()
    cur = db.execute("SELECT COUNT(*) AS count FROM recipes WHERE user_id=?", (TEST_USER_ID,))
    count = cur.fetchone()['count']
    return jsonify({'recipes_total': count})
