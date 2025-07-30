from fastapi import APIRouter, Depends, HTTPException, Query
from motor.motor_asyncio import AsyncIOMotorDatabase
from app.models.event import EventCreate, EventUpdate, EventResponse, EventStatus, EventWithOrganizer, EventStatusUpdate, EventWithTicketsUpdate, EventWithTicketsResponse, TicketUpdateData
from app.models.ticket import TicketResponse
from app.config.database import get_db
from datetime import datetime, timezone, timedelta
from typing import List, Optional
import calendar

router = APIRouter(prefix="/events", tags=["Events"])

async def get_next_event_id(db: AsyncIOMotorDatabase) -> int:
    counter = await db.counters.find_one_and_update(
        {"_id": "event_id"},
        {"$inc": {"seq": 1}},
        upsert=True,
        return_document=True
    )
    return counter["seq"]

@router.post("/", response_model=EventResponse)
async def create_event(event: EventCreate, db: AsyncIOMotorDatabase = Depends(get_db)):
    event_id = await get_next_event_id(db)
    event_dict = event.dict()
    event_dict["EventID"] = event_id
    event_dict["Status"] = EventStatus.DRAFT
    event_dict["CreatedAt"] = datetime.now(timezone.utc)
    event_dict["UpdatedAt"] = datetime.now(timezone.utc)
    await db.events.insert_one(event_dict)
    return EventResponse(**event_dict)   

@router.get("/", response_model=List[EventResponse])
async def get_events(db: AsyncIOMotorDatabase = Depends(get_db)):
    events = await db.events.find().to_list(100)
    return [EventResponse(**event) for event in events]

@router.get("/hot", response_model=List[EventResponse])
async def get_hot_events(
    limit: int = Query(default=10, ge=1, le=50),
    db: AsyncIOMotorDatabase = Depends(get_db)
):
    """Get hot events (events with high capacity and published status)"""
    pipeline = [
        # Lọc events đã published và chưa kết thúc
        {
            "$match": {
                "Status": EventStatus.PUBLISHED,
                "EndTime": {"$gte": datetime.now(timezone.utc)}
            }
        },
        # Sắp xếp theo capacity (high capacity = hot) và StartTime
        {
            "$sort": {
                "Capacity": -1,  # Capacity cao nhất trước
                "StartTime": 1   # Event sớm nhất trong các event có capacity cao
            }
        },
        # Giới hạn số lượng kết quả
        {"$limit": limit}
    ]
    
    hot_events = await db.events.aggregate(pipeline).to_list(limit)
    return [EventResponse(**event) for event in hot_events]

@router.get("/monthly", response_model=List[EventResponse])
async def get_events_by_month(
    year: int = Query(..., ge=2020, le=2030),
    month: int = Query(..., ge=1, le=12),
    status: Optional[EventStatus] = Query(None),
    category: Optional[str] = Query(None),
    db: AsyncIOMotorDatabase = Depends(get_db)
):
    """Get all events in a specific month"""
    # Tính toán ngày đầu và cuối tháng
    first_day = datetime(year, month, 1, tzinfo=timezone.utc)
    if month == 12:
        last_day = datetime(year + 1, 1, 1, tzinfo=timezone.utc) - timedelta(seconds=1)
    else:
        last_day = datetime(year, month + 1, 1, tzinfo=timezone.utc) - timedelta(seconds=1)
    
    # Tạo query filter
    filter_query = {
        "$or": [
            # Events bắt đầu trong tháng
            {
                "StartTime": {
                    "$gte": first_day,
                    "$lte": last_day
                }
            },
            # Events kết thúc trong tháng
            {
                "EndTime": {
                    "$gte": first_day,
                    "$lte": last_day
                }
            },
            # Events kéo dài qua tháng (bắt đầu trước và kết thúc sau)
            {
                "StartTime": {"$lt": first_day},
                "EndTime": {"$gt": last_day}
            }
        ]
    }
    
    # Thêm filter theo status nếu có
    if status:
        filter_query["Status"] = status
    
    # Thêm filter theo category nếu có
    if category:
        filter_query["Category"] = {"$regex": category, "$options": "i"}
    
    # Lấy events và sắp xếp theo StartTime
    events = await db.events.find(filter_query).sort("StartTime", 1).to_list(100)
    return [EventResponse(**event) for event in events]
@router.get("/upcoming", response_model=List[EventResponse])
async def get_upcoming_events(
    days: int = Query(default=7, ge=1, le=30),
    limit: int = Query(default=20, ge=1, le=100),
    category: Optional[str] = Query(None),
    db: AsyncIOMotorDatabase = Depends(get_db)
):
    """Get upcoming events in the next N days"""
    now = datetime.now(timezone.utc)
    end_date = now + timedelta(days=days)
    
    filter_query = {
        "Status": EventStatus.PUBLISHED,
        "StartTime": {
            "$gte": now,
            "$lte": end_date
        }
    }
    if category:
        filter_query["Category"] = {"$regex": category, "$options": "i"}
    
    events = await db.events.find(filter_query).sort("StartTime", 1).limit(limit).to_list(limit)
    return [EventResponse(**event) for event in events]

@router.get("/search", response_model=List[EventResponse])
async def search_events(
    query: Optional[str] = Query(None, description="Search text for title or description"),
    category: Optional[str] = Query(None, description="Filter by category"),
    location: Optional[str] = Query(None, description="Filter by location"),
    status: Optional[EventStatus] = Query(None, description="Filter by status"),
    date_from: Optional[str] = Query(None, description="Start date (YYYY-MM-DD)"),
    date_to: Optional[str] = Query(None, description="End date (YYYY-MM-DD)"),
    min_price: Optional[float] = Query(None, description="Minimum price"),
    max_price: Optional[float] = Query(None, description="Maximum price"),
    limit: int = Query(default=50, ge=1, le=100),
    offset: int = Query(default=0, ge=0),
    db: AsyncIOMotorDatabase = Depends(get_db)
):
    """Search events by title, description, category, or location"""
    filter_query = {}
    
    # Text search in title and description
    if query and query.strip():
        filter_query["$or"] = [
            {"Title": {"$regex": query.strip(), "$options": "i"}},
            {"Description": {"$regex": query.strip(), "$options": "i"}}
        ]
    
    # Category filter
    if category and category.strip():
        filter_query["Category"] = {"$regex": f"^{category.strip()}$", "$options": "i"}
    
    # Location filter
    if location and location.strip():
        filter_query["Location"] = {"$regex": location.strip(), "$options": "i"}
    
    # Status filter
    if status:
        filter_query["Status"] = status
    
    # Date range filter
    if date_from or date_to:
        date_filter = {}
        if date_from:
            try:
                from_date = datetime.strptime(date_from, "%Y-%m-%d")
                date_filter["$gte"] = from_date
            except ValueError:
                raise HTTPException(status_code=400, detail="Invalid date_from format. Use YYYY-MM-DD")
        
        if date_to:
            try:
                to_date = datetime.strptime(date_to, "%Y-%m-%d")
                # Add 23:59:59 to include the entire end date
                to_date = to_date.replace(hour=23, minute=59, second=59)
                date_filter["$lte"] = to_date
            except ValueError:
                raise HTTPException(status_code=400, detail="Invalid date_to format. Use YYYY-MM-DD")
        
        filter_query["StartTime"] = date_filter
    
    # Price range filter (assuming Price field exists)
    if min_price is not None or max_price is not None:
        price_filter = {}
        if min_price is not None:
            price_filter["$gte"] = min_price
        if max_price is not None:
            price_filter["$lte"] = max_price
        filter_query["Price"] = price_filter
    
    # Execute query with pagination
    cursor = db.events.find(filter_query).skip(offset).limit(limit)
    events = await cursor.to_list(limit)
    
    return [EventResponse(**event) for event in events]

@router.get("/organizer/{organizer_id}")
async def get_events_by_organizer_simple(organizer_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    """Get all events created by a specific organizer - simple format"""
    events = []
    async for event in db.events.find({"OrganizerID": organizer_id}):
        events.append({
            "id": str(event["_id"]),
            "title": event["Title"],
            "description": event["Description"],
            "category": event["Category"],
            "location": event["Location"],
            "date": event["StartTime"].strftime("%Y-%m-%d"),
            "time": event["StartTime"].strftime("%H:%M"),
            "capacity": event["Capacity"],
            "price": event.get("Price", 0.0),
            "organizer_id": event["OrganizerID"],
            "created_at": event["CreatedAt"].isoformat() if event.get("CreatedAt") else None
        })
    return events

@router.get("/{event_id}", response_model=EventResponse)
async def get_event(event_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    event = await db.events.find_one({"EventID": event_id})
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    return EventResponse(**event)

@router.get("/{event_id}/with-tickets", response_model=EventWithTicketsResponse)
async def get_event_with_tickets(event_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    """Get event with all its tickets"""
    # Lấy event
    event = await db.events.find_one({"EventID": event_id})
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    
    # Lấy tất cả tickets của event
    tickets = await db.tickets.find({"EventID": event_id}).to_list(100)
    
    # Chuyển đổi tickets thành format phù hợp
    tickets_response = []
    for ticket in tickets:
        tickets_response.append({
            "TicketID": ticket["TicketID"],
            "Name": ticket["Name"],
            "Price": ticket["Price"],
            "OnePer": ticket["OnePer"],
            "QuantityTotal": ticket["QuantityTotal"],
            "QuantitySold": ticket.get("QuantitySold", 0)
        })
    
    event_response = EventResponse(**event)
    return EventWithTicketsResponse(**event_response.dict(), tickets=tickets_response)

@router.put("/{event_id}", response_model=EventResponse)
async def update_event(event_id: int, event_update: EventUpdate, db: AsyncIOMotorDatabase = Depends(get_db)):
    """Update basic event information"""
    # Kiểm tra event có tồn tại không
    existing_event = await db.events.find_one({"EventID": event_id})
    if not existing_event:
        raise HTTPException(status_code=404, detail="Event not found")
    
    # Tạo dictionary chỉ chứa các field không None
    update_dict = {k: v for k, v in event_update.dict().items() if v is not None}
    if not update_dict:
        raise HTTPException(status_code=400, detail="No fields to update")
    
    # Thêm timestamp cập nhật
    update_dict["UpdatedAt"] = datetime.now(timezone.utc)
    
    # Validation bổ sung
    if "StartTime" in update_dict and "EndTime" in update_dict:
        if update_dict["StartTime"] >= update_dict["EndTime"]:
            raise HTTPException(status_code=400, detail="Start time must be before end time")
    elif "StartTime" in update_dict:
        if update_dict["StartTime"] >= existing_event["EndTime"]:
            raise HTTPException(status_code=400, detail="Start time must be before existing end time")
    elif "EndTime" in update_dict:
        if existing_event["StartTime"] >= update_dict["EndTime"]:
            raise HTTPException(status_code=400, detail="End time must be after existing start time")
    
    # Cập nhật event
    result = await db.events.update_one(
        {"EventID": event_id},
        {"$set": update_dict}
    )
    
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Event not found")
    
    # Lấy event đã cập nhật
    updated_event = await db.events.find_one({"EventID": event_id})
    return EventResponse(**updated_event)

@router.put("/{event_id}/with-tickets", response_model=EventWithTicketsResponse)
async def update_event_with_tickets(
    event_id: int, 
    update_data: EventWithTicketsUpdate, 
    db: AsyncIOMotorDatabase = Depends(get_db)
):
    """Update event information along with its tickets"""
    # Kiểm tra event có tồn tại không
    existing_event = await db.events.find_one({"EventID": event_id})
    if not existing_event:
        raise HTTPException(status_code=404, detail="Event not found")
    
    # Bắt đầu transaction để đảm bảo tính nhất quán
    async with await db.client.start_session() as session:
        async with session.start_transaction():
            try:
                # Cập nhật thông tin event nếu có
                event_update_dict = {}
                for field in ["Title", "Description", "Category", "Location", "Img", "StartTime", "EndTime", "Capacity", "Status"]:
                    value = getattr(update_data, field, None)
                    if value is not None:
                        event_update_dict[field] = value
                
                if event_update_dict:
                    # Validation thời gian
                    if "StartTime" in event_update_dict and "EndTime" in event_update_dict:
                        if event_update_dict["StartTime"] >= event_update_dict["EndTime"]:
                            raise HTTPException(status_code=400, detail="Start time must be before end time")
                    elif "StartTime" in event_update_dict:
                        if event_update_dict["StartTime"] >= existing_event["EndTime"]:
                            raise HTTPException(status_code=400, detail="Start time must be before existing end time")
                    elif "EndTime" in event_update_dict:
                        if existing_event["StartTime"] >= event_update_dict["EndTime"]:
                            raise HTTPException(status_code=400, detail="End time must be after existing start time")
                    
                    event_update_dict["UpdatedAt"] = datetime.now(timezone.utc)
                    
                    await db.events.update_one(
                        {"EventID": event_id},
                        {"$set": event_update_dict},
                        session=session
                    )
                
                # Xử lý tickets nếu có
                updated_tickets = []
                if update_data.tickets is not None:
                    # Lấy ticket counter hiện tại
                    async def get_next_ticket_id():
                        counter = await db.counters.find_one_and_update(
                            {"_id": "ticket_id"},
                            {"$inc": {"seq": 1}},
                            upsert=True,
                            return_document=True,
                            session=session
                        )
                        return counter["seq"]
                    
                    for ticket_data in update_data.tickets:
                        if ticket_data.TicketID is None:
                            # Tạo ticket mới
                            ticket_id = await get_next_ticket_id()
                            new_ticket = {
                                "TicketID": ticket_id,
                                "EventID": event_id,
                                "Name": ticket_data.Name,
                                "Price": ticket_data.Price,
                                "OnePer": ticket_data.OnePer,
                                "QuantityTotal": ticket_data.QuantityTotal,
                                "QuantitySold": ticket_data.QuantitySold or 0
                            }
                            await db.tickets.insert_one(new_ticket, session=session)
                            updated_tickets.append(new_ticket)
                        else:
                            # Cập nhật ticket hiện có
                            existing_ticket = await db.tickets.find_one(
                                {"TicketID": ticket_data.TicketID, "EventID": event_id},
                                session=session
                            )
                            if not existing_ticket:
                                raise HTTPException(
                                    status_code=404, 
                                    detail=f"Ticket with ID {ticket_data.TicketID} not found for this event"
                                )
                            
                            # Validation: không được giảm QuantityTotal dưới QuantitySold
                            current_sold = existing_ticket.get("QuantitySold", 0)
                            if ticket_data.QuantityTotal < current_sold:
                                raise HTTPException(
                                    status_code=400,
                                    detail=f"Cannot reduce total quantity below sold quantity ({current_sold}) for ticket {ticket_data.TicketID}"
                                )
                            
                            ticket_update = {
                                "Name": ticket_data.Name,
                                "Price": ticket_data.Price,
                                "OnePer": ticket_data.OnePer,
                                "QuantityTotal": ticket_data.QuantityTotal
                            }
                            
                            # Chỉ cập nhật QuantitySold nếu được cung cấp và không vượt quá QuantityTotal
                            if ticket_data.QuantitySold is not None:
                                if ticket_data.QuantitySold > ticket_data.QuantityTotal:
                                    raise HTTPException(
                                        status_code=400,
                                        detail=f"Sold quantity cannot exceed total quantity for ticket {ticket_data.TicketID}"
                                    )
                                ticket_update["QuantitySold"] = ticket_data.QuantitySold
                            
                            await db.tickets.update_one(
                                {"TicketID": ticket_data.TicketID, "EventID": event_id},
                                {"$set": ticket_update},
                                session=session
                            )
                            
                            # Lấy ticket đã cập nhật
                            updated_ticket = await db.tickets.find_one(
                                {"TicketID": ticket_data.TicketID, "EventID": event_id},
                                session=session
                            )
                            updated_tickets.append(updated_ticket)
                
                # Lấy event và tickets cuối cùng
                final_event = await db.events.find_one({"EventID": event_id}, session=session)
                all_tickets = await db.tickets.find({"EventID": event_id}, session=session).to_list(100)
                
                # Chuyển đổi tickets thành format phù hợp
                tickets_response = []
                for ticket in all_tickets:
                    tickets_response.append({
                        "TicketID": ticket["TicketID"],
                        "Name": ticket["Name"],
                        "Price": ticket["Price"],
                        "OnePer": ticket["OnePer"],
                        "QuantityTotal": ticket["QuantityTotal"],
                        "QuantitySold": ticket.get("QuantitySold", 0)
                    })
                
                event_response = EventResponse(**final_event)
                return EventWithTicketsResponse(**event_response.dict(), tickets=tickets_response)
                
            except Exception as e:
                await session.abort_transaction()
                if isinstance(e, HTTPException):
                    raise e
                raise HTTPException(status_code=500, detail=f"Failed to update event with tickets: {str(e)}")

@router.delete("/tickets/{ticket_id}")
async def delete_ticket(ticket_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    """Delete a specific ticket"""
    # Kiểm tra ticket có tồn tại không
    ticket = await db.tickets.find_one({"TicketID": ticket_id})
    if not ticket:
        raise HTTPException(status_code=404, detail="Ticket not found")
    
    # Kiểm tra ticket đã được bán chưa
    if ticket.get("QuantitySold", 0) > 0:
        raise HTTPException(
            status_code=400, 
            detail="Cannot delete ticket that has already been sold"
        )
    
    # Xóa ticket
    result = await db.tickets.delete_one({"TicketID": ticket_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Ticket not found")
    
    return {"message": "Ticket deleted successfully"}

@router.delete("/{event_id}")
async def delete_event(event_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    result = await db.events.delete_one({"EventID": event_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Event not found")
    return {"message": "Event deleted"}

@router.get("/{event_id}/tickets", response_model=List[TicketResponse])
async def get_event_tickets(event_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    """Get all tickets for a specific event"""
    # Kiểm tra event có tồn tại không
    event = await db.events.find_one({"EventID": event_id})
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    
    # Lấy tất cả tickets của event
    tickets = await db.tickets.find({"EventID": event_id}).to_list(100)
    
    # Đảm bảo tất cả tickets có trường QuantitySold
    processed_tickets = []
    for ticket in tickets:
        if "QuantitySold" not in ticket:
            ticket["QuantitySold"] = 0
        processed_tickets.append(ticket)
    
    return [TicketResponse(**ticket) for ticket in processed_tickets]

@router.post("/{event_id}/tickets", response_model=TicketResponse)
async def create_event_ticket(
    event_id: int, 
    ticket_data: TicketUpdateData, 
    db: AsyncIOMotorDatabase = Depends(get_db)
):
    """Create a new ticket for an event"""
    # Kiểm tra event có tồn tại không
    event = await db.events.find_one({"EventID": event_id})
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    
    # Tạo ticket ID mới
    async def get_next_ticket_id():
        counter = await db.counters.find_one_and_update(
            {"_id": "ticket_id"},
            {"$inc": {"seq": 1}},
            upsert=True,
            return_document=True
        )
        return counter["seq"]
    
    ticket_id = await get_next_ticket_id()
    
    # Tạo ticket mới
    new_ticket = {
        "TicketID": ticket_id,
        "EventID": event_id,
        "Name": ticket_data.Name,
        "Price": ticket_data.Price,
        "OnePer": ticket_data.OnePer,
        "QuantityTotal": ticket_data.QuantityTotal,
        "QuantitySold": ticket_data.QuantitySold or 0
    }
    
    # Validation
    if new_ticket["QuantitySold"] > new_ticket["QuantityTotal"]:
        raise HTTPException(
            status_code=400,
            detail="Sold quantity cannot exceed total quantity"
        )
    
    await db.tickets.insert_one(new_ticket)
    return TicketResponse(**new_ticket)

@router.put("/tickets/{ticket_id}", response_model=TicketResponse)
async def update_ticket(
    ticket_id: int, 
    ticket_update: TicketUpdateData, 
    db: AsyncIOMotorDatabase = Depends(get_db)
):
    """Update a specific ticket"""
    # Kiểm tra ticket có tồn tại không
    existing_ticket = await db.tickets.find_one({"TicketID": ticket_id})
    if not existing_ticket:
        raise HTTPException(status_code=404, detail="Ticket not found")
    
    # Validation: không được giảm QuantityTotal dưới QuantitySold
    current_sold = existing_ticket.get("QuantitySold", 0)
    if ticket_update.QuantityTotal < current_sold:
        raise HTTPException(
            status_code=400,
            detail=f"Cannot reduce total quantity below sold quantity ({current_sold})"
        )
    
    # Tạo update dictionary
    ticket_update_dict = {
        "Name": ticket_update.Name,
        "Price": ticket_update.Price,
        "OnePer": ticket_update.OnePer,
        "QuantityTotal": ticket_update.QuantityTotal
    }
    
    # Chỉ cập nhật QuantitySold nếu được cung cấp và hợp lệ
    if ticket_update.QuantitySold is not None:
        if ticket_update.QuantitySold > ticket_update.QuantityTotal:
            raise HTTPException(
                status_code=400,
                detail="Sold quantity cannot exceed total quantity"
            )
        ticket_update_dict["QuantitySold"] = ticket_update.QuantitySold
    
    # Cập nhật ticket
    result = await db.tickets.update_one(
        {"TicketID": ticket_id},
        {"$set": ticket_update_dict}
    )
    
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Ticket not found")
    
    # Lấy ticket đã cập nhật
    updated_ticket = await db.tickets.find_one({"TicketID": ticket_id})
    return TicketResponse(**updated_ticket)

@router.get("/{event_id}/with-organizer", response_model=EventWithOrganizer)
async def get_event_with_organizer(event_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    """Get event with organizer information"""
    # Lấy event
    event = await db.events.find_one({"EventID": event_id})
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    
    # Lấy thông tin organizer
    organizer = await db.users.find_one({"UserID": event["OrganizerID"]})
    if not organizer:
        raise HTTPException(status_code=404, detail="Organizer not found")
    
    # Tạo response
    event_data = EventResponse(**event)
    organizer_data = {
        "UserID": organizer["UserID"],
        "FullName": organizer["FullName"],
        "email": organizer["email"],
        "Phone": organizer.get("Phone"),
        "Address": organizer.get("Address")
    }
    
    return EventWithOrganizer(**event_data.dict(), Organizer=organizer_data)

@router.patch("/{event_id}/status", response_model=EventResponse)
async def update_event_status(
    event_id: int, 
    status_update: EventStatusUpdate, 
    db: AsyncIOMotorDatabase = Depends(get_db)
):
    """Update event status (draft -> published, published -> cancelled, etc.)"""
    # Kiểm tra event có tồn tại không
    event = await db.events.find_one({"EventID": event_id})
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    
    # Validation logic
    current_status = event.get("Status")
    new_status = status_update.Status
    
    # Kiểm tra transition hợp lệ
    valid_transitions = {
        EventStatus.DRAFT: [EventStatus.PUBLISHED, EventStatus.CANCELLED],
        EventStatus.PUBLISHED: [EventStatus.CANCELLED],
        EventStatus.CANCELLED: []  # Không thể thay đổi từ cancelled
    }
    
    if new_status not in valid_transitions.get(current_status, []):
        raise HTTPException(
            status_code=400, 
            detail=f"Cannot change status from {current_status} to {new_status}"
        )
    
    # Cập nhật status
    update_data = {
        "Status": new_status,
        "UpdatedAt": datetime.now(timezone.utc)
    }
    
    result = await db.events.update_one(
        {"EventID": event_id},
        {"$set": update_data}
    )
    
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Event not found")
    
    # Trả về event đã cập nhật
    updated_event = await db.events.find_one({"EventID": event_id})
    return EventResponse(**updated_event)

@router.get("/by-organizer/{organizer_id}", response_model=List[EventResponse])
async def get_events_by_organizer(
    organizer_id: int,
    status: Optional[EventStatus] = Query(None),
    limit: int = Query(default=50, ge=1, le=100),
    db: AsyncIOMotorDatabase = Depends(get_db)
):
    """Get all events by a specific organizer"""
    # Kiểm tra organizer có tồn tại không
    organizer = await db.users.find_one({"UserID": organizer_id})
    if not organizer:
        raise HTTPException(status_code=404, detail="Organizer not found")
    
    # Tạo filter
    filter_query = {"OrganizerID": organizer_id}
    if status:
        filter_query["Status"] = status
    
    # Lấy events
    events = await db.events.find(filter_query).sort("CreatedAt", -1).limit(limit).to_list(limit)
    return [EventResponse(**event) for event in events]

@router.post("/bulk-publish")
async def bulk_publish_events(
    event_ids: List[int],
    db: AsyncIOMotorDatabase = Depends(get_db)
):
    """Publish multiple events at once"""
    if not event_ids:
        raise HTTPException(status_code=400, detail="No event IDs provided")
    
    # Kiểm tra tất cả events có tồn tại và có status draft không
    events = await db.events.find({"EventID": {"$in": event_ids}}).to_list(len(event_ids))
    
    if len(events) != len(event_ids):
        raise HTTPException(status_code=404, detail="Some events not found")
    
    # Kiểm tra status
    non_draft_events = [e for e in events if e.get("Status") != EventStatus.DRAFT]
    if non_draft_events:
        non_draft_ids = [e["EventID"] for e in non_draft_events]
        raise HTTPException(
            status_code=400, 
            detail=f"Events {non_draft_ids} are not in draft status"
        )
    
    # Cập nhật tất cả events
    result = await db.events.update_many(
        {"EventID": {"$in": event_ids}},
        {
            "$set": {
                "Status": EventStatus.PUBLISHED,
                "UpdatedAt": datetime.now(timezone.utc)
            }
        }
    )
    
    return {
        "message": f"Successfully published {result.modified_count} events",
        "published_event_ids": event_ids
    }

@router.put("/simple/{event_id}")
async def update_event_simple(event_id: str, event_data: dict, db: AsyncIOMotorDatabase = Depends(get_db)):
    """Update an existing event with simple data format"""
    try:
        from bson import ObjectId
        
        if not ObjectId.is_valid(event_id):
            raise HTTPException(status_code=400, detail="Invalid event ID format")
            
        # Parse datetime if provided
        if 'date' in event_data and 'time' in event_data:
            event_datetime = datetime.strptime(f"{event_data['date']} {event_data['time']}", "%Y-%m-%d %H:%M")
            event_data['StartTime'] = event_datetime
            event_data['EndTime'] = event_datetime + timedelta(hours=2)  # Default 2 hours
            # Remove the original date/time fields
            del event_data['date']
            del event_data['time']
        
        # Convert field names to match database schema
        update_data = {}
        field_mapping = {
            'title': 'Title',
            'description': 'Description',
            'category': 'Category',
            'location': 'Location',
            'capacity': 'Capacity',
            'price': 'Price',
            'organizer_id': 'OrganizerID'
        }
        
        for key, value in event_data.items():
            if key in field_mapping:
                update_data[field_mapping[key]] = value
            elif key in ['StartTime', 'EndTime']:
                update_data[key] = value
                
        update_data['UpdatedAt'] = datetime.now(timezone.utc)
        
        result = await db.events.update_one(
            {"_id": ObjectId(event_id)},
            {"$set": update_data}
        )
        
        if result.matched_count == 0:
            raise HTTPException(status_code=404, detail="Event not found")
        
        # Get updated event
        updated_event = await db.events.find_one({"_id": ObjectId(event_id)})
        
        return {
            "id": str(updated_event["_id"]),
            "title": updated_event["Title"],
            "description": updated_event["Description"],
            "category": updated_event["Category"],
            "location": updated_event["Location"],
            "date": updated_event["StartTime"].strftime("%Y-%m-%d"),
            "time": updated_event["StartTime"].strftime("%H:%M"),
            "capacity": updated_event["Capacity"],
            "price": updated_event.get("Price", 0.0),
            "organizer_id": updated_event["OrganizerID"],
            "created_at": updated_event["CreatedAt"].isoformat() if updated_event.get("CreatedAt") else None
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to update event: {str(e)}")

@router.delete("/simple/{event_id}")
async def delete_event_simple(event_id: str, db: AsyncIOMotorDatabase = Depends(get_db)):
    """Delete an event"""
    try:
        from bson import ObjectId
        
        if not ObjectId.is_valid(event_id):
            raise HTTPException(status_code=400, detail="Invalid event ID format")
            
        result = await db.events.delete_one({"_id": ObjectId(event_id)})
        
        if result.deleted_count == 0:
            raise HTTPException(status_code=404, detail="Event not found")
        
        return {"message": "Event deleted successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to delete event: {str(e)}")