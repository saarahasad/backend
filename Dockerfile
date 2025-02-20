# Use a base image with glibc_2.28+
FROM ubuntu:20.04  # Ubuntu 20.04 includes glibc 2.31
WORKDIR /app


# Install required system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    chromium \
    chromium-driver \
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
    && rm -rf /var/lib/apt/lists/*

# Install Python
RUN apt-get install -y python3 python3-pip && ln -s /usr/bin/python3 /usr/bin/python

# Install application dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright and dependencies
RUN pip install playwright
RUN playwright install --with-deps

# Copy the application code
COPY . .

# Expose port 8080 for Cloud Run
EXPOSE 8080

# Run the application
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]
