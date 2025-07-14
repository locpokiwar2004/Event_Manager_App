from pydantic import BaseModel, EmailStr, validator
from enum import Enum
from datetime import datetime
from typing import Optional, Union

class UserStatus(str, Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"

class UserBase(BaseModel):
    email: EmailStr  # Đổi từ Email thành email
    FullName: str
    Password: str
    Address: Optional[str] = None
    Phone: Optional[Union[str, int]] = None
    
    @validator('Phone', pre=True)
    def validate_phone(cls, v):
        if v is None:
            return v
        # Convert int to string if needed
        return str(v) if isinstance(v, int) else v

class UserCreate(UserBase):
    pass

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserUpdate(BaseModel):
    FullName: Optional[str] = None
    Password: Optional[str] = None
    Address: Optional[str] = None
    Phone: Optional[Union[str, int]] = None
    Status: Optional[UserStatus] = None
    isAdmin: Optional[bool] = None
    
    @validator('Phone', pre=True)
    def validate_phone(cls, v):
        if v is None:
            return v
        # Convert int to string if needed
        return str(v) if isinstance(v, int) else v

class UserResponse(UserBase):
    UserID: int
    Status: UserStatus
    isAdmin: bool
    CreatedAt: datetime
    UpdatedAt: datetime
    class Config:
        from_attributes = True
        json_encoders = {datetime: lambda v: v.isoformat()}