require 'cinch'
require 'dalli'

options = { :namespace => "irc_bot", :compress => true }
$client = Dalli::Client.new(CONFIG_MEMCACHED_ADDRESS, options)

class DataStore
	include Cinch::Plugin

	match /get (.+)/, :method => "get"
	match /put (.+?) (.+)/, :method => "put"
	match /save (.+?) (.+)/, :method => "put"
	match /set (.+?) (.+)/, :method => "put"

	def get(m, key)
		m.reply("#{key} = #{$client.get(key).to_s}")
	end

	def put(m, key, value)
		$client.set(key, value)
		m.reply("#{key} = #{value}")
	end
end
