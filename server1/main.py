import os
from pathlib import Path

import requests
from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse, PlainTextResponse


app = FastAPI(title="server1-web")


def backend_url() -> str:
    return os.getenv("SERVER2_URL", "http://server2:8000")


@app.get("/", response_class=HTMLResponse)
def index():
    index_path = Path(__file__).with_name("index.html")
    if not index_path.exists():
        return HTMLResponse("<h1>index.html not found</h1>", status_code=500)
    return HTMLResponse(index_path.read_text(encoding="utf-8"))


@app.get("/api/ping", response_class=PlainTextResponse)
def api_ping():
    try:
        r = requests.get(f"{backend_url()}/ping", timeout=3)
        r.raise_for_status()
        return r.text
    except requests.RequestException as e:
        raise HTTPException(status_code=502, detail=str(e))
