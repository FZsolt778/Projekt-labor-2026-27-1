from datetime import datetime, timedelta, timezone
import jwt
from server.src.config import settings

def create_access_token(data: dict) -> str:
    payload = data.copy()
    payload["exp"] = datetime.now(timezone.utc) + timedelta(minutes=settings.JWT_EXPIRE_MINUTES)
    return jwt.encode(payload, settings.JWT_SECRET.get_secret_value(), algorithm=settings.JWT_ALGORITHM)

# If the token is fake or expired, Error send out 
def decode_access_token(token: str) -> dict:
    return jwt.decode(token, settings.JWT_SECRET.get_secret_value(), algorithms=[settings.JWT_ALGORITHM])
