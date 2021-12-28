require 'collision'
require 'events'
require 'game'
require 'ship'
require 'enemies'
require 'bullets'

function love.load()
  math.randomseed(os.time())
  love.window.setTitle('14bis x Asteroides')
  love.window.setMode(game:screenWidth(), game:screenHeight(), {centered = true})

  game.load(events)
  enemies.load(events, game)
  ship.load(events, game, enemies)
  bullets.load(events, game, ship, enemies)
end

function love.update(dt)
  if not game.isRunning() then
    return
  end

  if love.keyboard.isDown("up", "w") then
    events.trigger('move-up')
  end

  if love.keyboard.isDown("down", "s") then
    events.trigger('move-down')
  end

  if love.keyboard.isDown("left", "a") then
    events.trigger('move-left')
  end

  if love.keyboard.isDown("right", "f") then
    events.trigger('move-right')
  end

  events.trigger("update")
end

function love.keypressed(key)
  if key == 'space' and game.isRunning() then
    events.trigger('shot')
  elseif key == "p" and not game.isOver() then
    events.trigger('pause')
  elseif key == "r"  and game.isOver() then
    events.trigger("restart")
  elseif key == "escape" then
    events.trigger("close")
  end
end

function love.draw()
  events.trigger("draw")
end
