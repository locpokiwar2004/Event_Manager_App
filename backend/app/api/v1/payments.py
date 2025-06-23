from fastapi import APIRouter, Depends, HTTPException
from motor.motor_asyncio import AsyncIOMotorDatabase
from app.models.payment import PaymentCreate, PaymentUpdate, PaymentResponse, PaymentStatus
from app.config.database import get_db
from datetime import datetime, timezone
from typing import List

router = APIRouter(prefix="/payments", tags=["Payments"])

async def get_next_payment_id(db: AsyncIOMotorDatabase) -> int:
    counter = await db.counters.find_one_and_update(
        {"_id": "payment_id"},
        {"$inc": {"seq": 1}},
        upsert=True,
        return_document=True
    )
    return counter["seq"]

@router.post("/", response_model=PaymentResponse)
async def create_payment(payment: PaymentCreate, db: AsyncIOMotorDatabase = Depends(get_db)):
    payment_id = await get_next_payment_id(db)
    payment_dict = payment.dict()
    payment_dict["PaymentID"] = payment_id
    payment_dict["Status"] = PaymentStatus.PENDING
    payment_dict["PaidAt"] = datetime.now(timezone.utc)
    
    await db.payments.insert_one(payment_dict)
    return PaymentResponse(**payment_dict)

@router.get("/{payment_id}", response_model=PaymentResponse)
async def get_payment(payment_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    payment = await db.payments.find_one({"PaymentID": payment_id})
    if not payment:
        raise HTTPException(status_code=404, detail="Payment not found")
    return PaymentResponse(**payment)

@router.get("/", response_model=List[PaymentResponse])
async def get_payments(db: AsyncIOMotorDatabase = Depends(get_db)):
    payments = await db.payments.find().to_list(100)
    return [PaymentResponse(**payment) for payment in payments]

@router.put("/{payment_id}", response_model=PaymentResponse)
async def update_payment(payment_id: int, payment_update: PaymentUpdate, db: AsyncIOMotorDatabase = Depends(get_db)):
    update_dict = {k: v for k, v in payment_update.dict().items() if v is not None}
    if not update_dict:
        raise HTTPException(status_code=400, detail="No fields to update")
    
    result = await db.payments.update_one(
        {"PaymentID": payment_id},
        {"$set": update_dict}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Payment not found")
    
    updated_payment = await db.payments.find_one({"PaymentID": payment_id})
    return PaymentResponse(**updated_payment)

@router.delete("/{payment_id}")
async def delete_payment(payment_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    result = await db.payments.delete_one({"PaymentID": payment_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Payment not found")
    return {"message": "Payment deleted"}