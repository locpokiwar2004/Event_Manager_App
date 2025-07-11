from fastapi import APIRouter, Depends, HTTPException
from motor.motor_asyncio import AsyncIOMotorDatabase
from app.models.user import UserCreate, UserLogin, UserResponse, UserStatus
from app.config.database import get_db, SECRET_KEY
from passlib.context import CryptContext
from datetime import datetime, timezone, timedelta
from typing import Optional
import jwt
import logging

# Thiết lập logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

router = APIRouter(prefix="/auth", tags=["Authentication"])
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
            "token": access_token, 
            "message": "User registered successfully",
            "user": {
                "id": user_id,
                "email": user.email,
                "fullName": user.FullName
            }
        }
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error during registration: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error during registration: {str(e)}")

@router.post("/login/")
async def login(login_data: UserLogin, db: AsyncIOMotorDatabase = Depends(get_db)):
    try:
        user = await db.users.find_one({"email": login_data.email})
        if not user or not pwd_context.verify(login_data.password, user["Password"]):
            logger.warning(f"Invalid login attempt for email: {login_data.email}")
            raise HTTPException(status_code=401, detail="Invalid credentials")
        
        access_token_expires = timedelta(minutes=30)
        access_token = create_access_token(
            data={"sub": str(user["UserID"])}, expires_delta=access_token_expires
        )
        logger.info(f"User logged in: UserID {user['UserID']}")
        return {
            "token": access_token, 
            "message": "Login successful",
            "user": {
                "id": user["UserID"],
                "email": user["email"],
                "fullName": user["FullName"]
            }
        }
    except HTTPException:
        raise
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
            return {
                "access_token": access_token, 
                "token_type": "bearer",
                "user_id": user["UserID"],
                "message": "Google sign-in successful"
            }
        
        user_id = await get_next_user_id(db)
        user_dict = {
            "UserID": user_id,
            "FullName": name or "Google User",
            "email": email,
            "Password": pwd_context.hash("google-pass"),
            "Address": "",
            "Phone": 0,
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
        return {
            "access_token": access_token, 
            "token_type": "bearer",
            "user_id": user_id,
            "message": "Google sign-in successful, new user created"
        }
    except Exception as e:
        logger.error(f"Error during Google sign-in: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error during Google sign-in: {str(e)}")
