# Plan for Agentic Cron Job Using Ruby LLM

This document outlines a proposed structure for creating a cron-based agentic workflow using the [ruby_llm](https://github.com/crmne/ruby_llm) library. The goal is to have a scheduled process that triggers automatically, leverages ruby_llm to reason about tasks, and executes those tasks on behalf of the user.

## Overview

1. **Cron Trigger** – Use the system cron scheduler to start a script at a predefined interval or based on a chosen schedule.
2. **Task Script** – Implement a Ruby script that uses ruby_llm to perform the desired workflow when invoked by cron. This script will interact with any required tools or APIs.
3. **Logging & Notifications** – Capture logs for troubleshooting and optionally send notifications upon completion or failure.

## Proposed File Structure

```
project_root/
├── docs/
│   └── cron_job_plan.md      # This planning document
├── scripts/
│   └── agentic_cron.rb       # Entry point for the cron job
├── config/
│   └── cron_schedule         # Cron schedule file or instructions
├── tools/                    # Existing tools (agenda_report, weather, etc.)
└── README.md
```

- `scripts/agentic_cron.rb` will contain the logic to initialize ruby_llm, define available tools, and execute the desired workflow.
- `config/cron_schedule` (or similar) can document the cron syntax for installing the job with `crontab`.

## Example Workflow

1. **Initialization**
   - Load environment variables and any credentials needed by tools.
   - Configure ruby_llm with a prompt that explains available actions.
2. **Determine Task**
   - Use ruby_llm to reason about which tool to invoke or what action to take. For example, gather weather information or generate a daily report.
3. **Perform Action**
   - Call existing helper classes (e.g., from `tools/agenda_report`) or implement new ones. Pass results back to ruby_llm if further reasoning is required.
4. **Output & Cleanup**
   - Save outputs, send emails, or perform other side effects.
   - Log important events for debugging.

## Setting Up Cron

1. Create an executable wrapper script or use `bin/rails` style script to run `scripts/agentic_cron.rb`.
2. Install the cron job, e.g., with `crontab -e`:

```
# Example: run every day at 8am
0 8 * * * /usr/bin/env ruby /path/to/project/scripts/agentic_cron.rb >> /path/to/project/log/cron.log 2>&1
```

3. Ensure the environment (e.g., Ruby version, required gems) is properly configured in the cron context. Using a wrapper shell script can help set up `rbenv` or `rvm` as needed.

## Next Steps

- Build `scripts/agentic_cron.rb` with ruby_llm integration.
- Document configuration variables and authentication requirements.
- Test the cron job manually before enabling it on a schedule.

