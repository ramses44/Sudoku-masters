from sqlalchemy.orm import declarative_base
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.ext.asyncio import create_async_engine
from sqlalchemy.orm import sessionmaker
import configparser

config = configparser.ConfigParser()
config.read('server/.config')

DATABASE_URL = config['global']['db_url']

Base = declarative_base()

engine = create_async_engine(DATABASE_URL, echo=True)
async_session = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
