from pydantic import BaseModel, EmailStr
from enum import Enum
from datetime import datetime
from typing import Optional

class UserStatus(str, Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"

class UserBase(BaseModel):
    email: EmailStr  # Đổi từ Email thành email
    FullName: str
    Password: str

class UserCreate(UserBase):
    pass

class UserUpdate(BaseModel):
    FullName: Optional[str] = None
    Password: Optional[str] = None
    Status: Optional[UserStatus] = None
    isAdmin: Optional[bool] = None

class UserResponse(UserBase):
    UserID: int
    Status: UserStatus
    isAdmin: bool
    CreatedAt: datetime
    UpdatedAt: datetime

    class Config:
        from_attributes = True
        json_encoders = {datetime: lambda v: v.isoformat()}