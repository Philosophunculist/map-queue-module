## Map Queue Module Documentation

**Commands:**

!q [mapId] -- Adds a map with ID [mapId] to a queue of the next maps to be played. Each player can have only one map queued at a time.
Example: !q @7702091

!cq [mapId] -- -- e.g. Changes your queued map to a map with ID [mapId] without losing your place in the queue. Queues the map if you have no queued map already.
Example: !cq @7702091

!rq -- Removes your map from the queue.
Example: !rq

!skip -- To vote to skip the current map you must be alive; the command kills you in order to prevent exploitation. If you die (not due to typing !skip) or win before the first 30 seconds have passed (before AFK mice have died) then the voting system won't count you in the number of mice. If the number of votes exceed half of the number of mice then the map will be skipped.
Example: !skip

**Notes:**
- If the map queue is empty a random vanilla map will be selected.
- If you leave the room your map will be removed from the queue and the vote skip system.
- Feedback in the chat from commands is only available in verified modules (not in tribehouse) therefore cannot be implemented unless this module becomes official or semi-official (which would be pretty cool).

**To add:**
- Prevent the same map being queued multiple times in a row (maybe).
- Command to see the map queue.
- Currently if a mapId is invalid the map is just skipped. Validation when the map is queued and feedback would be better.

**How to use this script:**

To run this script you must have permissions in a tribehouse. In the tribehouse type /lua then paste all the text here into the pop up and press submit.
