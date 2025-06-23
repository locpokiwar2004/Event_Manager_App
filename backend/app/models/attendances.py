from pydantic import BaseModel
from enum import Enum
from datetime import datetime
from typing import Optional

class AttendanceStatus(str, Enum):
    REGISTERED = "registered"
    CHECKED_IN = "checked_in"
    CANCELLED = "cancelled"

class AttendanceBase(BaseModel):
    EventID: int
    UserID: int

class AttendanceCreate(AttendanceBase):
    pass

class AttendanceUpdate(BaseModel):
    Status: Optional[AttendanceStatus] = None

class AttendanceResponse(AttendanceBase):
    AttendanceID: int
    Status: AttendanceStatus
    RegisteredAt: datetime

    class Config:
        from_attributes = True
        json_encoders = {datetime: lambda v: v.isoformat()}