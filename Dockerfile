# Use Amazon Linux 2023 as base
FROM amazonlinux:2023

# Set environment vars
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Install Python3, pip, and other essentials
RUN yum -y update && \
    yum install -y python3 python3-pip && \
    yum clean all

# Set working directory
WORKDIR /app

# Copy all project files
COPY . .

# Install dependencies — skip pip upgrade
RUN pip3 install -r requirements.txt


# Run SQL setup first, then Streamlit app
CMD ["sh", "-c", "python3 sql.py && streamlit run app.py"]
