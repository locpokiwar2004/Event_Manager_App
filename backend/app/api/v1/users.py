from fastapi import APIRouter, Depends, HTTPException
from motor.motor_asyncio import AsyncIOMotorDatabase
from app.models.user import UserCreate, UserUpdate, UserResponse, UserStatus
from app.config.database import get_db, SECRET_KEY
from passlib.context import CryptContext
from datetime import datetime, timezone, timedelta
from typing import List, Optional
import jwt
import logging

# Thiết lập logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

router = APIRouter(prefix="/users", tags=["Users"])
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
ALGORITHM = "HS256"

def create_access_token(data: dict, expires_delta: timedelta):
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + expires_delta
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

async def get_next_user_id(db: AsyncIOMotorDatabase) -> int:
    counter = await db.counters.find_one_and_update(
        {"_id": "user_id"},
        {"$inc": {"seq": 1}},
        upsert=True,
        return_document=True
    )
    return counter["seq"]

@router.post("/", response_model=UserResponse)
async def create_user(user: UserCreate, db: AsyncIOMotorDatabase = Depends(get_db)):
    try:
        # Kiểm tra email (chữ thường) đã tồn tại
        existing_user = await db.users.find_one({"email": user.email})
        if existing_user:
            logger.warning(f"Email already exists: {user.email}")
            raise HTTPException(status_code=400, detail="Email already exists")
        
        # Tạo user mới
        user_id = await get_next_user_id(db)
        user_dict = user.dict()
        user_dict["UserID"] = user_id
        user_dict["Password"] = pwd_context.hash(user_dict["Password"])
        user_dict["Status"] = UserStatus.ACTIVE
        user_dict["isAdmin"] = False
        user_dict["CreatedAt"] = datetime.now(timezone.utc).isoformat()
        user_dict["UpdatedAt"] = datetime.now(timezone.utc).isoformat()
        
        # Insert vào MongoDB
        result = await db.users.insert_one(user_dict)
        logger.info(f"Inserted user with ID: {result.inserted_id}, UserID: {user_id}")
        
        # Lấy user vừa tạo
        created_user = await db.users.find_one({"_id": result.inserted_id})
        if not created_user:
            logger.error("Failed to retrieve newly created user")
            raise HTTPException(status_code=500, detail="Failed to retrieve created user")
        
        return UserResponse(**created_user)
    except Exception as e:
        logger.error(f"Error creating user: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error creating user: {str(e)}")

@router.get("/{user_id}", response_model=UserResponse)
async def get_user(user_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    try:
        user = await db.users.find_one({"UserID": user_id})
        if not user:
            logger.warning(f"User not found: UserID {user_id}")
            raise HTTPException(status_code=404, detail="User not found")
        logger.info(f"Retrieved user: UserID {user_id}")
        return UserResponse(**user)
    except Exception as e:
        logger.error(f"Error retrieving user: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error retrieving user: {str(e)}")

@router.get("/", response_model=List[UserResponse])
async def get_users(db: AsyncIOMotorDatabase = Depends(get_db)):
    try:
        users = await db.users.find().to_list(100)
        logger.info(f"Retrieved {len(users)} users")
        return [UserResponse(**user) for user in users]
    except Exception as e:
        logger.error(f"Error retrieving users: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error retrieving users: {str(e)}")

@router.put("/{user_id}", response_model=UserResponse)
async def update_user(user_id: int, user_update: UserUpdate, db: AsyncIOMotorDatabase = Depends(get_db)):
    try:
        update_dict = {k: v for k, v in user_update.dict().items() if v is not None}
        if "Password" in update_dict:
            update_dict["Password"] = pwd_context.hash(update_dict["Password"])
        if not update_dict:
            logger.warning(f"No fields to update for UserID {user_id}")
            raise HTTPException(status_code=400, detail="No fields to update")
        
        update_dict["UpdatedAt"] = datetime.now(timezone.utc).isoformat()
        result = await db.users.update_one(
            {"UserID": user_id},
            {"$set": update_dict}
        )
        if result.matched_count == 0:
            logger.warning(f"User not found for update: UserID {user_id}")
            raise HTTPException(status_code=404, detail="User not found")
        
        updated_user = await db.users.find_one({"UserID": user_id})
        logger.info(f"Updated user: UserID {user_id}")
        return UserResponse(**updated_user)
    except Exception as e:
        logger.error(f"Error updating user: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error updating user: {str(e)}")

@router.delete("/{user_id}")
async def delete_user(user_id: int, db: AsyncIOMotorDatabase = Depends(get_db)):
    try:
        result = await db.users.delete_one({"UserID": user_id})
        if result.deleted_count == 0:
            logger.warning(f"User not found for deletion: UserID {user_id}")
            raise HTTPException(status_code=404, detail="User not found")
        logger.info(f"Deleted user: UserID {user_id}")
        return {"message": "User deleted"}
    except Exception as e:
        logger.error(f"Error deleting user: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error deleting user: {str(e)}")

@router.post("/login/")
async def login(email: str, password: str, db: AsyncIOMotorDatabase = Depends(get_db)):
    try:
        user = await db.users.find_one({"email": email})
        if not user or not pwd_context.verify(password, user["Password"]):
            logger.warning(f"Invalid login attempt for email: {email}")
            raise HTTPException(status_code=401, detail="Invalid credentials")
        
        access_token_expires = timedelta(minutes=30)
        access_token = create_access_token(
            data={"sub": str(user["UserID"])}, expires_delta=access_token_expires
        )
        logger.info(f"User logged in: UserID {user['UserID']}")
        return {"access_token": access_token, "token_type": "bearer"}
    except Exception as e:
        logger.error(f"Error during login: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error during login: {str(e)}")

@router.post("/google-signin/")
async def google_signin(email: str, name: Optional[str] = None, db: AsyncIOMotorDatabase = Depends(get_db)):
    try:
        user = await db.users.find_one({"email": email})
        if user:
            access_token = create_access_token(
                data={"sub": str(user["UserID"])},
                expires_delta=timedelta(minutes=30)
            )
            logger.info(f"Google sign-in for existing user: UserID {user['UserID']}")
            return {"access_token": access_token, "token_type": "bearer"}
        
        user_id = await get_next_user_id(db)
        user_dict = {
            "UserID": user_id,
            "FullName": name or "Google User",
            "email": email,
            "Password": pwd_context.hash("google-pass"),
            "Status": UserStatus.ACTIVE,
            "isAdmin": False,
            "CreatedAt": datetime.now(timezone.utc).isoformat(),
            "UpdatedAt": datetime.now(timezone.utc).isoformat()
        }
        result = await db.users.insert_one(user_dict)
        logger.info(f"Created Google user with ID: {result.inserted_id}, UserID: {user_id}")
        
        access_token = create_access_token(
            data={"sub": str(user_id)},
            expires_delta=timedelta(minutes=30)
        )
        return {"access_token": access_token, "token_type": "bearer"}
    except Exception as e:
        logger.error(f"Error during Google sign-in: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error during Google sign-in: {str(e)}")

@router.post("/register/")
async def register(user: UserCreate, db: AsyncIOMotorDatabase = Depends(get_db)):
    try:
        # Kiểm tra email đã tồn tại
        existing_user = await db.users.find_one({"email": user.email})
        if existing_user:
            logger.warning(f"Email already exists during registration: {user.email}")
            raise HTTPException(status_code=400, detail="Email already exists")
        
        # Tạo user mới
        user_id = await get_next_user_id(db)
        user_dict = user.dict()
        user_dict["UserID"] = user_id
        user_dict["Password"] = pwd_context.hash(user_dict["Password"])
        user_dict["Status"] = UserStatus.ACTIVE
        user_dict["isAdmin"] = False
        user_dict["CreatedAt"] = datetime.now(timezone.utc).isoformat()
        user_dict["UpdatedAt"] = datetime.now(timezone.utc).isoformat()
        
        # Insert vào MongoDB
        result = await db.users.insert_one(user_dict)
        logger.info(f"Registered new user with ID: {result.inserted_id}, UserID: {user_id}")
        
        # Tạo access token cho user mới
        access_token_expires = timedelta(minutes=30)
        access_token = create_access_token(
            data={"sub": str(user_id)}, expires_delta=access_token_expires
        )
        
        logger.info(f"User registered successfully: UserID {user_id}")
        return {
            "access_token": access_token, 
            "token_type": "bearer",
            "user_id": user_id,
            "message": "User registered successfully"
        }
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error during registration: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error during registration: {str(e)}")