FROM python:3.12.3

WORKDIR /app
COPY . .

# APT (can be skipped if no packages are needed)
RUN apt-get update && \
    apt-get install -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r master.txt

# Debug: check files
RUN ls -la && cat serverV3.py || true

# Create a temporary test script to catch errors in serverV3.py
RUN echo 'import traceback\ntry:\n    exec(open("serverV3.py").read())\nexcept Exception:\n    traceback.print_exc()\n    exit(1)' > test_server.py

ENV PYTHONPATH=/app
# Run test script
RUN python test_server.py

# Default container command
CMD ["python", "./main.py"]

