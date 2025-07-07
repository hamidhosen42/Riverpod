from fastapi import APIRouter, HTTPException, Depends # type: ignore
from model.user import UserCreate, UserLogin, UserPublic
import bcrypt # type: ignore
import jwt # type: ignore
import uuid
from db import db
from middleware.auth_middleware import auth_middleware

router = APIRouter()

JWT_SECRET = "password_key"
JWT_ALGORITHM = "HS256"



# Sign Up
@router.post("/signup", response_model=UserPublic, status_code=201)
async def signup_user(user: UserCreate):
    existing_user = await db["users"].find_one({"email": user.email})
    if existing_user:
        raise HTTPException(status_code=400, detail="User with same email already exists.")

    hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    user_obj = {
    "id": str(uuid.uuid4()),
    "name": user.name,
    "email": user.email,
    "password": hashed_pw.decode()  # store as str
    }

 
    await db["users"].insert_one(user_obj)
    return UserPublic(id=user_obj["id"], name=user_obj["name"], email=user_obj["email"],password = user_obj["password"])


# Login
@router.post("/login")
async def login_user(user: UserLogin):
    user_db = await db["users"].find_one({"email": user.email})
    if not user_db:
        raise HTTPException(status_code=400, detail="User not found.")

    if not bcrypt.checkpw(user.password.encode(), user_db["password"].encode()):
        raise HTTPException(status_code=400, detail="Incorrect password.")

    token = jwt.encode({"id": user_db["id"]}, JWT_SECRET, algorithm=JWT_ALGORITHM)

    return {
        "token": token,
        "user": {
            "id": user_db["id"],
            "name": user_db["name"],
            "email": user_db["email"],
            "password":user_db["password"]
        }
    }

@router.get("/currentuser", response_model=UserPublic)
async def current_user_data(user_dict=Depends(auth_middleware)):
    user = user_dict["user"]
    return UserPublic(id=user["id"], name=user["name"], email=user["email"])