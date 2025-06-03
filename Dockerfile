#  Python slim image
FROM python:3.9-slim-bullseye

#  Working directory
WORKDIR /app

# Application dependencies
COPY app/requirements.txt .

# Installing dependencies 
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY app/ .

# Creating a non root user
RUN groupadd -r appuser && useradd -r -g appuser appuser
USER appuser

# Expose Flask's default port
EXPOSE 5000

# Start the Flask app using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]

