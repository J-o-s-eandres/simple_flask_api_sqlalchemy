```markdown
# Flask API with SQLAlchemy

This is a simple Flask API using SQLAlchemy to interact with a PostgreSQL database.

## Setup

1. Clone this repository.
2. Create a virtual environment:

```bash
python -m venv venv
```

3. Activate the virtual environment:

   - **Windows**:

```bash
venv\Scripts\activate
```

   - **Linux/macOS**:

```bash
source venv/bin/activate
```

4. Install dependencies:

```bash
pip install -r requirements.txt
```

5. Create a PostgreSQL database and set the connection URI in a `.env` file:

```
DATABASE_URI=your_database_uri_here
```

6. Run the Flask application:

```bash
python src/app.py
```

## Usage

### Endpoints

- `POST /tasks`: Create a new task.
- `GET /tasks`: Get all tasks.
- `GET /tasks/<id>`: Get a specific task by ID.
- `PUT /tasks/<id>`: Update a task by ID.
- `DELETE /tasks/<id>`: Delete a task by ID.

### Request/Response Examples

#### Create a Task

**Request:**

```json
POST /tasks
{
    "title": "Task Title",
    "description": "Task Description"
}
```

**Response:**

```json
{
    "id": 1,
    "title": "Task Title",
    "description": "Task Description"
}
```

#### Get All Tasks

**Request:**

```json
GET /tasks
```

**Response:**

```json
[
    {
        "id": 1,
        "title": "Task Title 1",
        "description": "Task Description 1"
    },
    {
        "id": 2,
        "title": "Task Title 2",
        "description": "Task Description 2"
    }
]
```

#### Get a Specific Task

**Request:**

```json
GET /tasks/1
```

**Response:**

```json
{
    "id": 1,
    "title": "Task Title 1",
    "description": "Task Description 1"
}
```

#### Update a Task

**Request:**

```json
PUT /tasks/1
{
    "title": "Updated Task Title",
    "description": "Updated Task Description"
}
```

**Response:**

```json
{
    "id": 1,
    "title": "Updated Task Title",
    "description": "Updated Task Description"
}
```

#### Delete a Task

**Request:**

```json
DELETE /tasks/1
```

**Response:**

```json
{
    "id": 1,
    "title": "Updated Task Title",
    "description": "Updated Task Description"
}
```

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
```
