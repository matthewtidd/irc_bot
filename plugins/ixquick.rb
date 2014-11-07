require 'cinch'
require 'rest-client'
require 'nokogiri'
require 'cgi'

class Ixquick
	include Cinch::Plugin

	match /ixquick (.+)/

	def ixquick(query)
		url = "https://ixquick.com/do/metasearch.pl"
		params = { :cat => "web", :cmd => "process_search", :language => "english", :engine0 => "v1all", :query => query, :abp => "01", :x => 0, :y => 0 }
		res = Nokogiri.parse(RestClient.post(url, params)).css("#first-result")

		title = res.at("a").text
		link = res.at('a')[:href]
		desc = res.at("p:last").text
	rescue
		"No results found"
	else
		if desc
			CGI.unescape_html "#{title} - #{desc} (#{link})"
		else
			CGI.unescape_html "#{title} (#{link})"
		end
	end

	def execute(m, query)
		m.reply(ixquick(query))
	end
end
