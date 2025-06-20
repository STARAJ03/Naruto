FROM python:3.12.3

WORKDIR /app
COPY . .

# Update and clean APT packages (no packages listed, so this line is safe to remove too if no packages needed)
RUN apt-get update && \
    apt-get install -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip and install dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r master.txt

# Debug: List files and print serverV3.py content
RUN echo "Listing files in /app..." && ls -la && \
    echo "Showing serverV3.py contents..." && cat serverV3.py

# Debug: Run serverV3.py with traceback to catch errors during build
RUN python -c "import traceback; \
try: \
    exec(open('serverV3.py').read()); \
except Exception: \
    traceback.print_exc(); \
    exit(1)"

# Default container start command
CMD ["python", "./main.py"]
