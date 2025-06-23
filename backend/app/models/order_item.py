from pydantic import BaseModel
from typing import Optional
from decimal import Decimal

class OrderItemBase(BaseModel):
    OrderID: int
    TicketID: int
    Quantity: int
    UnitPrice: Decimal

class OrderItemCreate(OrderItemBase):
    pass

class OrderItemUpdate(BaseModel):
    Quantity: Optional[int] = None
    UnitPrice: Optional[Decimal] = None

class OrderItemResponse(OrderItemBase):
    OrderItemID: int

    class Config:
        from_attributes = True