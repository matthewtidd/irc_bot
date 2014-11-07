require 'cinch'

class Memo < Struct.new(:nick, :channel, :text, :time)
	def to_s
		"[#{time.asctime}] <#{channel}/#{nick}> #{text}"
	end
end

$memos = {}

class MemoPlugin
	include Cinch::Plugin

	attr_accessor :memos

	match /memo (.+?) (.+)/
	match /.*/, :method => :consume, :use_prefix => false

	def consume(m)
		if $memos.has_key?(m.user.nick)
			m.user.send $memos.delete(m.user.nick).to_s
		end
	end

	def execute(m, nick, message)
		if $memos.key?(nick)
			m.reply "There's already a memo for #{nick}. You can only store one right now"
		elsif nick == m.user.nick
			m.reply "You can't leave memos for yourself.."
		elsif nick == bot.nick
			m.reply "You can't leave memos for me.."
		else
			$memos[nick] = Memo.new(m.user.nick, m.channel, message, Time.now)
			m.reply "Added memo for #{nick}"
		end
	end
end
