FROM rei233/lazy-beancount:latest

# Switch to root user for package installation
USER root



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