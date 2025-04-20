from fastapi import FastAPI
import duckdb

app = FastAPI()

worksml_db = "~/Filen/data/db/worksml.db"

@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/courses")
def read_courses():
    courses = duckdb.sql(f"""
        ATTACH {worksml_db} as worksml_db;
        SELECT * FROM worksml_db.courses;
        """)
    # courses = conn.sql("SELECT * FROM courses")
    print(f"{courses=}")
    duckdb.close()
    return {"courses": courses}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
