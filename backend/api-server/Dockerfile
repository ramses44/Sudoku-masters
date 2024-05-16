FROM python:3.10

WORKDIR /app

COPY api-server/requirements.txt .

RUN pip install -r requirements.txt

COPY api-server/rsa-keys ./rsa-keys
COPY api-server/src ./src

WORKDIR /app/src

CMD [ "python3", "api.py" ]