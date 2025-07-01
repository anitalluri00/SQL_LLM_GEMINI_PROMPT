# Use Amazon Linux 2023 base image
FROM public.ecr.aws/amazonlinux/amazonlinux:2023

# Install Python 3.12 and required tools
RUN dnf -y update && \
    dnf install -y gcc git wget tar make zlib-devel bzip2 bzip2-devel \
    readline-devel sqlite sqlite-devel openssl-devel xz xz-devel \
    libffi-devel findutils && \
    cd /usr/src && \
    wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz && \
    tar xzf Python-3.12.0.tgz && \
    cd Python-3.12.0 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall && \
    ln -s /usr/local/bin/python3.12 /usr/bin/python3 && \
    ln -s /usr/local/bin/pip3.12 /usr/bin/pip3

# Set working directory
WORKDIR /app

# Copy all files to the container
COPY . .

# Install dependencies
RUN pip3 install --upgrade pip && pip3 install -r requirements.txt

# Run SQL setup first, then launch Streamlit app
CMD python3 sql.py && streamlit run app.py --server.port=8501 --server.address=0.0.0.0
