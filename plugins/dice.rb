require 'cinch'

class DiceRoll
	include Cinch::Plugin

	# [[<repeats>#]<rolls>]d<sides>[<+/-><offset>]
	match(/(?:(?:(\d+)#)?(\d+))?d(\d+)(?:([+-])(\d+))?/)
	def execute(m, repeats, rolls, sides, offset_op, offset)
		repeats = repeats.to_i
		repeats = 1 if repeats < 1
		rolls   = rolls.to_i
		rolls   = 1 if rolls < 1
		sides   = sides.to_i
		sides   = 1 if sides < 1

		total = 0

		repeats.times do
			rolls.times do
				score = rand(sides) + 1
				if offset_op
					score = score.send(offset_op, offset.to_i)
				end
				total += score
			end
		end

		m.reply "#{total}", true
	end
end

class RandomRoll
	include Cinch::Plugin

	match "random"
	match "rand"
	match "rnd"
	match "roll"

	def execute(m)
		m.reply "#{rand(100) + 1}", true
	end
end
