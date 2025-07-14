from motor.motor_asyncio import AsyncIOMotorClient  # type: ignore
from dotenv import load_dotenv  # type: ignore
import os
import urllib.parse

load_dotenv()

username = urllib.parse.quote_plus(os.getenv("MONGO_USERNAME"))
password = urllib.parse.quote_plus(os.getenv("MONGO_PASSWORD"))
cluster = os.getenv("MONGO_CLUSTER")
db_name = os.getenv("MONGO_DB", "musicapp_db")

# MongoDB Atlas URI
MONGO_URI = f"mongodb+srv://{username}:{password}@{cluster}/?retryWrites=true&w=majority&appName=musicapp"

client = AsyncIOMotorClient(MONGO_URI)
db = client[db_name]