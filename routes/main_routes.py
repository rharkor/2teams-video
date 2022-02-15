from flask import Blueprint, render_template

main_routes = Blueprint('main_routes', __name__,
                        template_folder='templates',
                        static_folder='static')


@main_routes.route('/')
@main_routes.route('/index')
def index():
    return render_template('index.html')