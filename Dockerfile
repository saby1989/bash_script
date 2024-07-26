# Use an official Python runtime as a parent image
FROM python:3.10.6-slim-buster

# Set environment variables to prevent interactive prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Add Python to PATH if needed
ENV PATH="/usr/local/bin:${PATH}"

# Copy application files including shell scripts
COPY . /app

# Set the working directory
WORKDIR /app

# Install necessary packages and clean up apt caches to reduce image size
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    cron \
    curl \
    wget \
    pandoc \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy and install Quarto package
COPY packages/quarto-1.3.340-linux-amd64.deb /app/packages/
RUN dpkg -i /app/packages/quarto-1.3.340-linux-amd64.deb && \
    rm /app/packages/quarto-1.3.340-linux-amd64.deb

# Ensure shell scripts are executable
RUN chmod +x /app/shell_script/*.sh

#install packages

# Add and set permissions for the crontab file
COPY crontab /etc/cron.d/quarto-cron
RUN chmod 0644 /etc/cron.d/quarto-cron && \
    crontab /etc/cron.d/quarto-cron

# Create log file
RUN touch /var/log/cron.log

# Run cron in the foreground
CMD ["cron", "-f"]
