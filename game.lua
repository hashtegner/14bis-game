gameState = {
  ambientAudio = love.audio.newSource('audios/ambiente.wav', 'static'),
  backgroundImage = love.graphics.newImage('images/background.png'),

  gameOverAudio = love.audio.newSource('audios/game_over.wav', 'static'),
  gameOverImage = love.graphics.newImage('images/gameover.png'),

  isOver = false,
  isPaused = false,

  score = 0
}

game = {
  screenWidth = function()
    return gameState.backgroundImage:getWidth()
  end,

  screenHeight = function()
    return gameState.backgroundImage:getHeight()
  end,

  isOver = function()
    return gameState.isOver
  end,

  isRunning = function()
    return not game.isOver() and not gameState.isPaused
  end,

  load = function(events)
    events
      .on('pause', game.pause)
      .on('draw', game.draw)
      .on('close', game.close)
      .on('enemy-hit', game.incrementScore)
      .on('ship-hit', game.over)
      .on('restart', function()
        if gameState.isOver then
          game.restart()
        end
      end)

    game.restart()
  end,

  incrementScore = function()
    gameState.score = gameState.score + 1
  end,

  close = function()
    love.event.quit()
  end,

  pause = function()
    gameState.isPaused = not gameState.isPaused
    if gameState.isPaused then
      gameState.ambientAudio:pause()
    else
      gameState.ambientAudio:play()
    end
  end,

  over = function()
    gameState.isOver = true
    gameState.ambientAudio:stop()
    gameState.gameOverAudio:play()
  end,

  restart = function()
    gameState.isOver = false
    gameState.isPaused = false
    gameState.score = 0

    gameState.ambientAudio:setLooping(true)
    gameState.ambientAudio:play()
  end,

  draw = function()
    love.graphics.draw(gameState.backgroundImage)
    love.graphics.print("Acerto(s): "..gameState.score, 10, 10)

    if gameState.isOver then
      local x = game.screenWidth() / 2 - gameState.gameOverImage:getWidth() / 2
      local y = game.screenHeight() / 2 - gameState.gameOverImage:getHeight() / 2

      love.graphics.draw(gameState.gameOverImage, x, y)
    end
  end,
}
