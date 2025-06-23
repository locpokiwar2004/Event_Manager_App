from pydantic import BaseModel
from enum import Enum
from datetime import datetime
from typing import Optional
from decimal import Decimal

class OrderStatus(str, Enum):
    PENDING = "pending"
    COMPLETED = "completed"
    CANCELLED = "cancelled"

class OrderBase(BaseModel):
    UserID: int
    TotalAmount: Decimal

class OrderCreate(OrderBase):
    pass

class OrderUpdate(BaseModel):
    Status: Optional[OrderStatus] = None
    TotalAmount: Optional[Decimal] = None

class OrderResponse(OrderBase):
    OrderID: int
    OrderDate: datetime
    Status: OrderStatus

    class Config:
        from_attributes = True
        json_encoders = {datetime: lambda v: v.isoformat()}