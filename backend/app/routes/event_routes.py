from fastapi import APIRouter, HTTPException
from app.config.database import db
from pydantic import BaseModel
from datetime import datetime
from typing import Optional
from bson import ObjectId

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