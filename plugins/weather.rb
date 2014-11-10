require 'cinch'
require 'open-uri'
require 'json'
require 'cgi'

$weather_locations = {}

class Weather
	include Cinch::Plugin

	match /weather (.+)/
	match "weather", :method => "generic_execute"

	def weather(query)
		query = query.gsub(",", "").split(" ").join("/")
		url = "http://api.wunderground.com/api/#{CONFIG_WEATHER_API_KEY}/conditions/q/#{query}.json"
		res = JSON.parse(open(url).read)

		if res["response"]["results"]
			first = res["response"]["results"].first
			return weather([first["country"], first["state"], first["city"]].join(" "))
		end

		current = res["current_observation"]

		city = current["display_location"]["full"]
		station = current["station_id"]
		temp = current["temperature_string"]
		weather = current["weather"]
		humidity = current["relative_humidity"]
		wind = current["wind_mph"]
		wind_direction = current["wind_dir"]

		text = "#{city} (#{station}) | #{temp} | #{weather} | #{wind}mph #{wind_direction} | #{humidity} humidity"
	rescue
		"No results found"
	else
		CGI.unescape_html text
	end

	def generic_execute(m)
		if $weather_locations.has_key?(m.user.nick)
			m.reply(weather($weather_locations[m.user.nick]))
		else
			m.reply(weather("06790"))
		end
	end

	def execute(m, query)
		$weather_locations[m.user.nick] = query
		m.reply(weather(query))
	end
end
