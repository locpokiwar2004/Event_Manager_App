how to run backend ?

cd backend

python -m venv venv

.\venv\Scripts\activate

pip install -r requirements.txt

uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
