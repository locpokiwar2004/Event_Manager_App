from pydantic import BaseModel
from enum import Enum
from datetime import datetime
from typing import Optional
class EventStatus(str, Enum):
    DRAFT = "draft"
    PUBLISHED = "published"
    CANCELLED = "cancelled"
class EventBase(BaseModel):
    Title: str
    Description: str
    Category: str
    Location: str
    Img: Optional[str] = None
    StartTime: datetime
    EndTime: datetime
    Capacity: int
    OrganizerID: int
class EventCreate(EventBase):
    pass
class EventUpdate(BaseModel):
    Title: Optional[str] = None
    Description: Optional[str] = None
    Category: Optional[str] = None
    Location: Optional[str] = None
    Img: Optional[str] = None
    StartTime: Optional[datetime] = None
    EndTime: Optional[datetime] = None
    Capacity: Optional[int] = None
    Status: Optional[EventStatus] = None
class EventResponse(EventBase):
    EventID: int
    Status: EventStatus
    CreatedAt: datetime
    UpdatedAt: datetime
    class Config:
        from_attributes = True
        json_encoders = {datetime: lambda v: v.isoformat()}
class OrganizerInfo(BaseModel):
    UserID: int
    FullName: str
    email: str
    Phone: Optional[str] = None
    Address: Optional[str] = None
class EventWithOrganizer(EventResponse):
    Organizer: OrganizerInfo
class EventStatusUpdate(BaseModel):
    Status: EventStatus