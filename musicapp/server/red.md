### pip install SQLAlchemy : virture env

### Python 3.8.10 : python -m uvicorn main:app --reload or python -m uvicorn main:app --host 0.0.0.0 --port 5000 


```
musicapp/
├── server/
│   ├── __init__.py
│   ├── main.py
│   ├── models/
│   │   ├── __init__.py
│   │   └── base.py
│   ├── routes/
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   └── song.py
│   ├── middleware/
│   ├── database/
│   │   └── engine.py

```