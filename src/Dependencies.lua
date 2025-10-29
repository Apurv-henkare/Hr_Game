Class = require 'lib/class'
push = require 'lib/push'
wf= require 'lib/windfield/windfield' 
cameraFile = require 'lib/hump/camera'
anim8 =require 'lib/anim8/anim8'
cam =cameraFile()

require 'src/constant'
require 'src/Player'
require 'src/Car'
require 'src/Girl'

require 'src/states/StateStack'
require 'src/states/BaseState' 

require 'src/states/game/MainMenu'
require 'src/states/game/PlayState'
require 'src/states/game/Intro' 
require 'src/states/game/QuestionSet' 
require 'src/states/game/Dialogue'
require 'src/states/game/Mobile'
require 'src/states/game/Movie' 
require 'src/states/game/End'
require 'src/states/game/Concert'
--require 'src/states/game/Credits'
Timer = require 'knife.timer' 

http = require("socket.http")
ltn12 = require("ltn12")
json = require("json") -- your json.lua 
  -- Timeout after 2 seconds 

require("js")

