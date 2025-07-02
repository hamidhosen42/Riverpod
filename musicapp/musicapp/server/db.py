from motor.motor_asyncio import AsyncIOMotorClient # type: ignore
from dotenv import load_dotenv # type: ignore
import os
import urllib.parse

load_dotenv()

# You can expand this with .env variables later
MONGO_URI = "mongodb://localhost:27017"

client = AsyncIOMotorClient(MONGO_URI)
db = client["musicapp_db"]
