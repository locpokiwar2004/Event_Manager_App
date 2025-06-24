how to run backend ?

cd backend

.\venv\Scripts\activate
pip install -r requirements
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
