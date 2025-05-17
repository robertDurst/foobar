FROM ruby:3.1-alpine

RUN apk add --no-cache cron

WORKDIR /app
COPY scripts/agentic_cron.rb /app/scripts/agentic_cron.rb
COPY config/cron_schedule /etc/crontabs/root
RUN chmod +x /app/scripts/agentic_cron.rb && chmod 0644 /etc/crontabs/root

CMD ["crond", "-f"]
