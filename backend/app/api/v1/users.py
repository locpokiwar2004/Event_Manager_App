from fastapi import APIRouter, Depends, HTTPException
from motor.motor_asyncio import AsyncIOMotorDatabase
from app.models.user import UserCreate, UserUpdate, UserResponse
from app.config.database import get_db, SECRET_KEY
from passlib.context import CryptContext
from datetime import datetime, timezone, timedelta
from bson import ObjectId
from typing import List, Optional
import jwt

router = APIRouter(prefix="/users", tags=["Users"])
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
ALGORITHM = "HS256"

@router.post("/", response_model=UserResponse)
async def create_user(user: UserCreate, db: AsyncIOMotorDatabase = Depends(get_db)):
    existing_user = await db.users.find_one({"email": user.email})
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already exists")
    
    user_dict = user.model_dump()
    user_dict["password"] = pwd_context.hash(user_dict["password"])
    user_dict["created_at"] = datetime.now(timezone.utc)
    user_dict["updated_at"] = datetime.now(timezone.utc)
    result = await db.users.insert_one(user_dict)
    new_user = await db.users.find_one({"_id": result.inserted_id})
    return UserResponse(**new_user, id=str(new_user["_id"]))

@router.get("/{user_id}", response_model=UserResponse)
async def get_user(user_id: str, db: AsyncIOMotorDatabase = Depends(get_db)):
    if not ObjectId.is_valid(user_id):
        raise HTTPException(status_code=400, detail="Invalid user ID format")
    user = await db.users.find_one({"_id": ObjectId(user_id)})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return UserResponse(**user, id=str(user["_id"]))

@router.get("/", response_model=List[UserResponse])
async def get_users(db: AsyncIOMotorDatabase = Depends(get_db)):
    users = await db.users.find().to_list(100)
    return [UserResponse(**user, id=str(user["_id"])) for user in users]

@router.put("/{user_id}", response_model=UserResponse)
async def update_user(user_id: str, user_update: UserUpdate, db: AsyncIOMotorDatabase = Depends(get_db)):
    if not ObjectId.is_valid(user_id):
        raise HTTPException(status_code=400, detail="Invalid user ID format")
    update_dict = {k: v for k, v in user_update.model_dump().items() if v is not None}
    if not update_dict:
        raise HTTPException(status_code=400, detail="No fields to update")
    
    update_dict["updated_at"] = datetime.now(timezone.utc)
    result = await db.users.update_one(
        {"_id": ObjectId(user_id)},
        {"$set": update_dict}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="User not found")
    
    updated_user = await db.users.find_one({"_id": ObjectId(user_id)})
    return UserResponse(**updated_user, id=str(updated_user["_id"]))

@router.delete("/{user_id}")
async def delete_user(user_id: str, db: AsyncIOMotorDatabase = Depends(get_db)):
    if not ObjectId.is_valid(user_id):
        raise HTTPException(status_code=400, detail="Invalid user ID format")
    result = await db.users.delete_one({"_id": ObjectId(user_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="User not found")
    return {"message": "User deleted"}

@router.post("/login/")
async def login(email: str, password: str, db: AsyncIOMotorDatabase = Depends(get_db)):
    user = await db.users.find_one({"email": email})
    if not user or not pwd_context.verify(password, user["password"]):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    access_token_expires = timedelta(minutes=30)
    access_token = create_access_token(
        data={"sub": str(user["_id"])}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}
@router.post("/google-signin/")
async def google_signin(email: str, name: Optional[str] = None, db: AsyncIOMotorDatabase = Depends(get_db)):
    user = await db.users.find_one({"email": email})
    if user:
        access_token = create_access_token(
            data={"sub": str(user["_id"])},
            expires_delta=timedelta(minutes=30)  # Thêm expires_delta
        )
        return {"access_token": access_token, "token_type": "bearer"}
    
    user_dict = {
        "name": name or "Google User",
        "email": email,
        "phone": "Unknown",
        "password": pwd_context.hash("google-pass"),
        "address": {"street": "Unknown", "city": "Unknown", "country": "Unknown"},
        "role": "customer",
        "created_at": datetime.now(timezone.utc),
        "updated_at": datetime.now(timezone.utc),
    }
    result = await db.users.insert_one(user_dict)
    new_user = await db.users.find_one({"_id": result.inserted_id})
    access_token = create_access_token(
        data={"sub": str(new_user["_id"])},
        expires_delta=timedelta(minutes=30)  # Thêm expires_delta
    )
    return {"access_token": access_token, "token_type": "bearer"}

def create_access_token(data: dict, expires_delta: timedelta):
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + expires_delta
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt