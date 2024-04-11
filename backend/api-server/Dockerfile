FROM python:3.10

WORKDIR /app

COPY api-server .

RUN pip install -r requirements.txt

WORKDIR /app/src

CMD [ "python3", "api.py" ]