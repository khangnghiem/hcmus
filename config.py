import os
from dotenv import load_dotenv


class Config:
    def __init__(self):
        load_dotenv()
        self.data_lake = os.getenv("DATA_LAKE")
        self.hf_token = os.getenv("HF_TOKEN")
        self.cookie = os.getenv("COOKIE")
        self.debug = os.getenv("DEBUG", "False").lower() in ("true", "1", "t")


cfg = Config()
