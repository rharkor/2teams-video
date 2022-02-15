from flask import Flask

# Global website
app = Flask(__name__)


# Configure the routes blueprint
from routes.main_routes import main_routes
app.register_blueprint(main_routes, url_prefix='/2teams')

app.run()