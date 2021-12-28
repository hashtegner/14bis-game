require 'config'

local shipState = {
  x = nil,
  y = nil,

  currentImage = nil,

  shipImage = love.graphics.newImage('images/14bis.png'),

  explosionAudio = love.audio.newSource("audios/destruicao.wav", "static"),
  explosionImage = love.graphics.newImage('images/explosao_nave.png'),

  speed = config.moveSpeed
}

ship = {
  load = function(events, game, enemies)
    events
      .on('restart', function() ship.restart(game) end)
      .on('move-up', function() ship.moveUp(game) end)
      .on('move-down', function() ship.moveDown(game) end)
      .on('move-left', function() ship.moveLeft(game) end)
      .on('move-right', function() ship.moveRight(game) end)
      .on('ship-hit', function() ship.destroy() end)
      .on('update', function() ship.update(events, enemies) end)
      .on('draw', ship.draw)

    ship.restart(game)
  end,

  gunX = function()
    return shipState.x + ship.width() / 2
  end,

  gunY = function()
    return shipState.y
  end,

  width = function()
    return shipState.currentImage:getWidth()
  end,

  height = function()
    return shipState.currentImage:getHeight()
  end,

  moveLeft = function(game)
    if not ship.isOutOfBounds(game, 'left') then
      shipState.x = shipState.x - shipState.speed
    end
  end,

  moveRight = function(game)
    if not ship.isOutOfBounds(game, 'right') then
      shipState.x = shipState.x + shipState.speed
    end
  end,

  moveUp = function(game)
    if not ship.isOutOfBounds(game, 'up') then
      shipState.y = shipState.y - shipState.speed
    end
  end,

  moveDown = function(game)
    if not ship.isOutOfBounds(game, 'down') then
      shipState.y = shipState.y + shipState.speed
    end
  end,

  isOutOfBounds = function(game, bound)
    local bounds = {
      up = shipState.y < 0,
      down = shipState.y + ship.height() > game.screenHeight(),
      left = shipState.x < 0,
      right = shipState.x + ship.width() > game.screenWidth()
    }

    return bounds[bound]
  end,

  restart = function(game)
    shipState.currentImage = shipState.shipImage;

    shipState.x = game.screenWidth()  / 2 - ship.width() / 2
    shipState.y = game.screenHeight() - ship.height()
  end,

  destroy = function()
    shipState.currentImage = shipState.explosionImage;

    shipState.explosionAudio:play()
  end,

  update = function(events, enemies)
    if enemies.isCollided(shipState.x, shipState.y, ship.width(), ship.height()) then
      events.trigger('ship-hit')
    end
  end,

  draw = function()
    love.graphics.draw(shipState.currentImage, shipState.x, shipState.y)
  end
}
