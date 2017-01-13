# Encoding: UTF-8

require 'rubygems'
require 'gosu'

WIDTH, HEIGHT = 600, 600

module ZOrder
  Background, Stars, Player, UI = *0..3
end

class Player
  attr_reader :score
  
  def initialize
    @image = Gosu::Image.new("media/starfighter.bmp")
    @beep = Gosu::Sample.new("media/beep.wav")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end
  
  def warp(x, y)
    @x, @y = x, y
  end
  
  def turn_left
    @angle -= 4.5
  end
  
  def turn_right
    @angle += 4.5
  end
  
  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end
  
  def move
    @x += @vel_x
    @y += @vel_y
    @x %= WIDTH
    @y %= HEIGHT
    
    @vel_x *= 0.95
    @vel_y *= 0.95
  end
  
  def draw
    @image.draw_rot(@x, @y, ZOrder::Player, @angle)
  end
  
  def collect_stars(stars)
    stars.reject! do |star|
      if Gosu::distance(@x, @y, star.x, star.y) < 35 then
        @score += 10
        @beep.play
        true
      else
        false
      end
    end
  end
end

class Star
  attr_reader :x, :y
  
  def initialize(animation)
    @animation = animation
    @color = Gosu::Color.new(0xff_000000)
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = rand * WIDTH
    @y = rand * HEIGHT
  end
  
  def draw
    img = @animation[Gosu::milliseconds / 100 % @animation.size]
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::Stars, 1, 1, @color, :add)
  end
end

class Tutorial < (Example rescue Gosu::Window)
  def initialize
    super WIDTH, HEIGHT
    
    self.caption = "Tutorial Game"
    
    @background_image = Gosu::Image.new("media/space.png", :tileable => true)
    
    @player = Player.new
    @player.warp(320, 240)
    
    @star_anim = Gosu::Image::load_tiles("media/star.png", 25, 25)
    @stars = Array.new
    
    @font = Gosu::Font.new(20)
  end
  
  def update
    if Gosu::button_down? Gosu::KbLeft or Gosu::button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if Gosu::button_down? Gosu::KbRight or Gosu::button_down? Gosu::GpRight then
      @player.turn_right
    end
    if Gosu::button_down? Gosu::KbUp or Gosu::button_down? Gosu::GpButton0 then
      @player.accelerate
    end
    @player.move
    @player.collect_stars(@stars)
    
    if rand(100) < 4 and @stars.size < 25 then
      @stars.push(Star.new(@star_anim))
    end
  end
  
  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    @stars.each { |star| star.draw }
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
  end
end

Tutorial.new.show if __FILE__ == $0

=begin
require 'gosu'

module ZOrder
  Background, Stars, Player, UI = *0..3
end

class Star
  attr_reader :x, :y

  def initialize(animation)
    @animation = animation
    @color = Gosu::Color.new(0xff_000000)
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = rand * 640
    @y = rand * 480
  end

  def draw  
    img = @animation[Gosu::milliseconds / 100 % @animation.size];
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::Stars, 1, 1, @color, :add)
  end
end

class Player

	attr_reader :score

	def initialize
    	@image = Gosu::Image.new("rocket.png")
	    @beep = Gosu::Sample.new("beep.wav")
	    @x = @y = @vel_x = @vel_y = @angle = 0.0
	    @score = 0
 	end

  	def warp(x, y)
    	@x, @y = x, y
  	end

  	def turn_left
    	@angle -= 4.5
  	end

	def turn_right
		@angle += 4.5
	end

	def accelerate
    	@vel_x += Gosu::offset_x(@angle, 0.5)
   	 	@vel_y += Gosu::offset_y(@angle, 0.5)
  	end

	def move
		@x += @vel_x
	    @y += @vel_y
	    @x %= 640
	    @y %= 480

	    @vel_x *= 0.95
	    @vel_y *= 0.95
	end

  	def draw
    	@image.draw_rot(@x, @y, 1, @angle)
  	end

  	def score
  		@score
  	end

  	def collect_stars(stars)
  		if stars.reject! do |star| 
  			if Gosu::distance(@x, @y, star.x, star.y) <35 then
  				@score += 10
  				@beep.play
  				true
  			else
  				false
  			end
  		end
 	end
end

class GameWindow < Gosu::Window
  def initialize
    super 640, 480 
    self.caption = "Battleship"

    @font = Gosu::Font.new(20)

    @background_image = Gosu::Image.new("SpaceBG.gif", :tileable => true)
  
 	@player = Player.new
    @player.warp(320, 240)

    @star_anim = Gosu::Image::load_tiles("star.png", 25, 25)
    @stars = Array.new
  end

  def update
    if Gosu::button_down? Gosu::KbLeft or Gosu::button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if Gosu::button_down? Gosu::KbRight or Gosu::button_down? Gosu::GpRight then
      @player.turn_right
    end
    if Gosu::button_down? Gosu::KbUp or Gosu::button_down? Gosu::GpButton0 then
      @player.accelerate
    end

    @player.move
    @player.collect_stars(@stars)

    if rand(100) < 4 and @stars.size < 25 then
      @stars.push(Star.new(@star_anim))
    end
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    @stars.each { |star| star.draw }
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xff_ffff00)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show
=end
# 
# module Game
# 	@grid1 = Array.new
# end

# class Player
# 	@grid = Array.new

# 	@len_2 = 1
# 	@len_3 = 2
# 	@len_4 = 1
# 	@len_5 = 1
# 	@sum = 5

# 	def initialize(num)
# 		@id = num
# 		puts "Hey Player #{@id}!"
# 	end

# 	def setUpGrid
# 		while @sum>0
# 			shipsRemaining()
# 			puts "Which length ship would you like to place?"
# 			putShip(gets)
# 		end
# 	end

# 	def shipsRemaining
# 		puts "Here's what you have left:"
# 		puts "Length-2 ships: #{@len_2}"
# 		puts "Length-3 ships: #{@len_3}"
# 		puts "Length-4 ships: #{@len_4}"
# 		puts "Length-5 ships: #{@len_5}"
# 	end

# 	def putShip(len)
# 		case len
# 		when 2
# 		when 3
# 		when 4
# 		when 5
# 		else
# 		end
# 	end
# end

# player1 = Player.new(1)
# 
