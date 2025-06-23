import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
from datetime import datetime, timezone
from passlib.context import CryptContext
from decimal import Decimal
from app.config.database import MONGO_URI

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

async def insert_sample_data():
    client = AsyncIOMotorClient(MONGO_URI)
    db = client["event_management_db"]

    # Reset counters
    await db.counters.delete_many({})
    await db.counters.insert_many([
        {"_id": "user_id", "seq": 0},
        {"_id": "event_id", "seq": 0},
        {"_id": "ticket_id", "seq": 0},
        {"_id": "order_id", "seq": 0},
        {"_id": "attendance_id", "seq": 0},
        {"_id": "order_item_id", "seq": 0},
        {"_id": "payment_id", "seq": 0}
    ])

    # Insert Users
    users = [
        {
            "UserID": await get_next_id(db, "user_id"),
            "FullName": "John Doe",
            "Email": "john@example.com",
            "Password": pwd_context.hash("pass123"),
            "Status": "active",
            "isAdmin": False,
            "CreatedAt": datetime.now(timezone.utc),
            "UpdatedAt": datetime.now(timezone.utc)
        },
        {
            "UserID": await get_next_id(db, "user_id"),
            "FullName": "Admin User",
            "Email": "admin@example.com",
            "Password": pwd_context.hash("admin123"),
            "Status": "active",
            "isAdmin": True,
            "CreatedAt": datetime.now(timezone.utc),
            "UpdatedAt": datetime.now(timezone.utc)
        }
    ]
    await db.users.delete_many({})
    await db.users.insert_many(users)

    # Insert Events
    events = [
        {
            "EventID": await get_next_id(db, "event_id"),
            "Title": "Music Concert",
            "Description": "A live music concert featuring top artists.",
            "Category": "Music",
            "Location": "Hanoi Arena",
            "Img": "https://example.com/concert.jpg",
            "StartTime": datetime(2025, 7, 1, 19, 0, tzinfo=timezone.utc),
            "EndTime": datetime(2025, 7, 1, 22, 0, tzinfo=timezone.utc),
            "Capacity": 1000,
            "Status": "published",
            "OrganizerID": 1,
            "CreatedAt": datetime.now(timezone.utc),
            "UpdatedAt": datetime.now(timezone.utc)
        }
    ]
    await db.events.delete_many({})
    await db.events.insert_many(events)

    # Insert Tickets
    tickets = [
        {
            "TicketID": await get_next_id(db, "ticket_id"),
            "EventID": 1,
            "Name": "VIP Ticket",
            "Price": Decimal("100.00"),
            "OnePer": 2,
            "QuantityTotal": 100,
            "QuantitySold": 0
        },
        {
            "TicketID": await get_next_id(db, "ticket_id"),
            "EventID": 1,
            "Name": "Standard Ticket",
            "Price": Decimal("50.00"),
            "OnePer": 4,
            "QuantityTotal": 500,
            "QuantitySold": 0
        }
    ]
    await db.tickets.delete_many({})
    await db.tickets.insert_many(tickets)

    # Insert Orders
    orders = [
        {
            "OrderID": await get_next_id(db, "order_id"),
            "UserID": 1,
            "OrderDate": datetime.now(timezone.utc),
            "Status": "pending",
            "TotalAmount": Decimal("150.00")
        }
    ]
    await db.orders.delete_many({})
    await db.orders.insert_many(orders)

    # Insert Attendances
    attendances = [
        {
            "AttendanceID": await get_next_id(db, "attendance_id"),
            "EventID": 1,
            "UserID": 1,
            "Status": "registered",
            "RegisteredAt": datetime.now(timezone.utc)
        }
    ]
    await db.attendances.delete_many({})
    await db.attendances.insert_many(attendances)

    # Insert Order Items
    order_items = [
        {
            "OrderItemID": await get_next_id(db, "order_item_id"),
            "OrderID": 1,
            "TicketID": 1,
            "Quantity": 1,
            "UnitPrice": Decimal("100.00")
        },
        {
            "OrderItemID": await get_next_id(db, "order_item_id"),
            "OrderID": 1,
            "TicketID": 2,
            "Quantity": 1,
            "UnitPrice": Decimal("50.00")
        }
    ]
    await db.order_items.delete_many({})
    await db.order_items.insert_many(order_items)

    # Insert Payments
    payments = [
        {
            "PaymentID": await get_next_id(db, "payment_id"),
            "OrderID": 1,
            "Method": "credit_card",
            "Status": "pending",
            "Amount": Decimal("150.00"),
            "PaidAt": datetime.now(timezone.utc)
        }
    ]
    await db.payments.delete_many({})
    await db.payments.insert_many(payments)

    print("Sample data inserted successfully!")
    client.close()

async def get_next_id(db, counter_id: str) -> int:
    counter = await db.counters.find_one_and_update(
        {"_id": counter_id},
        {"$inc": {"seq": 1}},
        upsert=True,
        return_document=True
    )
    return counter["seq"]

if __name__ == "__main__":
    asyncio.run(insert_sample_data())