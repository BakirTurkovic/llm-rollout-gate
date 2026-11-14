# LLM Rollout Gate

**An evaluation and release gate for safer Large Language Model deployments.**

LLM Rollout Gate is an engineering project focused on evaluating candidate LLM versions before they replace an existing production model.

The goal is to build a system that can compare model behavior, measure performance and quality, detect regressions, and support evidence based deployment decisions.

Rather than blindly replacing a production model, the system aims to provide measurable evidence that a candidate version is ready for release.

## Project Vision

The planned system will support a controlled model evaluation workflow:

1. An existing production model continues handling real user requests.
2. A candidate model receives shadow copies of selected requests.
3. Responses from both models are collected and compared.
4. Evaluation metrics measure quality, latency, cost and reliability.
5. A decision engine determines whether the candidate should be promoted, rejected or evaluated further.

The existing production model must remain unaffected by candidate failures.

## Current Implementation

The project is currently in its infrastructure and backend foundation phase.

Implemented components:

• FastAPI backend with health and readiness endpoints.

• PostgreSQL 17 integration.

• Dockerized API and database services.

• Docker Compose orchestration.

• Persistent PostgreSQL storage.

• Container health checks and resource limits.

• Unit tests using pytest.

• GitHub Actions CI pipeline.

• Docker image build and publishing workflow using GitHub Container Registry.

## Architecture

The current infrastructure consists of:

| Component | Technology |
|---|---|
| Backend API | Python, FastAPI |
| Database | PostgreSQL 17 |
| Database connectivity | Psycopg |
| Containerization | Docker |
| Orchestration | Docker Compose |
| Testing | Pytest |
| CI/CD | GitHub Actions |
| Container registry | GitHub Container Registry |

### Current API

| Endpoint | Description |
|---|---|
| `GET /health` | Checks whether the API process is running |
| `GET /ready` | Checks whether the API can connect to PostgreSQL |

The readiness endpoint returns HTTP 503 when the database is unavailable.

## Local Development

### Prerequisites

• Docker Desktop or Docker Engine

• Docker Compose

• Git

### 1. Clone the repository

```bash
git clone https://github.com/BakirTurkovic/llm-rollout-gate.git
cd llm-rollout-gate
```

### 2. Configure environment variables

Create a `.env` file in the project root.

Example:

```env
POSTGRES_USER=llm_gate
POSTGRES_PASSWORD=change_me
POSTGRES_DB=llm_gate

DATABASE_HOST=postgres
DATABASE_PORT=5432
DATABASE_NAME=llm_gate
DATABASE_USER=llm_gate
DATABASE_PASSWORD=change_me
```

Use the same password for PostgreSQL and the API database connection.

Never commit real credentials.

### 3. Create the persistent volume

The current Compose configuration expects an external Docker volume.

```bash
docker volume create llm-gate-postgres-data
```

### 4. Start the services

```bash
docker compose up --build -d
```

### 5. Check container status

```bash
docker compose ps
```

### 6. Test the API

```bash
curl http://localhost:8000/health
```

```bash
curl http://localhost:8000/ready
```

Interactive API documentation is available at:

`http://localhost:8000/docs`

### 7. Stop the services

```bash
docker compose down
```

The persistent database volume is retained.

## CI/CD Pipeline

The GitHub Actions workflow currently contains two jobs.

### Test

Runs on pushes and pull requests targeting `main`.

• Checks out the repository.

• Sets up Python 3.12.

• Installs development dependencies.

• Validates Python syntax using compileall.

• Executes the pytest suite.

### Publish

Runs only after the test job succeeds on pushes to `main`.

• Configures Docker Buildx.

• Authenticates with GitHub Container Registry.

• Generates Docker image metadata.

• Builds and publishes the API image.

Images are configured with `latest` and commit SHA tags.

Container image:

`ghcr.io/bakirturkovic/llm-rollout-gate`

## Planned Development

The following capabilities represent the development roadmap, not currently implemented features.

### Backend Foundation
Database models, API structure, configuration management and experiment management.

### Model Evaluation
Model version tracking, paired responses, evaluation metrics and experiment history.

### Shadow Traffic
Background execution of candidate models without affecting production responses.

### Evaluation Engine
Quality evaluation, latency measurements, token usage, cost tracking and regression detection.

### Statistical Decision Engine
Confidence intervals, non inferiority checks and promotion decisions.

### Deployment Integration
Controlled rollouts and integration with deployment automation tools such as Argo Rollouts.

### Observability
Metrics, structured logging, distributed tracing and operational dashboards.

## Engineering Principles

• Production traffic must remain isolated from candidate failures.

• Evaluation decisions should be measurable and reproducible.

• Infrastructure should be automated and version controlled.

• Tests should validate critical system behavior.

• Every deployment decision should have traceable evidence.

## License

This project is licensed under the MIT License.
