FROM python:3.12-slim

# Install ALL required system deps for Playwright Chromium (manual)
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxtst6 \
    xdg-utils \
    libxss1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy and install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Chromium ONLY (no --with-deps → avoids su)
RUN PLAYWRIGHT_BROWSERS_PATH=/ms-playwright playwright install chromium

# Set Playwright path
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Copy app
COPY . .

# Expose port
EXPOSE 10000

# Run as non-root
RUN useradd -m appuser
USER appuser

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "10000"]
