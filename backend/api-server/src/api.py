from flask import Flask
from os import environ
from endpoints.messenger import messenger
from endpoints.game import game

app = Flask(__name__)
app.config['REDIS_URL'] = environ.get('REDIS_URL')

app.register_blueprint(messenger, url_prefix='/messenger/')
app.register_blueprint(game, url_prefix='/game/')

if __name__ == '__main__':
    app.run(environ.get('SERVER_HOST', '0.0.0.0'), environ.get('SERVER_PORT', 80))
