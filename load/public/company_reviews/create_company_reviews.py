import sys
from pathlib import Path
import logging

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))
import duckdb as db
from config import cfg
from load.public.company_reviews.query import (
    CREATE_SCHEMA,
    CREATE_TABLE_COMPANY,
    CREATE_TABLE_COMPANY_OVERVIEW,
    CREATE_TABLE_COMPANY_REVIEW,
)


def create_company_reviews_db():
    Path(cfg.LOG_DIR).mkdir(parents=True, exist_ok=True)
    logging.basicConfig(
        filename=f"{cfg.LOG_DIR}/init_db.log",
        level=logging.INFO,
        format="%(asctime)s - %(levelname)s - %(message)s",
    )
    logging.info("Initializing public database...")

    with db.connect(database=cfg.DATA_LAKE + "/public/load/public.db") as conn:
        for query in [
            CREATE_SCHEMA,
            CREATE_TABLE_COMPANY,
            CREATE_TABLE_COMPANY_OVERVIEW,
            CREATE_TABLE_COMPANY_REVIEW,
        ]:
            conn.sql(query)
        logging.info("Personal database created successfully:")
        logging.info(conn.sql("SELECT * FROM information_schema.tables;"))
