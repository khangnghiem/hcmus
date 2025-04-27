import polars as pl


def fill_missing_columns(df, REVIEW_COLS):
    missing_cols = [col for col in REVIEW_COLS if col not in df.columns]
    df = df.with_columns([pl.lit(None).alias(col) for col in missing_cols])
    return df


def clean_companies(df: pl.DataFrame) -> pl.DataFrame:
    COMPANY_COLS = ["extract_date", "link", "name", "location", "department"]
    df = fill_missing_columns(df, COMPANY_COLS)
    df = df.with_columns(
        pl.col("department")
        .str.replace_all(r"(\w+)\s*/\s*(\w+)", r"$1 / $2")
        .alias("department"),
    )
    return df.select(COMPANY_COLS)


def clean_overviews(df: pl.DataFrame) -> pl.DataFrame:
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
    df = fill_missing_columns(df, OVERVIEW_COLS)
    df = df.with_columns(
        pl.col("established_at")
        .str.replace_all(r"([^0-9])", "")
        .str.strptime(pl.Date, format="%Y", strict=False)
        .alias("established_at"),
        pl.col("phone_number").str.replace_all(r"[^\d]", "").alias("phone_number"),
    )
    return df.select(OVERVIEW_COLS)


def clean_reviews(df: pl.DataFrame) -> pl.DataFrame:
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
    df = fill_missing_columns(df, REVIEW_COLS)
    df = df.with_columns(
        pl.col("pros")
        .cast(pl.String)
        .fill_null("")
        .str.replace_all(r"(\s+)", " ")
        .alias("pros"),
        pl.col("cons")
        .cast(pl.String)
        .fill_null("")
        .str.replace_all(r"(\s+)", " ")
        .alias("cons"),
    )
    df = df.filter(
        pl.col("review_rating").is_not_null(), pl.col("review_title").is_not_null()
    )
    df = df.with_columns(
        review_date=pl.col("review_date")
        .cast(pl.String)
        .str.strptime(pl.Date, format="%d/%m/%Y", strict=False)
    )
    return df.select(REVIEW_COLS)
