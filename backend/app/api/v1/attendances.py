from fastapi import APIRouter, Depends, HTTPException
from motor.motor_asyncio import AsyncIOMotorDatabase
from app.models.attendances import AttendanceCreate, AttendanceUpdate, AttendanceResponse, AttendanceStatus
from app.config.database import get_db
from datetime import datetime, timezone
from typing import List

router = APIRouter(prefix="/attendances", tags=["Attendances"])

async def get_next_attendance_id(db: AsyncIOMotorDatabase) -> int:
    counter = await db.counters.find_one_and_update(
        {"_id": "attendance_id"},
        {"$inc": {"seq": 1}},
        upsert=True,
        return_document=True
    )
    return counter["seq"]

@router.post("/", response_model=AttendanceResponse)
async def create_attendance(attendance: AttendanceCreate, db: AsyncIOMotorDatabase = Depends(get_db)):
    attendance_id = await get_next_attendance_id(db)
    attendance_dict = attendance.dict()
    attendance_dict["AttendanceID"] = attendance_id
    attendance_dict["Status"] = AttendanceStatus.REGISTERED
    attendance_dict["RegisteredAt"] = datetime.now(timezone.utc)
    
    await db.attendances.insert_one(attendance_dict)
    return AttendanceResponse(**attendance_dict)

@router.get("/{attendance_id}", response_model=AttendanceResponse)
async def get_attendance(attendance_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    attendance = await db.attendances.find_one({"AttendanceID": attendance_id})
    if not attendance:
        raise HTTPException(status_code=404, detail="Attendance not found")
    return AttendanceResponse(**attendance)

@router.get("/", response_model=List[AttendanceResponse])
async def get_attendances(db: AsyncIOMotorDatabase = Depends(get_db)):
    attendances = await db.attendances.find().to_list(100)
    return [AttendanceResponse(**attendance) for attendance in attendances]

@router.put("/{attendance_id}", response_model=AttendanceResponse)
async def update_attendance(attendance_id: int, attendance_update: AttendanceUpdate, db: AsyncIOMotorDatabase = Depends(get_db)):
    update_dict = {k: v for k, v in attendance_update.dict().items() if v is not None}
    if not update_dict:
        raise HTTPException(status_code=400, detail="No fields to update")
    
    result = await db.attendances.update_one(
        {"AttendanceID": attendance_id},
        {"$set": update_dict}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Attendance not found")
    
    updated_attendance = await db.attendances.find_one({"AttendanceID": attendance_id})
    return AttendanceResponse(**updated_attendance)

@router.delete("/{attendance_id}")
async def delete_attendance(attendance_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    result = await db.attendances.delete_one({"AttendanceID": attendance_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Attendance not found")
    return {"message": "Attendance deleted"}