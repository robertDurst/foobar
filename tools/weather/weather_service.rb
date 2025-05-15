class WeatherService
  def get_weather(location)
    {
      temperature: rand(10..30),
      humidity: rand(40..90),
      description: ["Sunny", "Cloudy", "Rainy", "Partly cloudy", "Clear"].sample,
      feels_like: rand(8..32)
    }
  end
end