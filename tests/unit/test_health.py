from fastapi.testclient import TestClient
import app.api.main as main
from app.api.main  import app

client = TestClient(app)


def test_health_endpoint():
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}
import app.api.main as main


def test_ready_endpoint_when_database_is_available(monkeypatch):
    monkeypatch.setenv("DATABASE_PASSWORD", "test-password")

    class FakeCursor:
        def execute(self, query):
            assert query == "SELECT 1"

        def fetchone(self):
            return (1,)

        def __enter__(self):
            return self

        def __exit__(self, *args):
            return False

    class FakeConnection:
        def cursor(self):
            return FakeCursor()

        def __enter__(self):
            return self

        def __exit__(self, *args):
            return False

    monkeypatch.setattr(
        main.psycopg,
        "connect",
        lambda **kwargs: FakeConnection()
    )

    response = client.get("/ready")

    assert response.status_code == 200
    assert response.json() == {
        "status": "ready",
        "database": "connected"
    }


def test_ready_endpoint_when_database_is_unavailable(monkeypatch):
    def fake_connect(**kwargs):
        raise RuntimeError("Database unavailable")

    monkeypatch.setattr(
        main.psycopg,
        "connect",
        fake_connect
    )

    response = client.get("/ready")

    assert response.status_code == 503
    assert response.json() == {
        "detail": "Database unavailable"
    }
