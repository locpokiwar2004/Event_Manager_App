from pydantic import BaseModel
from typing import Optional

class TicketBase(BaseModel):
    EventID: int
    Name: str
    Price: float
    OnePer: int
    QuantityTotal: int

class TicketCreate(TicketBase):
    pass

class TicketUpdate(BaseModel):
    Name: Optional[str] = None
    Price: Optional[float] = None
    OnePer: Optional[int] = None
    QuantityTotal: Optional[int] = None
    QuantitySold: Optional[int] = None

class TicketResponse(TicketBase):
    TicketID: int
    QuantitySold: int

    class Config:
        from_attributes = True