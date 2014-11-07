require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'cgi'

class Google
	include Cinch::Plugin

	match /google (.+)/
	match /lmgtfy (.+)/

	def google(query)
		url = "http://www.google.com/search?q=#{CGI.escape(query)}"
		res = Nokogiri.parse(open(url).read).at("h3.r")

		title = res.text
		link = res.at('a')[:href]
		if link
			link = CGI::parse(link)["/url?q"]
		end
		desc = res.at("./following::div").children[1].text.gsub("\n", "")
	rescue
		"No results found"
	else
		CGI.unescape_html "#{title} - #{desc} (#{link})"
	end

	def execute(m, query)
		m.reply(google(query))
	end
end
