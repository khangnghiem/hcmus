import sys
from pathlib import Path
import pytest
import polars as pl
from datetime import date

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from utils.io_helpers import read_extract


@pytest.fixture
def csv_file(tmp_path):
    file_path = tmp_path / "2023-10-01_test.csv"
    file_path.write_text("id,name\n1,Company A\n2,Company B")
    return str(file_path)


@pytest.fixture
def json_file(tmp_path):
    file_path = tmp_path / "2023-10-01_test.json"
    file_path.write_text(
        '[{"id": 1, "name": "Company A"}, {"id": 2, "name": "Company B"}]'
    )
    return str(file_path)


def test_read_file_and_date_csv(csv_file):
    df = read_extract(csv_file)
    assert isinstance(df, pl.DataFrame)
    assert "extract_date" in df.columns
    assert df["extract_date"][0] == date(2023, 10, 1)


def test_read_file_and_date_json(json_file):
    df = read_extract(json_file)
    assert isinstance(df, pl.DataFrame)
    assert "extract_date" in df.columns
    assert df["extract_date"][0] == date(2023, 10, 1)


def test_read_file_and_date_invalid_format(tmp_path):
    invalid_file = tmp_path / "2023-10-01_test.txt"
    invalid_file.write_text("Invalid content")
    with pytest.raises(
        ValueError, match="Unsupported file format. Only .csv and .json are supported."
    ):
        read_extract(str(invalid_file))


def test_read_file_and_date_invalid_date_format(tmp_path):
    invalid_date_file = tmp_path / "invalid_date_test.csv"
    invalid_date_file.write_text("id,name\n1,Company A\n2,Company B")
    with pytest.raises(ValueError, match="Invalid date format. Expected YYYY-MM-DD."):
        read_extract(str(invalid_date_file))
