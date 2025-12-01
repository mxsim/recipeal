import sqlite3
from flask import Blueprint, current_app, g, render_template, request, jsonify

fridge_bp = Blueprint('fridge', __name__, url_prefix='/fridge')

# --- DB helper ---
def get_db():
    db_path = current_app.config['DATABASE']
    conn = getattr(g, '_database', None)
    if conn is None:
        conn = g._database = sqlite3.connect(db_path)
        conn.row_factory = sqlite3.Row
    return conn

@fridge_bp.teardown_request
def close_connection(exception):
    conn = getattr(g, '_database', None)
    if conn is not None:
        conn.close()

# --- Pages ---
@fridge_bp.route('/')
def fridge_page():
    return render_template('fridge.html')


# --- API endpoints for Fridge functionality ---
TEST_USER_ID = 1

@fridge_bp.route('/api/ingredients')
def api_ingredients():
    q = request.args.get('query', '').strip()
    if not q:
        return jsonify([])
    db = get_db()
    cur = db.execute("SELECT id, name FROM ingredients WHERE name LIKE ? ORDER BY name LIMIT 5", (f"%{q}%",))
    return jsonify([dict(r) for r in cur.fetchall()])


@fridge_bp.route('/api/items', methods=['GET'])
def api_fridge_get():
    db = get_db()
    cur = db.execute("""
        SELECT f.id as fridge_id, i.id as ingredient_id, i.name, i.calories, i.proteins, i.fats, i.carbs,
               f.amount, f.unit
        FROM fridges f
        JOIN ingredients i ON f.ingredient_id = i.id
        WHERE f.user_id = ?
    """, (TEST_USER_ID,))
    return jsonify([dict(r) for r in cur.fetchall()])


@fridge_bp.route('/api/add', methods=['POST'])
def api_fridge_add():
    data = request.get_json() or {}
    name = (data.get('name') or '').strip()
    amount = data.get('amount')
    unit = (data.get('unit') or 'pcs').strip()
    if not name or amount is None:
        return jsonify({'error':'name and amount required'}),400

    db = get_db()
    cur = db.execute("SELECT id FROM ingredients WHERE LOWER(name)=LOWER(?)", (name,))
    found = cur.fetchone()
    if found:
        ingredient_id = found['id']
    else:
        cur2 = db.execute("INSERT INTO ingredients (name) VALUES (?)", (name,))
        db.commit()
        ingredient_id = cur2.lastrowid

    db.execute("INSERT INTO fridges (user_id, ingredient_id, amount, unit) VALUES (?,?,?,?)",
               (TEST_USER_ID, ingredient_id, amount, unit))
    db.commit()
    return api_fridge_get()


@fridge_bp.route('/api/remove/<int:fridge_id>', methods=['DELETE'])
def api_fridge_remove(fridge_id):
    db = get_db()
    db.execute("DELETE FROM fridges WHERE id=?", (fridge_id,))
    db.commit()
    return jsonify({'ok': True})


@fridge_bp.route('/api/summary', methods=['GET'])
def api_fridge_summary():
    db = get_db()
    cur = db.execute("""
        SELECT f.id as fridge_id, i.name, i.calories, i.proteins, i.fats, i.carbs, f.amount, f.unit
        FROM fridges f
        JOIN ingredients i ON f.ingredient_id = i.id
        WHERE f.user_id = ?
    """, (TEST_USER_ID,))
    rows = [dict(r) for r in cur.fetchall()]

    total = {'calories':0,'proteins':0,'fats':0,'carbs':0}

    def estimate_grams(name, amount, unit):
        try: amt=float(amount)
        except: return 0
        if unit in ('g','gram','grams'): return amt
        if unit in ('ml','milliliter','milliliters'): return amt
        if unit in ('pcs','piece','pieces'):
            mapping = {'egg':50,'eggs':50,'banana':118,'apple':182,'onion':110,'tomato':123,'potato':213,'bread':30,'slice bread':30}
            lname=name.lower()
            for k,v in mapping.items(): 
                if k in lname: return v*amt
            return 100*amt
        return amt

    for r in rows:
        factor = estimate_grams(r['name'],r['amount'],r['unit'])/100
        total['calories'] += (r.get('calories') or 0)*factor
        total['proteins'] += (r.get('proteins') or 0)*factor
        total['fats'] += (r.get('fats') or 0)*factor
        total['carbs'] += (r.get('carbs') or 0)*factor

    for k in total: total[k]=round(total[k],2)
    return jsonify({'totals': total, 'items': rows})
