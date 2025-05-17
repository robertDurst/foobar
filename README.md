# Daily Agenda Reporter

MCP server with a tool to send a PDF to an email with the daily agenda report.

## Docker Example

A minimal Docker image is included that runs a simple cron job. The cron job
executes `scripts/agentic_cron.rb` every minute and prints a message to the
container logs.

Build the image:

```bash
docker build -t cron-example .
```

Run the container:

```bash
docker run --rm cron-example
```

You should see "Hello from the cron job" messages output once per minute.
