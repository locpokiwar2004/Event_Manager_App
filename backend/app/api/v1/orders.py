from fastapi import APIRouter, Depends, HTTPException
from motor.motor_asyncio import AsyncIOMotorDatabase
from app.models.order import OrderCreate, OrderUpdate, OrderResponse, OrderStatus
from app.config.database import get_db
from datetime import datetime, timezone
from typing import List

router = APIRouter(prefix="/orders", tags=["Orders"])

async def get_next_order_id(db: AsyncIOMotorDatabase) -> int:
    counter = await db.counters.find_one_and_update(
        {"_id": "order_id"},
        {"$inc": {"seq": 1}},
        upsert=True,
        return_document=True
    )
    return counter["seq"]

@router.post("/", response_model=OrderResponse)
async def create_order(order: OrderCreate, db: AsyncIOMotorDatabase = Depends(get_db)):
    order_id = await get_next_order_id(db)
    order_dict = order.dict()
    order_dict["OrderID"] = order_id
    order_dict["OrderDate"] = datetime.now(timezone.utc)
    order_dict["Status"] = OrderStatus.PENDING
    
    await db.orders.insert_one(order_dict)
    return OrderResponse(**order_dict)

@router.get("/{order_id}", response_model=OrderResponse)
async def get_order(order_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    order = await db.orders.find_one({"OrderID": order_id})
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    return OrderResponse(**order)

@router.get("/", response_model=List[OrderResponse])
async def get_orders(db: AsyncIOMotorDatabase = Depends(get_db)):
    orders = await db.orders.find().to_list(100)
    return [OrderResponse(**order) for order in orders]

@router.put("/{order_id}", response_model=OrderResponse)
async def update_order(order_id: int, order_update: OrderUpdate, db: AsyncIOMotorDatabase = Depends(get_db)):
    update_dict = {k: v for k, v in order_update.dict().items() if v is not None}
    if not update_dict:
        raise HTTPException(status_code=400, detail="No fields to update")
    
    result = await db.orders.update_one(
        {"OrderID": order_id},
        {"$set": update_dict}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Order not found")
    
    updated_order = await db.orders.find_one({"OrderID": order_id})
    return OrderResponse(**updated_order)

@router.delete("/{order_id}")
async def delete_order(order_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    result = await db.orders.delete_one({"OrderID": order_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Order not found")
    return {"message": "Order deleted"}