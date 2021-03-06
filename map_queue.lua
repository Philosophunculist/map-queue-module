map_queue = {}
player_queue = {}
player_queue_set = {}
mice_alive = 0
loading = false
NO_OF_VANILLA_MAPS = 143
time_at_end_of_game = 0 -- timeElapsed
timer = 0 -- updated every half second in seconds since map attempted to load.

-- skip related global vars
skip_votes = 0
players_alive_after_thirty_seconds = 0
thirty_seconds_passed = false
skipper_set = {}
died_or_won_before_thirty_seconds_set = {}

tfm.exec.disableAutoNewGame(true)

function checkSkipVote()
  if skip_votes > 0.5 * players_alive_after_thirty_seconds then
    skip_votes = 0
    tfm.exec.setGameTime(0, false)
    if thirty_seconds_passed then
      print("Votes to skip exceed half the mice alive after 30s and mice who voted.")
    else
      print("Votes to skip exceed half the mice alive at start of game.")
    end
    print("Skipping map.")
  end
end

function removeFromQueue(playerName)
  player_queue_set[playerName] = nil
  for i, v in ipairs(player_queue) do
    if v == playerName then
      table.remove(player_queue, i)
      table.remove(map_queue, i)
      break
    end
  end
end

function changeQueuedMap(playerName, mapId)
  for i, v in ipairs(player_queue) do
    if v == playerName then
      map_queue[i] = mapId
      break
    end
  end
end

function queueMap(playerName, mapId)
  table.insert(map_queue, mapId)
  table.insert(player_queue, playerName)
  player_queue_set[playerName] = true
  print(playerName .. " queued map " .. mapId)
end

function setMiceAlive()
  local counter = 0
  for _, data in next, tfm.get.room.playerList do
    if not data.isDead then
      counter = counter + 1
    end
  end
  mice_alive = counter
end

function eventPlayerLeft(playerName) -- leaving while alive triggers eventPlayerDied
  setMiceAlive()
  if player_queue_set[playerName] then
    removeFromQueue(playerName)
  end
  -- remove the skippers skipping data
  if skipper_set[playerName] then
    skipper_set[playerName] = nil
    skip_votes = skip_votes - 1
    players_alive_after_thirty_seconds = players_alive_after_thirty_seconds - 1
  end
end

function eventPlayerDied(playerName)
  mice_alive = mice_alive - 1
  -- skip related
  if not thirty_seconds_passed and not skipper_set[playerName] then
    players_alive_after_thirty_seconds = players_alive_after_thirty_seconds - 1
    died_or_won_before_thirty_seconds_set[playerName] = true
  end
end

eventPlayerWon = eventPlayerDied

function eventPlayerRespawn(playerName)
  mice_alive = mice_alive + 1
  -- skip related
  if died_or_won_before_thirty_seconds_set[playerName] then -- and therefore also not a skipper (see eventPlayerDied).
    died_or_won_before_thirty_seconds_set[playerName] = nil
    players_alive_after_thirty_seconds = players_alive_after_thirty_seconds + 1
  end
end

function eventChatCommand(playerName, message)
  -- QUEUE MAP COMMAND
  if string.match(message, "^q @?%d+$") then
    if player_queue_set[playerName] then
      print("You may only have one map in the queue at a time.")
    else
      mapId = string.match(message, "@?%d+$")
      queueMap(playerName, mapId)
    end

  -- SKIP COMMAND
  elseif string.match(message, "^skip$") then
    if skipper_set[playerName] then
      print("You have already voted to skip!")
    elseif tfm.get.room.playerList[playerName].isDead then
      print("You cannot vote to skip when you are dead.")
    else
      print("When you vote to skip you are killed to prevent exploitation.")
      skipper_set[playerName] = true
      skip_votes = skip_votes + 1
      tfm.exec.killPlayer(playerName)
      if thirty_seconds_passed then
        checkSkipVote()
      -- else checked in eventPlayerDied()
      end
    end

  -- REMOVE FROM QUEUE COMMAND
  elseif string.match(message, "^rq$") then
    if player_queue_set[playerName] then
      removeFromQueue(playerName)
      print("Your map has been removed from the queue.")
    else
      print("You don't have a map in the queue to be removed.")
    end

  -- CHANGE QUEUED MAP COMMAND
  elseif string.match(message, "^cq @?%d+$") then
    if player_queue_set[playerName] then
      local mapId = string.match(message, "@?%d+$")
      changeQueuedMap(playerName, mapId)
      print("Changed map in queue to: " .. mapId)
    else
      queueMap(playerName, mapId)
      print("You had no map in the queue; your map has now been added to the queue.")
    end
    
  else
    print("Invalid command.")
  end
end

function eventNewGame()
  loading = true
end

-- called every 0.5 seconds.
function eventLoop(timeElapsed, timeRemaining)
  timer = timer + 0.5
  -- extra 100ms for afk players to die.
  if timeElapsed > 30100 and not thirty_seconds_passed then
    print("Players alive after 30s" .. players_alive_after_thirty_seconds) -- debugging
    thirty_seconds_passed = true
    checkSkipVote()
  end
  if loading then -- loading = true when eventNewGame() is triggered.
    if timer > 20 then -- try a new map if stuck loading for 20s.
      loading = false
    end
    -- if map has loaded and give time for tfm.get.room.playerList to update.
    if timeElapsed < time_at_end_of_game and timeElapsed > 0 then
      -- reset vars
      loading = false
      setMiceAlive()
      players_alive_after_thirty_seconds = mice_alive
      thirty_seconds_passed = false
      skipper_set = {}
      skip_votes = 0 -- incase of voting to skip after a vote skip has passed.
    end
  else
    if (timeRemaining <= 0 or mice_alive == 0) and timer > 3 then
      time_at_end_of_game = timeElapsed
      if map_queue[1] then
        tfm.exec.newGame(table.remove(map_queue, 1))
        player_queue_set[player_queue[1]] = nil
        print("This map was queued by " .. table.remove(player_queue, 1))
      else
        -- should use # categories when official module
        print("Picking random vanilla map.")
        -- randomly sometimes fails to load a new map
        tfm.exec.newGame(math.random(0, NO_OF_VANILLA_MAPS))
      end
      timer = 0
    end
  end
end
