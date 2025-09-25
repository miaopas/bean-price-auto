FROM python:3.12-slim

# Install cron and other necessary packages
RUN apt-get update && apt-get install -y \
    cron \
    && rm -rf /var/lib/apt/lists/*

# Install bean-price (adjust this based on how you install bean-price)
# If bean-price is a Python package:
RUN pip install beanprice

# If you need to install from source or other method, adjust accordingly
# RUN pip install git+https://github.com/beancount/beanprice.git

# Create working directory
WORKDIR /app

# Create the script that runs bean-price
COPY run_bean_price.sh /app/run_bean_price.sh
RUN chmod +x /app/run_bean_price.sh

# Create cron job file
COPY crontab /etc/cron.d/bean-price-cron
RUN chmod 0644 /etc/cron.d/bean-price-cron
RUN crontab /etc/cron.d/bean-price-cron

# Create log directory
RUN mkdir -p /var/log

# Start cron service
CMD ["cron", "-f"]