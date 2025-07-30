from fastapi import APIRouter, HTTPException, Query
from app.config.database import db
from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List
from bson import ObjectId
import re

router = APIRouter()

class EventCreate(BaseModel):
    title: str
    description: str
    category: str
    location: str
    date: str  # Format: "YYYY-MM-DD"
    time: str  # Format: "HH:MM"
    capacity: int
    price: float
    organizer_id: Optional[int] = 1  # Default organizer for now

class EventResponse(BaseModel):
    id: str
    title: str
    description: str
    category: str
    location: str
    date: str
    time: str
    capacity: int
    price: float
    organizer_id: int
    created_at: datetime
    
    class Config:
        from_attributes = True

@router.post("/events")
async def create_event(event_data: EventCreate):
    """Create a new event"""
    try:
        # Combine date and time into datetime
        event_datetime = datetime.strptime(f"{event_data.date} {event_data.time}", "%Y-%m-%d %H:%M")
        
        # Create new event document
        event_doc = {
            "title": event_data.title,
            "description": event_data.description,
            "category": event_data.category,
            "location": event_data.location,
            "date": event_datetime,
            "capacity": event_data.capacity,
            "price": event_data.price,
            "organizer_id": event_data.organizer_id,
            "created_at": datetime.utcnow()
        }
        
        # Insert into MongoDB
        result = await db.events.insert_one(event_doc)
        
        # Return created event
        created_event = await db.events.find_one({"_id": result.inserted_id})
        
        return {
            "id": str(created_event["_id"]),
            "title": created_event["title"],
            "description": created_event["description"],
            "category": created_event["category"],
            "location": created_event["location"],
            "date": created_event["date"].strftime("%Y-%m-%d"),
            "time": created_event["date"].strftime("%H:%M"),
            "capacity": created_event["capacity"],
            "price": created_event["price"],
            "organizer_id": created_event["organizer_id"],
            "created_at": created_event["created_at"]
        }
        
    except ValueError as e:
        raise HTTPException(status_code=400, detail=f"Invalid date/time format: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to create event: {str(e)}")

@router.get("/events")
async def get_events():
    """Get all events"""
    try:
        events = []
        async for event in db.events.find():
            events.append({
                "id": str(event["_id"]),
                "title": event["title"],
                "description": event["description"],
                "category": event["category"],
                "location": event["location"],
                "date": event["date"].strftime("%Y-%m-%d"),
                "time": event["date"].strftime("%H:%M"),
                "capacity": event["capacity"],
                "price": event["price"],
                "organizer_id": event["organizer_id"],
                "created_at": event["created_at"]
            })
        return events
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch events: {str(e)}")

@router.get("/events/search")
async def search_events(
    query: Optional[str] = Query(None, description="Search text for title or description"),
    category: Optional[str] = Query(None, description="Filter by category"),
    location: Optional[str] = Query(None, description="Filter by location"),
    date_from: Optional[str] = Query(None, description="Start date (YYYY-MM-DD)"),
    date_to: Optional[str] = Query(None, description="End date (YYYY-MM-DD)"),
    min_price: Optional[float] = Query(None, description="Minimum price"),
    max_price: Optional[float] = Query(None, description="Maximum price"),
    limit: Optional[int] = Query(50, description="Maximum number of results"),
    offset: Optional[int] = Query(0, description="Number of results to skip")
):
    """Search events with various filters"""
    try:
        # Build MongoDB query
        mongo_query = {}
        
        # Text search in title and description
        if query and query.strip():
            mongo_query["$or"] = [
                {"title": {"$regex": query.strip(), "$options": "i"}},
                {"description": {"$regex": query.strip(), "$options": "i"}}
            ]
        
        # Category filter
        if category and category.strip():
            mongo_query["category"] = {"$regex": f"^{category.strip()}$", "$options": "i"}
        
        # Location filter
        if location and location.strip():
            mongo_query["location"] = {"$regex": location.strip(), "$options": "i"}
        
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
            
            mongo_query["date"] = date_filter
        
        # Price range filter
        if min_price is not None or max_price is not None:
            price_filter = {}
            if min_price is not None:
                price_filter["$gte"] = min_price
            if max_price is not None:
                price_filter["$lte"] = max_price
            mongo_query["price"] = price_filter
        
        # Execute query with pagination
        cursor = db.events.find(mongo_query).skip(offset).limit(limit)
        
        events = []
        async for event in cursor:
            events.append({
                "id": str(event["_id"]),
                "title": event["title"],
                "description": event["description"],
                "category": event["category"],
                "location": event["location"],
                "date": event["date"].strftime("%Y-%m-%d"),
                "time": event["date"].strftime("%H:%M"),
                "capacity": event["capacity"],
                "price": event["price"],
                "organizer_id": event["organizer_id"],
                "created_at": event["created_at"]
            })
        
        return events
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to search events: {str(e)}")

@router.get("/events/hot")
async def get_hot_events(limit: Optional[int] = Query(10, description="Number of hot events to return")):
    """Get hot/popular events (sorted by creation date for now)"""
    try:
        events = []
        # For now, we'll consider newest events as "hot"
        # In the future, this could be based on ticket sales, views, etc.
        cursor = db.events.find().sort("created_at", -1).limit(limit)
        
        async for event in cursor:
            events.append({
                "id": str(event["_id"]),
                "title": event["title"],
                "description": event["description"],
                "category": event["category"],
                "location": event["location"],
                "date": event["date"].strftime("%Y-%m-%d"),
                "time": event["date"].strftime("%H:%M"),
                "capacity": event["capacity"],
                "price": event["price"],
                "organizer_id": event["organizer_id"],
                "created_at": event["created_at"]
            })
        
        return events
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch hot events: {str(e)}")

@router.get("/events/monthly")
async def get_monthly_events(
    year: int = Query(..., description="Year (e.g., 2024)"),
    month: int = Query(..., description="Month (1-12)")
):
    """Get events for a specific month"""
    try:
        # Validate month
        if month < 1 or month > 12:
            raise HTTPException(status_code=400, detail="Month must be between 1 and 12")
        
        # Create date range for the month
        from datetime import datetime
        import calendar
        
        start_date = datetime(year, month, 1)
        last_day = calendar.monthrange(year, month)[1]
        end_date = datetime(year, month, last_day, 23, 59, 59)
        
        # Query events in the date range
        mongo_query = {
            "date": {
                "$gte": start_date,
                "$lte": end_date
            }
        }
        
        events = []
        async for event in db.events.find(mongo_query).sort("date", 1):
            events.append({
                "id": str(event["_id"]),
                "title": event["title"],
                "description": event["description"],
                "category": event["category"],
                "location": event["location"],
                "date": event["date"].strftime("%Y-%m-%d"),
                "time": event["date"].strftime("%H:%M"),
                "capacity": event["capacity"],
                "price": event["price"],
                "organizer_id": event["organizer_id"],
                "created_at": event["created_at"]
            })
        
        return events
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch monthly events: {str(e)}")

@router.get("/events/organizer/{organizer_id}")
async def get_events_by_organizer(organizer_id: int):
    """Get all events created by a specific organizer"""
    try:
        events = []
        async for event in db.events.find({"organizer_id": organizer_id}):
            events.append({
                "id": str(event["_id"]),
                "title": event["title"],
                "description": event["description"],
                "category": event["category"],
                "location": event["location"],
                "date": event["date"].strftime("%Y-%m-%d"),
                "time": event["date"].strftime("%H:%M"),
                "capacity": event["capacity"],
                "price": event["price"],
                "organizer_id": event["organizer_id"],
                "created_at": event["created_at"]
            })
        return events
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch events: {str(e)}")

@router.get("/events/{event_id}")
async def get_event(event_id: str):
    """Get a specific event"""
    try:
        if not ObjectId.is_valid(event_id):
            raise HTTPException(status_code=400, detail="Invalid event ID format")
            
        event = await db.events.find_one({"_id": ObjectId(event_id)})
        if not event:
            raise HTTPException(status_code=404, detail="Event not found")
        
        return {
            "id": str(event["_id"]),
            "title": event["title"],
            "description": event["description"],
            "category": event["category"],
            "location": event["location"],
            "date": event["date"].strftime("%Y-%m-%d"),
            "time": event["date"].strftime("%H:%M"),
            "capacity": event["capacity"],
            "price": event["price"],
            "organizer_id": event["organizer_id"],
            "created_at": event["created_at"]
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch event: {str(e)}")

@router.put("/events/{event_id}")
async def update_event(event_id: str, event: EventCreate):
    """Update an existing event"""
    try:
        if not ObjectId.is_valid(event_id):
            raise HTTPException(status_code=400, detail="Invalid event ID format")
            
        # Parse datetime
        event_datetime = datetime.strptime(f"{event.date} {event.time}", "%Y-%m-%d %H:%M")
        
        update_data = {
            "title": event.title,
            "description": event.description,
            "category": event.category,
            "location": event.location,
            "date": event_datetime,
            "capacity": event.capacity,
            "price": event.price,
            "organizer_id": event.organizer_id,
            "updated_at": datetime.utcnow()
        }
        
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
            "title": updated_event["title"],
            "description": updated_event["description"],
            "category": updated_event["category"],
            "location": updated_event["location"],
            "date": updated_event["date"].strftime("%Y-%m-%d"),
            "time": updated_event["date"].strftime("%H:%M"),
            "capacity": updated_event["capacity"],
            "price": updated_event["price"],
            "organizer_id": updated_event["organizer_id"],
            "created_at": updated_event["created_at"]
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to update event: {str(e)}")

@router.delete("/events/{event_id}")
async def delete_event(event_id: str):
    """Delete an event"""
    try:
        if not ObjectId.is_valid(event_id):
            raise HTTPException(status_code=400, detail="Invalid event ID format")
            
        result = await db.events.delete_one({"_id": ObjectId(event_id)})
        
        if result.deleted_count == 0:
            raise HTTPException(status_code=404, detail="Event not found")
        
        return {"message": "Event deleted successfully"}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to delete event: {str(e)}")