from fastapi import APIRouter, Depends, HTTPException
from motor.motor_asyncio import AsyncIOMotorDatabase
from app.models.order_item import OrderItemCreate, OrderItemUpdate, OrderItemResponse
from app.config.database import get_db
from typing import List

router = APIRouter(prefix="/order-items", tags=["Order Items"])

async def get_next_order_item_id(db: AsyncIOMotorDatabase) -> int:
    counter = await db.counters.find_one_and_update(
        {"_id": "order_item_id"},
        {"$inc": {"seq": 1}},
        upsert=True,
        return_document=True
    )
    return counter["seq"]

@router.post("/", response_model=OrderItemResponse)
async def create_order_item(order_item: OrderItemCreate, db: AsyncIOMotorDatabase = Depends(get_db)):
    order_item_id = await get_next_order_item_id(db)
    order_item_dict = order_item.dict()
    order_item_dict["OrderItemID"] = order_item_id
    
    await db.order_items.insert_one(order_item_dict)
    return OrderItemResponse(**order_item_dict)

@router.get("/{order_item_id}", response_model=OrderItemResponse)
async def get_order_item(order_item_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    order_item = await db.order_items.find_one({"OrderItemID": order_item_id})
    if not order_item:
        raise HTTPException(status_code=404, detail="Order item not found")
    return OrderItemResponse(**order_item)

@router.get("/", response_model=List[OrderItemResponse])
async def get_order_items(db: AsyncIOMotorDatabase = Depends(get_db)):
    order_items = await db.order_items.find().to_list(100)
    return [OrderItemResponse(**order_item) for order_item in order_items]

@router.put("/{order_item_id}", response_model=OrderItemResponse)
async def update_order_item(order_item_id: int, order_item_update: OrderItemUpdate, db: AsyncIOMotorDatabase = Depends(get_db)):
    update_dict = {k: v for k, v in order_item_update.dict().items() if v is not None}
    if not update_dict:
        raise HTTPException(status_code=400, detail="No fields to update")
    
    result = await db.order_items.update_one(
        {"OrderItemID": order_item_id},
        {"$set": update_dict}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Order item not found")
    
    updated_order_item = await db.order_items.find_one({"OrderItemID": order_item_id})
    return OrderItemResponse(**updated_order_item)

@router.delete("/{order_item_id}")
async def delete_order_item(order_item_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    result = await db.order_items.delete_one({"OrderItemID": order_item_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Order item not found")
    return {"message": "Order item deleted"}