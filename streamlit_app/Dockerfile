FROM python:3.11.5-bookworm

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir -r requirements.txt

RUN curl -fsSL https://code-server.dev/install.sh | sh
