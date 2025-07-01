# Use Amazon Linux 2023 base image
FROM amazonlinux:2023

# Install system packages and Python 3.12
RUN yum -y update && \
    yum -y install gcc zlib-devel bzip2 bzip2-devel readline-devel \
    sqlite sqlite-devel openssl-devel wget make xz tar git && \
    cd /usr/src && \
    wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz && \
    tar xzf Python-3.12.0.tgz && \
    cd Python-3.12.0 && \
    ./configure --enable-optimizations && \
    make altinstall && \
    ln -s /usr/local/bin/python3.12 /usr/bin/python3 && \
    ln -s /usr/local/bin/pip3.12 /usr/bin/pip3

# Set working directory
WORKDIR /app

# Copy all files to container
COPY . .

# Install Python dependencies
RUN pip3 install --upgrade pip && \
    pip3 install -r requirements.txt

# Run sql.py first, then app.py
CMD ["sh", "-c", "python3 sql.py && python3 app.py"]
