import os
from flask import Flask
from app.routes.fridge import fridge_bp
from app.routes.recipe import recipe_bp
from app.routes.create_recipe import create_recipe_bp
from app.routes.feed import feed_bp
from app.routes.book import book_bp

def create_app():
    app = Flask(__name__, instance_relative_config=True)
    # ensure instance folder exists
    os.makedirs(app.instance_path, exist_ok=True)

    # path to your sqlite db (existing)
    app.config['DATABASE'] = os.path.join(app.instance_path, 'db.db')

    # register routes
    from app.routes.main_routes import main
    app.register_blueprint(main)


    app.register_blueprint(fridge_bp)
    app.register_blueprint(recipe_bp)
    app.register_blueprint(create_recipe_bp)
    app.register_blueprint(feed_bp)
    app.register_blueprint(book_bp)


    return app
