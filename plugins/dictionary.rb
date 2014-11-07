require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'cgi'

load '../config.rb'

class Dictionary
	include Cinch::Plugin

	match /dictionary (.+)/

	def dictionary(query)
		url = "http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{CGI.escape(query)}?key=#{CONFIG_DICTIONARY_API_KEY}"
		res = Nokogiri.parse(open(url).read).at("entry")
		definition = res.at("def")
		definition.search("date").remove
		definition = definition.text
	rescue
		"No results found"
	else
		CGI.unescape_html "#{query} #{definition}"
	end

	def execute(m, query)
		m.reply(dictionary(query))
	end
end
