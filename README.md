# map-queue-module
A LUA script for Transformice which allows players to queue maps of their choice. This project is still in alpha. Please report any issues on this Git Hub page and make suggestions as a reply to my post on the Transformice forum https://atelier801.com/topic?f=6&t=887122&p=1#m2.

**Commands:**\
`!q [mapId]` -- Adds a map with ID [mapId] to a queue of the next maps to be played. Each player can have only one map queued at a time.\
Example: `!q @7702091` (the @ is optional)

`!cq [mapId]` -- Changes your queued map to a map with ID [mapId] without losing your place in the queue. Queues the map if you have no queued map already.\
Example: `!cq @7702091` (the @ is optional)

`!rq` -- Removes your map from the queue.\
Example: `!rq`

`!skip` -- To vote to skip the current map you must be alive; the command kills you. These two factors prevent abuse of !skip. If the number of votes to skip exceeds the total number of players, or the number of players still alive after the first 30 seconds of the game (after AFK players die) plus dead players who voted to skip, then the map will be skipped.\
Example: `!skip`

**How to use this script:**\
To run this script you must have permissions in a tribehouse. In the tribehouse type /lua then paste all the text in map_queue.lua (found above) into the pop up and press submit.

**Notes:**
- If the map queue is empty a random vanilla map will be selected.
- If you leave the room your map will be removed from the queue and the vote skip system.
- Feedback in the chat from commands is only available in verified modules (not in tribehouse) therefore cannot be implemented unless this module becomes official or semi-official (which would be pretty cool).
- The voting system handels players being revived sensibly. You can't vote to skip more than once. Those who died in the first 30 seconds and were then revived are added to the "number of players still alive after the first 30 seconds of the game".

**To add:**
- Prevent the same map being queued multiple times in a row (maybe).
- Command to see the map queue (if the module becomes official).
- Currently if a mapId is invalid the map is just skipped. Validation when the map is queued and feedback would be better.
