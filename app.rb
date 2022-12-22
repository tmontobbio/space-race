require 'ruby2d'

set title: 'Space-Race'
set width: 800, height: 600
FLY_SPEED = 5

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

class MenuScreen
  def initialize
    @stars = Array.new(100).map { Star.new }
  end

  def update
    @stars.each { |star| star.move }
  end
end

menu_screen = MenuScreen.new

update do
  menu_screen.update
end


    ship = Sprite.new(
      'assets/gray-ship.png',
      width:64,
      height:64,
      clip_width:128,
      time:150,
      loop:true,
      y:472,
      x:0,
      animations: {
                    idle: 0..7,
                    fly: 8..15,
                    crash: 16..24
                  }
    )

    # ship.play animation: :idle, loop: true

on :key_held do |event|
  case event.key
  when 'w'
    ship.play animation: :fly, loop: true
    if ship.y > 0
      ship.y -= FLY_SPEED
    end
  when 's'
    ship.play animation: :idle, loop: true
    if ship.y > 0
      ship.y += FLY_SPEED
    end
  when 'a'
    ship.play animation: :fly, loop: true
    if ship.x < (Window.width - ship.width)
      ship.x -= FLY_SPEED
    end
  when 'd'
    ship.play animation: :fly, loop: true
    if ship.x < (Window.width - ship.width)
      ship.x += FLY_SPEED
    end
  end
end

on :key_up do
  ship.stop
end

show