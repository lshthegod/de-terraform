from fastapi import FastAPI
from fastapi.responses import PlainTextResponse


app = FastAPI(title="server2")


@app.get("/ping", response_class=PlainTextResponse)
def ping():
    return "pong"