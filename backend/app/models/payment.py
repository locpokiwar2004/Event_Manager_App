from pydantic import BaseModel
from enum import Enum
from datetime import datetime
from typing import Optional
from decimal import Decimal

class PaymentMethod(str, Enum):
    CREDIT_CARD = "credit_card"
    BANK_TRANSFER = "bank_transfer"
class PaymentStatus(str, Enum):
    PENDING = "pending"
    COMPLETED = "completed"
    FAILED = "failed"

class PaymentBase(BaseModel):
    OrderID: int
    Method: PaymentMethod
    Amount: Decimal

class PaymentCreate(PaymentBase):
    pass

class PaymentUpdate(BaseModel):
    Method: Optional[PaymentMethod] = None
    Status: Optional[PaymentStatus] = None
    Amount: Optional[Decimal] = None

class PaymentResponse(PaymentBase):
    PaymentID: int
    Status: PaymentStatus
    PaidAt: datetime

    class Config:
        from_attributes = True
        json_encoders = {datetime: lambda v: v.isoformat()}