from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
import psycopg2
import os 
from dotenv import load_dotenv

load_dotenv()

app= Flask(__name__)

DATABASE_URI = os.getenv('DATABASE_URI')

app.config['SQLALCHEMY_DATABASE_URI'] = DATABASE_URI

app.config['SQLALCHEMY']=False

# permite interactuar con la db 
db= SQLAlchemy(app)
ma= Marshmallow(app)

# Definición d ela tabla
class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(70), unique=True)
    description = db.Column(db.String(100))
    
    
    def __init__(self, title, description):
        self.title=title
        self.description=description
        
with app.app_context():
    db.create_all()


class TaskSchema(ma.Schema):
    class Meta:
        fields = ('id', 'title', 'description')
        
task_schema = TaskSchema()
tasks_schema = TaskSchema(many=True)


@app.route('/tasks', methods=['POST'])
def create_task():

    title=request.json['title']
    description=request.json['description']
    
    new_task =Task(title, description)
    db.session.add(new_task)
    db.session.commit()
    
    # return task_schema.jsonify({'message': 'Task created successfully {}'.format(new_task)}), 201
    return task_schema.jsonify(new_task)

@app.route('/tasks', methods=['GET'])
def get_tasks():
    all_task= Task.query.all()
    result = tasks_schema.dump(all_task)
    return jsonify(result)

@app.route('/tasks/<int:id>', methods=['GET'])
def get_task(id):
    task = Task.query.get(id)
    return task_schema.jsonify(task)

@app.route('/tasks/<int:id>', methods=['PUT'])
def update_task(id):
    task = Task.query.get(id)
    
    title = request.json['title']
    description = request.json['description']
    
    task.title = title
    task.description = description
    
    db.session.commit()
    return task_schema.jsonify(task)

@app.route('/tasks/<int:id>', methods=['DELETE'])
def delete_task(id):
    task = Task.query.get(id)
    
    db.session.delete(task)
    db.session.commit()
    
    return task_schema.jsonify(task)

@app.route('/')
def index():
    return '<h1>Hello</h1>'
if __name__ == '__main__':
    app.run(debug=True)