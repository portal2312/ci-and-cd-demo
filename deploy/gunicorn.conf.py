"""Gunicorn configuration.

Reference:
    https://docs.gunicorn.org/en/latest/deploy.html#deploying-gunicorn
    https://docs.gunicorn.org/en/stable/settings.html#config-file
    https://www.uvicorn.org/deployment/
    https://github.com/Kludex/uvicorn-worker
    https://docs.djangoproject.com/en/5.2/howto/deployment/wsgi/gunicorn/
"""

# https://docs.gunicorn.org/en/stable/settings.html#bind
bind = "0.0.0.0:8000"

# https://docs.gunicorn.org/en/stable/settings.html#workers
workers = 4

# https://docs.gunicorn.org/en/stable/settings.html#worker-class
worker_class = "uvicorn_worker.UvicornWorker"

# https://docs.gunicorn.org/en/stable/settings.html#loglevel
loglevel = "info"

# https://docs.gunicorn.org/en/stable/settings.html#timeout
timeout = 60

# https://docs.gunicorn.org/en/stable/settings.html#pythonpath
pythonpath = "/app/server"

# https://docs.gunicorn.org/en/stable/settings.html#accesslog
accesslog = "/app/gunicorn-access.log"

# https://docs.gunicorn.org/en/stable/settings.html#errorlog
errorlog = "/app/gunicorn-error.log"
