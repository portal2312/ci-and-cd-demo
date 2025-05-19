"""Gunicorn configuration."""

bind = "0.0.0.0:8000"
workers = 4
worker_class = "uvicorn_worker.UvicornWorker"
loglevel = "info"
timeout = 60
