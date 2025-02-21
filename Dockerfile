# Use a lightweight Python base image
FROM python:3.11-slim

WORKDIR /app

# Install required system dependencies for Playwright & Chromium
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxrandr2 \
    libasound2 \
    libxdamage1 \
    libxfixes3 \
    libxi6 \
    libxrender1 \
    libcups2 \
    libxshmfence1 \
    libgbm1 \
    fonts-liberation \
    libappindicator3-1 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libxshmfence1 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Playwright and force Chromium installation
RUN pip install --no-cache-dir playwright \
    && playwright install --with-deps chromium  && ls -la /root/.cache/ms-playwright/chromium-*

# Set Playwright to use the correct Chromium binary path
ENV PLAYWRIGHT_BROWSERS_PATH="/home/runner/.cache/ms-playwright/chromium-1140/chrome-linux/chrome" 

# Copy application dependencies first (for better caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Expose port 8080 for Google Cloud Run
EXPOSE 8080

# Run the application
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]
