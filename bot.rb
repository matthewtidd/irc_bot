require 'cinch'

Dir.glob('./plugins/*.rb') do |item|
	load item
end

bot = Cinch::Bot.new do
	configure do |c|
		c.server = CONFIG_SERVER
		c.nick = CONFIG_NICK
		c.channels = CONFIG_CHANNELS
		c.plugins.plugins = [DiceRoll, RandomRoll, MemoPlugin, Google, Dictionary, Ixquick]
	end
end

bot.start
