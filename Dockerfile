# Start with Amazon Linux 2023 base image
FROM amazonlinux:2023

# Install necessary tools and Python 3.13
RUN dnf -y update && \
    dnf -y install \
    gcc \
    gcc-c++ \
    make \
    tar \
    wget \
    git \
    sqlite \
    xz && \
    dnf clean all

# Install Python 3.13 manually
RUN curl -O https://www.python.org/ftp/python/3.13.0/Python-3.13.0.tar.xz && \
    tar -xf Python-3.13.0.tar.xz && \
    cd Python-3.13.0 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf Python-3.13.0*

# Set Python 3.13 as default
RUN ln -sf /usr/local/bin/python3.13 /usr/bin/python && \
    ln -sf /usr/local/bin/pip3.13 /usr/bin/pip

# Set working directory
WORKDIR /app

# Copy application code
COPY . /app

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Command to run sql.py first, then app.py
CMD ["sh", "-c", "python sql.py && python app.py"]
