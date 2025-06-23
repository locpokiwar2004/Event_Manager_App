from fastapi import APIRouter, Depends, HTTPException
from motor.motor_asyncio import AsyncIOMotorDatabase
from app.models.event import EventCreate, EventUpdate, EventResponse, EventStatus
from app.config.database import get_db
from datetime import datetime, timezone
from typing import List

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

@router.get("/{event_id}", response_model=EventResponse)
async def get_event(event_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    event = await db.events.find_one({"EventID": event_id})
    if not event:
        raise HTTPException(status_code=404, detail="Event not found")
    return EventResponse(**event)

@router.get("/", response_model=List[EventResponse])
async def get_events(db: AsyncIOMotorDatabase = Depends(get_db)):
    events = await db.events.find().to_list(100)
    return [EventResponse(**event) for event in events]

@router.put("/{event_id}", response_model=EventResponse)
async def update_event(event_id: int, event_update: EventUpdate, db: AsyncIOMotorDatabase = Depends(get_db)):
    update_dict = {k: v for k, v in event_update.dict().items() if v is not None}
    if not update_dict:
        raise HTTPException(status_code=400, detail="No fields to update")
    
    update_dict["UpdatedAt"] = datetime.now(timezone.utc)
    result = await db.events.update_one(
        {"EventID": event_id},
        {"$set": update_dict}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Event not found")
    
    updated_event = await db.events.find_one({"EventID": event_id})
    return EventResponse(**updated_event)

@router.delete("/{event_id}")
async def delete_event(event_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    result = await db.events.delete_one({"EventID": event_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Event not found")
    return {"message": "Event deleted"}