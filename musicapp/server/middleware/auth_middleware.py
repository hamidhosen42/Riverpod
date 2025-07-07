from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import jwt
from db import db

JWT_SECRET = "password_key"
JWT_ALGORITHM = "HS256"

security = HTTPBearer()  

async def auth_middleware(credentials: HTTPAuthorizationCredentials = Depends(security)):
    token = credentials.credentials  

    try:
        decoded = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        user_id = decoded.get("id")
        if not user_id:
            raise HTTPException(status_code=401, detail="Invalid token: missing user ID.")

        user = await db["users"].find_one({"id": user_id})
        if not user:
            raise HTTPException(status_code=401, detail="User not found.")

        return {"uid": user_id, "user": user}

    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token has expired.")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token.")
