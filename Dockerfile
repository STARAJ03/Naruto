FROM python:3.12.3

WORKDIR /app
COPY . .

# Add current directory to PYTHONPATH for local imports
ENV PYTHONPATH=/app

# Install dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r master.txt

# Show structure to debug
RUN ls -la /app && echo "Python path:" && python -c "import sys; print(sys.path)"

# Create test_server.py safely using tee
RUN tee test_server.py > /dev/null <<EOF
import traceback
try:
    exec(open("serverV3.py").read())
except Exception:
    traceback.print_exc()
    exit(1)
EOF

# Run the test script
RUN python test_server.py

# Default command
CMD ["python", "./main.py"]
