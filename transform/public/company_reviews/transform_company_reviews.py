import sys
import polars as pl
import py_vncorenlp
from pathlib import Path
from loguru import logger

sys.path.insert(0, str(Path(__file__).resolve().parents[3]))
from config import cfg


def transform_reviews_segmentation():
    output_dir = Path(f"{cfg.DATA_LAKE}/public/transform/company_reviews")
    output_dir.mkdir(parents=True, exist_ok=True)
    root_dir = Path(__file__).resolve().parents[3]
    rdrsegmenter = py_vncorenlp.VnCoreNLP(
        annotators=["wseg"], save_dir=str(root_dir / "utils/nlp")
    )

    reviews = pl.read_parquet(
        f"{cfg.DATA_LAKE}/public/load/company_reviews/*_review.parquet"
    )
    reviews = reviews.sort("extract_date", descending=True, maintain_order=True)
    reviews = reviews.unique(
        subset=[col for col in reviews.columns if col != "extract_date"],
        keep="first",
    )
    reviews = reviews.with_columns(
        (pl.col("review_title") + ". " + pl.col("pros") + ". " + pl.col("cons")).alias(
            "segmented_review"
        )
    )
    reviews = reviews.with_columns(
        pl.col("link").str.extract(r"/([^/?]+)(?:\?|$)", 1).alias("endpoint")
    )
    companies = pl.read_parquet(
        f"{cfg.DATA_LAKE}/public/load/company_reviews/*_list.parquet"
    ).select("link", "name", "location", "department")
    companies = companies.with_columns(
        pl.col("link").str.extract(r"/([^/?]+)(?:\?|$)", 1).alias("endpoint")
    )

    reviews = reviews.join(companies, on="endpoint", how="left")
    reviews = reviews.select(
        [
            "extract_date",
            "endpoint",
            "name",
            "location",
            "department",
            "segmented_review",
            "review_rating",
        ]
    )
    reviews = reviews.with_columns(
        pl.col("segmented_review")
        .map_elements(rdrsegmenter.word_segment, return_dtype=pl.List(pl.Utf8))
        .alias("segmented_review")
    )
    reviews.write_parquet(
        output_dir / f"{cfg.today}_transformed_company_reviews.parquet"
    )
    logger.success(
        f"Transformed reviews to {output_dir / 'transformed_company_reviews.parquet'}"
    )
    logger.info(f"Transformed reviews shape: {reviews.shape}")
    logger.info(f"Transformed reviews columns: {reviews.columns}")
    return reviews
