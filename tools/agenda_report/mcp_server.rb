#!/usr/bin/env ruby

require 'bundler/setup'
require 'json'
require 'dotenv/load'
require 'model_context_protocol'
require 'model_context_protocol/transports/stdio'
require_relative 'emailer'
require_relative 'reporter'
require_relative 'pdf_generator'

# Define the SendDailyAgendaReport tool
class SendDailyAgendaReport < ModelContextProtocol::Tool
  description "Send the daily agenda report via email."
  
  input_schema(
    properties: {
      daily_agenda: {
        type: "string",
        description: "The daily agenda report content (text only)"
      }
    },
    required: ["daily_agenda"]
  )

  class << self
    def call(daily_agenda:, server_context: {})
      begin
        reporter = AgendaReport::Reporter.new
        result = reporter.generate_and_send_report(daily_agenda)
        
        if result.is_a?(Hash) && result[:success]
          ModelContextProtocol::Tool::Response.new([
            {
              type: "text",
              text: result[:message]
            },
            {
              type: "data",
              data: {
                success: true,
                message: result[:message],
                message_id: result[:message_id]
              }
            }
          ])
        else
          error_message = result.is_a?(Hash) ? result[:error] : "Failed to send report"
          raise ModelContextProtocol::Error::ToolExecutionError.new(error_message)
        end
      rescue => e
        raise ModelContextProtocol::Error::ToolExecutionError.new("Failed to send report: #{e.message}")
      end
    end
  end
end

# Set up the server with debug output
ModelContextProtocol.configure do |config|
  config.instrumentation_callback = ->(data) {
  }
  
  config.exception_reporter = ->(exception, server_context) {
  }
end

# Set up the server
server = ModelContextProtocol::Server.new(
  name: "agenda_report",
  tools: [SendDailyAgendaReport]
)

# Create a transport and start the server
if __FILE__ == $0  # Only start the server when the script is run directly
  transport = ModelContextProtocol::Transports::StdioTransport.new(server)
  transport.open
end
