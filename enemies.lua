require 'config'
require 'collision'

function createEnemy(width, height, x, y)
  return {
    width = width,
    height = height,
    x = x,
    y = y,

    verticalSpeed = math.random(config.enemySpeed),

    horizontalSpeed = math.random(-1, 1),
  }
end

local enemiesState = {
  entries = {},
  image = love.graphics.newImage('images/meteoro.png'),
  startY = -100,
  limit = config.maxEnemies,
}

enemies = {
  load = function(events, game)
    events
      .on('restart', enemies.restart)
      .on('update', function() enemies.update(game) end)
      .on('draw', enemies.draw)

    enemies.restart()
  end,

  spawn = function(game)
    for i = #enemiesState.entries, enemiesState.limit - 1 do
      local x = math.random(game.screenWidth())

      local enemy = createEnemy(enemiesState.image:getWidth(), enemiesState.image:getHeight(), x, enemiesState.startY)
      table.insert(enemiesState.entries, enemy)
    end
  end,

  update = function(game)
    enemies.spawn(game)
    enemies.move(game)
  end,

  move = function(game)
    for i = #enemiesState.entries, 1, -1 do
      local enemy = enemiesState.entries[i]
      if enemies.isEnemyOutOfBounds(game, enemy) then
        table.remove(enemiesState.entries, i)
      else
        enemies.updateEnemyPosition(enemy)
      end
    end
  end,

  isEnemyOutOfBounds = function(game, enemy)
    return enemy.y > game.screenHeight() or
          (enemy.x + enemy.width) < 0 or
          (enemy.x) > game.screenWidth()
  end,

  updateEnemyPosition = function(enemy)
    enemy.x = enemy.x + enemy.horizontalSpeed
    enemy.y = enemy.y + enemy.verticalSpeed
  end,

  isCollided = function(x, y, width, height)
    for i = #enemiesState.entries, 1, -1 do
      local enemy = enemiesState.entries[i]

      if isCollided(x, y, width, height, enemy.x, enemy.y, enemy.width, enemy.height) then
        return true
      end
    end

    return false
  end,

  removeCollided = function(x, y, width, height)
    local removed = false

    for i = #enemiesState.entries, 1, -1 do
      local enemy = enemiesState.entries[i]

      if isCollided(x, y, width, height, enemy.x, enemy.y, enemy.width, enemy.height) then
        table.remove(enemiesState.entries, i)
        removed = true

        break
      end
    end

    return removed
  end,

  restart = function()
    enemiesState.entries = {}
  end,

  draw = function()
    for i, enemy in ipairs(enemiesState.entries) do
      love.graphics.draw(enemiesState.image, enemy.x, enemy.y)
    end
  end
}
