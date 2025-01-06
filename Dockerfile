# Stage 1: Build Stage
FROM python:3.9-slim AS builder

# Set the working directory for the build stage
WORKDIR /app/backend

# Install build dependencies (like wheel) to build any C extensions or packages
RUN apt-get update && apt-get install -y build-essential

# Copy the requirements file to install dependencies
COPY requirements.txt /app/backend/

# Install dependencies in the build stage
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Final Stage (runtime image)
FROM python:3.9-slim

# Set the working directory for the final stage
WORKDIR /app/backend

# Copy the installed Python packages from the build stage
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# Copy the application code (excluding unnecessary files like tests, docs, etc.)
COPY . /app/backend/

# Expose port 8000 for the app to run
EXPOSE 8000

# Set the default command to start the Django server
CMD ["python", "/app/backend/manage.py", "runserver", "0.0.0.0:8000"]
