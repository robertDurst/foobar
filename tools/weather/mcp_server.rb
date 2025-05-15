#!/usr/bin/env ruby

require 'bundler/setup'
require 'model_context_protocol'
require 'model_context_protocol/transports/stdio'
require_relative 'weather_service'

class GetWeather < ModelContextProtocol::Tool
  description "Get the current weather for a specified location."
  
  input_schema(
    properties: {
      location: {
        type: "string",
        description: "The city or location to get weather for"
      }
    },
    required: ["location"]
  )

  class << self
    def call(location:, server_context: {})
      begin
        weather_service = WeatherService.new
        weather_data = weather_service.get_weather(location)
        
        ModelContextProtocol::Tool::Response.new([
          {
            type: "text",
            text: "Weather for #{location}: #{weather_data[:description]}, temperature: #{weather_data[:temperature]}°C"
          },
          {
            type: "data",
            data: weather_data
          }
        ])
      rescue => e
        raise ModelContextProtocol::Error::ToolExecutionError.new("Failed to get weather: #{e.message}")
      end
    end
  end
end

server = ModelContextProtocol::Server.new(
  name: "weather",
  tools: [GetWeather]
)

if __FILE__ == $0
  transport = ModelContextProtocol::Transports::StdioTransport.new(server)
  transport.open
end