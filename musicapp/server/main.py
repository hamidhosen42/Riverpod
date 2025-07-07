from fastapi import FastAPI # type: ignore
from routes import auth

app = FastAPI()

app.include_router(auth.router, prefix="/auth")
