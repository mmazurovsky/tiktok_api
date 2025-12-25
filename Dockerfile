# syntax=docker/dockerfile:1
FROM python:3.11-slim

LABEL maintainer="mmazurovsky"

WORKDIR /app

# Copy the entire project
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set Python path to include app directory
ENV PYTHONPATH=/app

# Expose port (default is 80 from config.yaml)
EXPOSE 80

# Start the application using uvicorn directly
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80", "--timeout-keep-alive", "300", "--timeout-graceful-shutdown", "300"]
