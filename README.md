# GoFast by Chamallaw
A FiveM script written in LUA that implements customisable GoFast with QB Core

## Démo
https://drive.google.com/file/d/11WJiQEMF3DSopEMJrWmTTwhn2rkxQIGi/view?usp=sharing

## Installation
* Download the resource
* Drag and drop it into your resources folder
* You can rename the folder
* Add ```ensure cham-gofast``` to your server configuration file. (Or the renamed folder name)
* Replace the notification système with your :
~~~
function sendUserMessage(text)
    -- Replace this with your notification système
    exports["soz-core"]:DrawNotification(text)
end
~~~
* Customise the shared/config.lua file
* Enjoy !

## How to use
* Find the start NPC and press E (INPUT CONTEXT KEY)

## Patch Notes
#### V1.2
* Adding synch animations for all the players arround
* Adding a function to get the trunk coords, and make it more realistic
#### V1.1
* Replacing the old text with QB-Target
* Adding customisable search zone when the player is loading, unloading or throwing the car
* Adding an end condition that stop the mission if the player leave the car for more than 5-6 minutes
#### V1.0
* Adding initial PED
* Adding Vehicle Spawn
* Adding Load point with peds and animations
* Adding Unload point with peds and animations
* Adding the ped that gives money
* Adding the final point to leave the car
* Adding the remove peds and car at the end

## Note
* This script is paid, so if you didn't pay please do not use it.
