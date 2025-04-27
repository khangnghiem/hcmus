import polars as pl
from clean_company_reviews import clean_companies


def test_clean_companies():
    # Create a sample DataFrame
    df = pl.DataFrame(
        {
            "department": [
                "Sales/Marketing",
                "Dev/ DevOps",
                "HR /Finance",
                "IT / Support",
            ]
        }
    )

    # Expected output after cleaning
    expected_df = pl.DataFrame(
        {
            "department": [
                "Sales / Marketing",
                "Dev / DevOps",
                "HR / Finance",
                "IT / Support",
            ]
        }
    )

    # Apply the clean_companies function
    cleaned_df = clean_companies(df)

    # Assert the cleaned DataFrame matches the expected DataFrame
    assert cleaned_df.equals(expected_df)
