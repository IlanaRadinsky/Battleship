require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "Battleship"
  end

  def update
  end

  def draw
  end
end

window = GameWindow.new
window.show


=begin
module Game
	@grid1 = Array.new
end

class Player
	@grid = Array.new

	@len_2 = 1
	@len_3 = 2
	@len_4 = 1
	@len_5 = 1
	@sum = 5

	def initialize(num)
		@id = num
		puts "Hey Player #{@id}!"
	end

	def setUpGrid
		while @sum>0
			shipsRemaining()
			puts "Which length ship would you like to place?"
			putShip(gets)
		end
	end

	def shipsRemaining
		puts "Here's what you have left:"
		puts "Length-2 ships: #{@len_2}"
		puts "Length-3 ships: #{@len_3}"
		puts "Length-4 ships: #{@len_4}"
		puts "Length-5 ships: #{@len_5}"
	end

	def putShip(len)
		case len
		when 2
		when 3
		when 4
		when 5
		else
		end
	end
end

player1 = Player.new(1)
=end
