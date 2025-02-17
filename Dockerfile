FROM python:3.11-slim

# Install necessary system dependencies required for Playwright and psycopg2
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    libx11-dev \
    libgtk-3-0 \
    libdbus-1-3 \
    libgdk-pixbuf2.0-0 \
    libasound2 \
    libnss3 \
    libxss1 \
    libxtst6 \
    libappindicator3-1 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libgdk-pixbuf2.0-0 \
    libnspr4 \
    libxcomposite1 \
    libxrandr2 \
    libgbm-dev \
    libpq-dev \
    build-essential \ 
    python3-dev \     
    && apt-get clean

# Set the working directory for your app
WORKDIR /app

# Copy the project files into the container
COPY . /app

# Upgrade pip and setuptools
RUN pip install --upgrade pip setuptools

# Install Python dependencies (including psycopg2 and Playwright)
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright and its browsers
RUN python -m playwright install

# Expose the application port
EXPOSE 8000

# Start the application using Gunicorn (or any other WSGI server)
CMD ["gunicorn", "app:app"]
