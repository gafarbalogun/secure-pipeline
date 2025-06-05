# Start with Python slim image
FROM python:3.9-slim-bullseye AS builder

# Set working directory
WORKDIR /app

# Install Bandit (Python security tool)
RUN pip install --no-cache-dir bandit

# Copy Bandit configuration into the container
COPY .bandit.yml /app/.bandit.yml

# Copy requirements first
COPY app/requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create non-root user
RUN groupadd -r appuser && \
    useradd -r -g appuser appuser

# Copy application code
COPY app/ .

# Now create the reports directory and set correct permissions
RUN mkdir -p /reports && chown appuser:appuser /reports

# Switching to non-root user (AFTER installing security tools & setting permissions)
USER appuser

# Flask application port
EXPOSE 5000

# Runs the application
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]

