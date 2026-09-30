from sqlalchemy.orm import DeclarativeBase, sessionmaker
from server.src.config import settings
from sqlalchemy import create_engine

class Base(DeclarativeBase):
    pass

engine = create_engine(settings.DATABASE_URL)
DBSession = sessionmaker(bind=engine, autoflush=False)

#create a database session and close it after finishing
def get_db():
    db = DBSession()
    try:
        yield db
    finally:
        db.close()
