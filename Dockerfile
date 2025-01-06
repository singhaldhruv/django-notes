# Stage 1: Build Stage
FROM python:3.9 AS builder

# Set the working directory for the build stage
WORKDIR /app/backend

# Copy the requirements file to install dependencies
COPY requirements.txt /app/backend/

# Install dependencies in the build stage
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Final Stage
FROM python:3.9

# Set the working directory for the final stage
WORKDIR /app/backend

# Copy the installed Python packages from the build stage
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# Copy the rest of the application code to the final stage
COPY . /app/backend/

# Expose port 8000 for the app to run
EXPOSE 8000

# Set the default command to start the Django server
CMD ["python", "/app/backend/manage.py", "runserver", "0.0.0.0:8000"]

