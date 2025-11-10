# syntax=docker/dockerfile:1
# Use official Python 3.6 image by default; switch to 3.6.6 with a build-arg.
ARG PYTHON_IMAGE=python:3.6.15-slim
FROM ${PYTHON_IMAGE}

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    # seed tool versions compatible with Python 3.6
    VIRTUALENV_PIP=21.3.1 \
    VIRTUALENV_SETUPTOOLS=49.6.0 \
    VIRTUALENV_WHEEL=0.34.2

# If you change PYTHON_IMAGE to a very old Debian (stretch/buster),
# you may need archived apt mirrors. Uncomment the block below if apt fails.
# RUN sed -i -e 's|deb.debian.org|archive.debian.org|g' \
#            -e 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list \
#  && apt-get -o Acquire::Check-Valid-Until=false update

RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential gcc libpq-dev curl \
  && rm -rf /var/lib/apt/lists/*

# Pin bootstrap tools for Python 3.6
RUN python -m pip install --upgrade "pip<22" "setuptools<50" "wheel<0.35" \
  && pip install "virtualenv==20.17.1" "pipenv==2022.1.8"

WORKDIR /app

# Copy Pipfile(+lock if present) first to leverage Docker layer cache
COPY Pipfile Pipfile.lock* ./

# Install deps into system site-packages (no nested venv)
# --deploy uses Pipfile.lock if present; falls back to Pipfile otherwise
RUN PIPENV_IGNORE_VIRTUALENVS=1 PIPENV_VENV_IN_PROJECT=0 \
    pipenv install --deploy --system || \
    (echo 'No lock or lock incompatible; installing from Pipfile' && pipenv install --system)

# Now copy the rest of the app
COPY . .

# Gunicorn default port
EXPOSE 8000

CMD sh -c "python manage.py && gunicorn -b 0.0.0.0:8000 app:app"
