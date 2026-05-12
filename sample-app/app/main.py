from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello from DevLaunch IDP Lite!"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.get("/metrics")
def metrics():
    # Placeholder for Prometheus metrics
    return {"requests_total": 1, "uptime": "100%"}
