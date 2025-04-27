import os
import sys
import duckdb as db
from pathlib import Path
from loguru import logger

sys.path.insert(0, str(Path(__file__).resolve().parents[3]))
from config import cfg
from load.public.company_reviews.clean_company_reviews import (
    clean_companies,
    clean_overviews,
    clean_reviews,
)
from load.public.company_reviews.create_company_reviews import (
    create_company_reviews_db,
)
from utils.io_helpers import insert_into_db, write_parquet, read_extract


def load_db_company_reviews():
    file_format = "json"
    COMPANY_COLS = ["extract_date", "link", "name", "location", "department"]
    OVERVIEW_COLS = [
        "extract_date",
        "link",
        "website",
        "phone_number",
        "department",
        "business_type",
        "headquarter",
        "scale",
        "revenue",
        "established_at",
        "description",
        "insurance_policies",
        "activities",
        "background_history",
        "mission",
        "parent",
        "parent_headquarter",
    ]
    REVIEW_COLS = [
        "extract_date",
        "link",
        "review_rating",
        "review_title",
        "review_position",
        "review_date",
        "pros",
        "cons",
    ]
    extract_dir = f"{cfg.DATA_LAKE}/public/extract/company_reviews/"
    load_dir = f"{cfg.DATA_LAKE}/public/load/company_reviews/"
    create_company_reviews_db()
    for filename in os.listdir(extract_dir):
        parquet_output_file = load_dir + filename.replace(file_format, "parquet")
        with db.connect(database=cfg.DATA_LAKE + "/public/load/public.db") as conn:
            os.makedirs(load_dir, exist_ok=True)
            if filename.endswith(f"_list.{file_format}"):
                companies = read_extract(extract_dir + filename)
                companies = companies.pipe(clean_companies)
                # for col in COMPANY_COLS:
                #     if col not in companies.columns:
                #         companies = companies.with_column(pl.lit(None).alias(col))
                # companies = companies.select(COMPANY_COLS)
                insert_into_db(conn, "company_reviews.company", companies)
                write_parquet(conn, "company_reviews.company", parquet_output_file)
                logger.success(
                    f"Loaded {parquet_output_file} into {cfg.DATA_LAKE}/public/load/company_reviews/"
                )
            if filename.endswith(f"_overview.{file_format}"):
                overviews = read_extract(extract_dir + filename)
                overviews = overviews.pipe(clean_overviews)
                # overviews = overviews.select(OVERVIEW_COLS)
                insert_into_db(conn, "company_reviews.overview", overviews)
                write_parquet(conn, "company_reviews.overview", parquet_output_file)
                logger.success(
                    f"Loaded {parquet_output_file} into {cfg.DATA_LAKE}/public/load/company_reviews/"
                )
            if filename.endswith(f"_review.{file_format}"):
                reviews = read_extract(extract_dir + filename)
                reviews = reviews.pipe(clean_reviews)
                # reviews = reviews.select(REVIEW_COLS)
                insert_into_db(conn, "company_reviews.review", reviews)
                write_parquet(conn, "company_reviews.review", parquet_output_file)
                logger.success(
                    f"Loaded {parquet_output_file} into {cfg.DATA_LAKE}/public/load/company_reviews/"
                )
