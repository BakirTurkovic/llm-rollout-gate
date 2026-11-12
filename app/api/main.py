import os

import psycopg
from fastapi import FastAPI, HTTPException

app = FastAPI()


@app.get("/health")
def health():
    return {"status": "healthy"}


@app.get("/ready")
def readiness():
    try:
        with psycopg.connect(
            host=os.getenv("DATABASE_HOST", "postgres"),
            port=os.getenv("DATABASE_PORT", "5432"),
            dbname=os.getenv("DATABASE_NAME", "llm_gate"),
            user=os.getenv("DATABASE_USER", "llm_gate"),
            password=os.environ["DATABASE_PASSWORD"],
            connect_timeout=3,
        ) as connection:
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1")
                cursor.fetchone()

        return {
            "status": "ready",
            "database": "connected"
        }

    except Exception:
        raise HTTPException(
            status_code=503,
            detail="Database unavailable"
        )
