from fastapi import APIRouter, Depends, HTTPException
from motor.motor_asyncio import AsyncIOMotorDatabase
from app.models.ticket import TicketCreate, TicketResponse
from app.config.database import get_db
from decimal import Decimal
from datetime import datetime, timezone
import logging

# Thiết lập logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

router = APIRouter(prefix="/tickets", tags=["Tickets"])

async def get_next_ticket_id(db: AsyncIOMotorDatabase) -> int:
    counter = await db.counters.find_one_and_update(
        {"_id": "ticket_id"},
        {"$inc": {"seq": 1}},
        upsert=True,
        return_document=True
    )
    return counter["seq"]
def convert_decimals_to_float(obj):
    """Chuyển đổi tất cả giá trị Decimal trong dict thành float."""
    if isinstance(obj, dict):
        return {k: convert_decimals_to_float(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [convert_decimals_to_float(item) for item in obj]
    elif isinstance(obj, Decimal):
        return float(obj)
    return obj

@router.post("/", response_model=TicketResponse)
async def create_ticket(ticket: TicketCreate, db: AsyncIOMotorDatabase = Depends(get_db)):
    try:
        # Kiểm tra EventID tồn tại (nếu cần)
        event = await db.events.find_one({"EventID": ticket.EventID})
        if not event:
            logger.warning(f"Event not found: EventID {ticket.EventID}")
            raise HTTPException(status_code=404, detail="Event not found")
        
        # Tạo ticket mới
        ticket_dict = ticket.dict()
        ticket_dict["TicketID"] = await get_next_ticket_id(db)
        ticket_dict["CreatedAt"] = datetime.now(timezone.utc).isoformat()
        ticket_dict["UpdatedAt"] = datetime.now(timezone.utc).isoformat()
        
        # Chuyển đổi Decimal sang float
        ticket_dict = convert_decimals_to_float(ticket_dict)
        
        # Insert vào MongoDB
        result = await db.tickets.insert_one(ticket_dict)
        logger.info(f"Inserted ticket with ID: {result.inserted_id}, TicketID: {ticket_dict['TicketID']}")
        
        # Lấy ticket vừa tạo
        created_ticket = await db.tickets.find_one({"_id": result.inserted_id})
        if not created_ticket:
            logger.error("Failed to retrieve newly created ticket")
            raise HTTPException(status_code=500, detail="Failed to retrieve created ticket")
        
        return TicketResponse(**created_ticket)
    except Exception as e:
        logger.error(f"Error creating ticket: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error creating ticket: {str(e)}")

@router.get("/", response_model=list[TicketResponse])
async def get_tickets(db: AsyncIOMotorDatabase = Depends(get_db)):
    try:
        tickets = await db.tickets.find().to_list(100)
        logger.info(f"Retrieved {len(tickets)} tickets")
        return [TicketResponse(**ticket) for ticket in tickets]
    except Exception as e:
        logger.error(f"Error retrieving tickets: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error retrieving tickets: {str(e)}")