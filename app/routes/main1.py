from flask import Blueprint, render_template, request
from app.models import Recipe

main_bp = Blueprint('main', __name__)

@main_bp.route('/')
def index():
    recipes = Recipe.query.all()
    return render_template('index.html', recipes=recipes)

@main_bp.route('/search')
def search():
    query = request.args.get('q', '')
    if query:
        recipes = Recipe.query.filter(Recipe.title.contains(query)).all()
    else:
        recipes = Recipe.query.all()
    return render_template('index.html', recipes=recipes, query=query)

@main_bp.route('/kitchen')
def kitchen():
    return "Kitchen page - coming soon!"

@main_bp.route('/fridge')
def fridge():
    return "Fridge page - coming soon!"

@main_bp.route('/chefs')
def chefs():
    return "Chefs page - coming soon!"

@main_bp.route('/recipe/<int:recipe_id>')
def recipe_detail(recipe_id):
    recipe = Recipe.query.get_or_404(recipe_id)
    return f"Recipe detail for: {recipe.title} - coming soon!"

@main_bp.route('/create-recipe')
def create_recipe():
    return "Create recipe page - coming soon!"