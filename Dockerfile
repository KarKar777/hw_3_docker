FROM python:3.13-slim

WORKDIR /app
COPY app/app.py .
COPY app/requirements.txt .

RUN pip install -r requirements.txt

EXPOSE 8000
CMD ["python", "app.py"]
