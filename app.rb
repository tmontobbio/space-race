require 'ruby2d'

set title: 'Space-Race'
set width: 800, height: 600
FLY_SPEED = 5


####################### MISC CLASSES #######################
class Player
  WIDTH = 64
  HEIGHT = 64
  @score = 0
  def initialize (x, y)
    @ship = Sprite.new(
      'assets/gray-ship.png',
      width:WIDTH,
      height:HEIGHT,
      clip_width:128,
      time:150,
      y:x,
      x:y,
      animations: {
                    idle: 0..7,
                    fly: 8..15,
                    crash: 16..24
                  }
    )
  end

  def score_up
    @score += 1
  end

  def idle
    @ship.play(animation: :idle, loop: true)
  end

  def fly
    @ship.play(animation: :fly, loop: true)
  end

  def crash
    @ship.play(animation: :crash, loop: true)
  end

  def move(direction)
    case direction
      when :left
      @ship.play animation: :fly, loop: true
      if @ship.x < (Window.width - @ship.width)
        @ship.x -= FLY_SPEED
      end
      when :right
      @ship.play animation: :fly, loop: true
      if @ship.x < (Window.width - @ship.width)
        @ship.x += FLY_SPEED
      end
      when :up
      @ship.play animation: :fly, loop: true
      if @ship.y > 0
        @ship.y -= FLY_SPEED
      end
      when :down
      @ship.play animation: :idle, loop: true
      if @ship.y > 0
        @ship.y += FLY_SPEED
      end
    end
  end
end

class Star
  def initialize
    @y_velocity = rand(0..2)
    @shape = Circle.new(
      x: rand(Window.width),
      y: rand(Window.height),
      radius: rand(1..2),
      color: 'white'
    )
  end

  def move
    @shape.y = (@shape.y + @y_velocity) % Window.height
  end
end


####################### MENU SCREEN #######################
class MenuScreen
  def initialize
    @stars = Array.new(100).map { Star.new }

    title = Text.new(
      'SPACE-RACE', 
      size: 72, 
      y:45
    )
    title_sub = Text.new(
      'Press ENTER to Start!',
      size: 36,
      y: 125
    )
    title.x = (Window.width - title.width) / 2
    title_sub.x = (Window.width - title_sub.width) / 2

    @players = Player.new(400, Window.width * (2/4.0) - Player::WIDTH / 2).fly
  end

  def update
    @stars.each { |star| star.move }
  end
end

####################### GAME SCREEN #######################
class GameScreen
  def initialize
    @stars = Array.new(100).map { Star.new }
    @player = Player.new(400, Window.width * (2/4.0) - Player::WIDTH / 2)
    @player.idle
  end

  def update
    if Window.frames % 2 == 0
      @stars.each { |star| star.move }
    end
  end

  def move_player(direction)
    @player.move(direction)
  end
end

current_screen = MenuScreen.new

update do
  current_screen.update
end

on :key_down do |event|
  case current_screen
    when MenuScreen
  case event.key
    when 'return'
      Window.clear
      current_screen = GameScreen.new
    end
  end
end

on :key_held do |event|
  case current_screen
  when GameScreen
    case event.key
    when 'a'
      current_screen.move_player(:left)
    when 'd'
      current_screen.move_player(:right)
    when 'w'
      current_screen.move_player(:up)
    when 's'
      current_screen.move_player(:down)
    end
  end
end

show