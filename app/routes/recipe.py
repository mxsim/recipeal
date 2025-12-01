import sqlite3
from flask import Blueprint, current_app, g, render_template, request, jsonify

recipe_bp = Blueprint('recipe', __name__, url_prefix='/recipe')

# --- DB helper ---
def get_db():
    db_path = current_app.config['DATABASE']
    conn = getattr(g, '_database', None)
    if conn is None:
        conn = g._database = sqlite3.connect(db_path)
        conn.row_factory = sqlite3.Row
    return conn

@recipe_bp.teardown_request
def close_connection(exception):
    conn = getattr(g, '_database', None)
    if conn is not None:
        conn.close()

# --- Single recipe page ---
@recipe_bp.route('/<int:recipe_id>')
def recipe_page(recipe_id):
    db = get_db()
    # Recipe info
    row = db.execute("SELECT * FROM recipes WHERE id=?", (recipe_id,)).fetchone()
    if not row:
        return "Recipe not found", 404
    recipe = dict(row)

    # Nutrition calculation from ingredients
    nut = db.execute("""
        SELECT 
            SUM(ri.amount / 100.0 * i.calories) AS calories,
            SUM(ri.amount / 100.0 * i.proteins) AS proteins,
            SUM(ri.amount / 100.0 * i.fats) AS fats,
            SUM(ri.amount / 100.0 * i.carbs) AS carbs
        FROM recipe_ingredients ri
        JOIN ingredients i ON ri.ingredient_id = i.id
        WHERE ri.recipe_id=?
    """, (recipe_id,)).fetchone()
    recipe['nutrition'] = {k: nut[k] or 0 for k in nut.keys()}

    # Load ingredients for the recipe
    ingredients = db.execute("""
        SELECT i.name, ri.amount, ri.unit
        FROM recipe_ingredients ri
        JOIN ingredients i ON ri.ingredient_id = i.id
        WHERE ri.recipe_id=?
    """, (recipe_id,)).fetchall()

    recipe['ingredients'] = [
        {
            'name': row['name'],
            'amount': row['amount'],
            'unit': row['unit']
        } for row in ingredients
    ]


    # Load user
    user = db.execute("SELECT id, display_name FROM users WHERE id=?", (recipe['user_id'],)).fetchone()
    recipe['user'] = dict(user) if user else {'id': 0, 'display_name': 'Unknown'}

    # Load comments
    comments = []
    rows = db.execute("""
        SELECT c.id, c.content, u.id AS user_id, u.display_name
        FROM comments c
        JOIN users u ON c.user_id = u.id
        WHERE c.recipe_id=?
        ORDER BY c.id ASC
    """, (recipe_id,)).fetchall()
    for c in rows:
        comments.append({
            'id': c['id'],
            'content': c['content'],
            'user': {'id': c['user_id'], 'display_name': c['display_name']}
        })

    # Current user (mock, replace with login session)
    current_user = {'id': 1, 'display_name': 'Test User'}

    return render_template("recipe.html", recipe=recipe, comments=comments, current_user=current_user)

# --- Comments API ---
@recipe_bp.route('/<int:recipe_id>/add_comment', methods=['POST'])
def add_comment(recipe_id):
    db = get_db()
    data = request.get_json() or {}
    content = (data.get('content') or '').strip()
    user_id = data.get('user_id', 1)
    if not content:
        return jsonify({'error': 'Content required'}), 400
    cur = db.execute("INSERT INTO comments (recipe_id, user_id, content) VALUES (?,?,?)",
                     (recipe_id, user_id, content))
    db.commit()
    comment_id = cur.lastrowid
    user = db.execute("SELECT display_name FROM users WHERE id=?", (user_id,)).fetchone()
    return jsonify({
        'comment_id': comment_id,
        'content': content,
        'user': {'display_name': user['display_name']}
    })

@recipe_bp.route('/<int:recipe_id>/delete_comment/<int:comment_id>', methods=['DELETE'])
def delete_comment(recipe_id, comment_id):
    db = get_db()
    db.execute("DELETE FROM comments WHERE id=? AND recipe_id=?", (comment_id, recipe_id))
    db.commit()
    return jsonify({'ok': True})








# ==== create part===

@recipe_bp.route('/create')
def create_recipe_page():
    return render_template('create_recipe.html')
