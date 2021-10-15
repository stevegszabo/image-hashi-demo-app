import logging

from flask import Flask, jsonify, request
from gevent import monkey
monkey.patch_all(thread=False)
import os
from flask_cors import CORS
import psycopg2
from psycopg2.extras import RealDictCursor
from flask_socketio import SocketIO

app = Flask(__name__)
app.logger.setLevel(logging.DEBUG)

app.secret_key = "super secret key"
socketio = SocketIO(app)
CORS(app)
thread = None

pghost = os.environ.get('POSTGRES_HOST')
pguser = os.environ.get('POSTGRES_USER')
pgpass = os.environ.get('POSTGRES_PASSWORD')
pgport = os.environ.get('POSTGRES_PORT')
pgdb = os.environ.get('POSTGRES_DATABASE')


@app.route("/api/post", methods=["POST"])
def insert_post():
    req = request.get_json()
    _title = req['title']
    _text = req['text']
    conn = psycopg2.connect(f"host={pghost} port={pgport} dbname={pgdb} user={pguser} password={pgpass}")
    cur = conn.cursor()
    cur.execute("INSERT INTO textData (title, text) VALUES (%s, %s)", (_title, _text))
    conn.commit()
    print("Data push happening now")
    cur = conn.cursor(cursor_factory=RealDictCursor)
    data = cur.execute('SELECT * FROM textData ORDER BY id DESC')
    test = cur.fetchall()
    print(test)
    socketio.emit('my event', test)
    app.logger.info("/api/post")
    return request.data

@app.route("/api/posts", methods=["GET"])
def get_posts():
    conn = psycopg2.connect(f"host={pghost} port={pgport} dbname={pgdb} user={pguser} password={pgpass}")
    cur = conn.cursor(cursor_factory=RealDictCursor)
    data = cur.execute('SELECT * FROM textData ORDER BY id DESC')
    test = cur.fetchall()
    app.logger.info("/api/posts")
    return jsonify(test)

@app.route("/api/health", methods=["GET"])
def get_health():
    stats = "{'status':'completed','platform':'healthy'}"
    socketio.emit('health event', stats)
    app.logger.info("/api/health")
    return jsonify(stats)

@app.route("/api/probe", methods=["GET"])
def get_probe():
    stats = "{'status':'probed','platform':'violated'}"
    socketio.emit('probe event', stats)
    app.logger.info("/api/probe")
    return jsonify(stats)

@socketio.on('health event')
def handle_health(stats):
    print('received')
    return jsonify(stats)

@socketio.on('probe event')
def handle_probe(stats):
    print('received')
    return jsonify(stats)

@socketio.on('my event')
def handle_event(data):
    print('received')
    return jsonify(data)

@socketio.on('connected')
def handle_connect():
    while True:
        socketio.sleep(3)
        print('connected')

@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
    return response

if __name__ == "__main__":
    app.run(host='0.0.0.0',debug=True)
