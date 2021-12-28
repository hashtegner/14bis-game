require 'config'

function createBullet(width, height, x, y)
  return {
    width = width,
    height = height,
    x = x,
    y = y,
    horizontalMove = config.shotSpeed
  }
end

local bulletsState = {
  entries = {},
  image = love.graphics.newImage('images/tiro.png'),
  audio = love.audio.newSource('audios/disparo.wav', 'static'),
}

bullets = {
  load = function(events, game, ship, enemies)
    events
      .on('shot', function() bullets.shot(ship) end)
      .on('update', function() bullets.update(events, enemies) end)
      .on('draw', bullets.draw)
      .on('restart', bullets.restart)
  end,

  spawn = function(ship)
    local bullet = createBullet(bulletsState.image:getWidth(), bulletsState.image:getHeight(), ship.gunX(), ship.gunY())

    table.insert(bulletsState.entries, bullet)
  end,

  restart = function()
    bulletsState.entries = {}
  end,

  update = function(events, enemies)
    bullets.move()
    bullets.removeCollided(events, enemies)
  end,

  removeCollided = function(events, enemies)
    for i = #bulletsState.entries, 1, -1 do
      local bullet = bulletsState.entries[i]

      if enemies.removeCollided(bullet.x, bullet.y, bullet.width, bullet.height) then
        table.remove(bulletsState.entries, i)
        events.trigger('enemy-hit')
      end
    end
  end,

  move = function()
    for i = #bulletsState.entries, 1, -1  do
      local bullet = bulletsState.entries[i]
      if bullets.isBulletOutOfBounds(bullet) then
        table.remove(bulletsState.entries, i)
      else
        bullets.updateBulletPosition(bullet)
      end
    end
  end,

  isBulletOutOfBounds = function(bullet)
    return bullet.y + bullet.height < 0
  end,

  updateBulletPosition = function(bullet)
    bullet.y = bullet.y - bullet.horizontalMove
  end,

  shot = function(ship)
    bullets.spawn(ship)

    local audio = bulletsState.audio:clone()
    audio:play()
  end,

  draw = function()
    for i,bullet in ipairs(bulletsState.entries) do
      love.graphics.draw(bulletsState.image, bullet.x, bullet.y)
    end
  end
}
