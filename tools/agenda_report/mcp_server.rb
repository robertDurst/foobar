# #!/usr/bin/env ruby

require 'bundler/setup'
require 'json'
require 'dotenv/load'
require 'mcp'
require_relative 'emailer'
require_relative 'reporter'
require_relative 'pdf_generator'


name "agenda_report"
version "0.1.0"

tool "send_daily_agenda_report" do
  description "Send the daily agenda report via email."
  argument :daily_agenda, String, required: true, description: "The daily agenda report content (text only)"
  call do |params|
    begin
      reporter = AgendaReport::Reporter.new
      result = reporter.generate_and_send_report(params['daily_agenda'])
      
      if result.is_a?(Hash) && result[:success]
        {
          success: true,
          message: result[:message],
          message_id: result[:message_id]
        }
      else
        raise MCP::Error.new(result.is_a?(Hash) ? result[:error] : "Failed to send report")
      end
    rescue => e
      raise MCP::Error.new("Failed to send report: #{e.message}")
    end
  end
end