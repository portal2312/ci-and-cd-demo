# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.13-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libpq-dev sudo vim curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 8000

ARG USER_UID=1000
ARG USERNAME=appuser
ARG USER_WORKDIR=/app
ARG REQUIREMENT_FILENAME="requirements.txt"

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

WORKDIR ${USER_WORKDIR}

# Install pip requirements
COPY ${REQUIREMENT_FILENAME} .
RUN python -m pip install --upgrade pip && \
    python -m pip install -r ${REQUIREMENT_FILENAME}

COPY . ${USER_WORKDIR}

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser --uid ${USER_UID} --disabled-password --gecos "" ${USERNAME} && \
    chown -R ${USERNAME} ${USER_WORKDIR} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "project.wsgi"]
