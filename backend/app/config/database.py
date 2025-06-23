from motor.motor_asyncio import AsyncIOMotorClient
from pymongo import ASCENDING
from pymongo.errors import DuplicateKeyError
from dotenv import load_dotenv
import os

load_dotenv()
MONGO_URI = os.getenv("MONGO_URI")
SECRET_KEY = os.getenv("SECRET_KEY")

client = AsyncIOMotorClient(MONGO_URI)
db = client["event_management_db"]

async def setup_indexes():
    try:
        # Xóa tài liệu có email: null
        await db.users.delete_many({"email": None})
        
        # Tạo index duy nhất trên email
        await db.users.create_index([("email", ASCENDING)], unique=True)
        
        # Tạo các index cho events
        await db.events.create_index([("start_time", ASCENDING)])
        await db.events.create_index([("category", ASCENDING)])
        await db.events.create_index([("location.coordinates", "2dsphere")])
        
        # Tạo các index cho tickets
        await db.tickets.create_index([("TicketID", ASCENDING)], unique=True)
        await db.tickets.create_index([("EventID", ASCENDING)])
        
        # Tạo các index cho payments
        await db.payments.create_index([("order_id", ASCENDING)])
        await db.payments.create_index([("transaction_id", ASCENDING)])
        
    except DuplicateKeyError as e:
        print(f"Index already exists or duplicate key error: {e}")

async def get_db():
    await setup_indexes()
    return db