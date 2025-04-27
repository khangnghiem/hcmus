CREATE_SCHEMA = """CREATE SCHEMA IF NOT EXISTS company_reviews;"""
CREATE_TABLE_COMPANY = """CREATE TABLE IF NOT EXISTS company_reviews.company (
        extract_date DATE,
        link TEXT,
        name TEXT,
        location TEXT,
        department TEXT,
        PRIMARY KEY (extract_date, link)
    );
    """
CREATE_TABLE_COMPANY_OVERVIEW = """CREATE TABLE IF NOT EXISTS company_reviews.overview (
        extract_date DATE,
        link TEXT,
        website TEXT,
        phone_number TEXT,
        department TEXT,
        business_type TEXT,
        headquarter TEXT,
        scale TEXT,
        revenue TEXT,
        established_at DATE,
        description TEXT,
        insurance_policies TEXT,
        activities TEXT,
        background_history TEXT,
        mission TEXT,
        parent TEXT,
        parent_headquarter TEXT,
        PRIMARY KEY (extract_date, link)
    );
    """
CREATE_TABLE_COMPANY_REVIEW = """CREATE TABLE IF NOT EXISTS company_reviews.review (
        extract_date DATE,
        link TEXT,
        review_rating DOUBLE,
        review_title TEXT,
        review_position TEXT,
        review_date DATE,
        pros TEXT,
        cons TEXT,
        PRIMARY KEY (extract_date, link, review_rating, review_title)
    );
    """
