import sys
from datetime import date
from duckdb import DuckDBPyConnection
from pathlib import Path
from loguru import logger
import polars as pl
from typing import Optional

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))


def parse_extract_date(filename: str) -> Optional[date]:
    """Parse the extract date from file name.
    The date format is expected to be YYYY-MM-DD.
    """
    try:
        extract_date = date(int(filename[:4]), int(filename[5:7]), int(filename[8:10]))
        return extract_date
    except ValueError:
        raise ValueError("Invalid date format. Expected YYYY-MM-DD.")


def read_extract(input_file: str) -> pl.DataFrame:
    extract_date = parse_extract_date(input_file.split("/")[-1])
    if input_file.endswith(".csv"):
        df = pl.read_csv(input_file, infer_schema_length=100000000)
    elif input_file.endswith((".jsonl", ".json")):
        df = pl.read_json(input_file, infer_schema_length=100000000)
    else:
        raise ValueError("Unsupported file format. Only .csv and .json are supported.")
    return df.with_columns(pl.lit(extract_date).alias("extract_date"))


def insert_into_db(conn: DuckDBPyConnection, table: str, data: pl.DataFrame):
    try:
        logger.debug(f"""INSERT OR IGNORE INTO {table} SELECT * from data;""")
        conn.sql(f"""INSERT OR IGNORE INTO {table} SELECT * from data;""")
        logger.success(f"Loaded {len(data)} into {table}")
        logger.info(
            f"Total count of {table} = {conn.sql(f'SELECT COUNT(*) FROM {table};').pl().item()}"
        )
    except Exception as e:
        logger.error(f"Failed to insert data into {table}: {e}")
        raise


def write_parquet(conn, table: str, output_file: str):
    try:
        conn.sql(f"""COPY {table} TO '{output_file}' (FORMAT parquet);""")
        logger.success(f"""COPY {table} TO '{output_file}' (FORMAT parquet);""")
    except Exception as e:
        logger.error(f"Failed to write data to {output_file} FROM {table}: {e}")
        raise
