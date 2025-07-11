from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1 import users, events, tickets, orders, attendances, order_items, payments, auth
from app.config.database import get_db

app = FastAPI(title="Event Management API")

# Add CORS middleware for web browsers
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins for development
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(users.router)
app.include_router(events.router)
app.include_router(tickets.router)
app.include_router(orders.router)
app.include_router(attendances.router)
app.include_router(order_items.router)
app.include_router(payments.router)

@app.get("/")
async def root():
    return {"message": "Event Management API is running"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

@app.get("/test-db")
async def test_db(db=Depends(get_db)):
    collections = await db.list_collection_names()
    return {"collections": collections}