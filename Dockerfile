FROM python:3.11-slim

# Install system dependencies required for Playwright
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
    && apt-get clean

# Set the working directory in the container
WORKDIR /app

# Copy the application files into the container
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright and the required browser
RUN python -m playwright install

# Expose the port the app runs on
EXPOSE 8000

# Start the app using Gunicorn (or your preferred WSGI server)
CMD ["gunicorn", "app:app"]
