from flask import Blueprint, render_template

main = Blueprint('main', __name__)

@main.route('/')
def index():
    # whatever you already have for feed
    return render_template('index.html')

"""
@main.route('/feed')
def feed():
    return render_template('index.html')
"""
@main.route('/fridge')
def fridge():
    return render_template('fridge.html')
