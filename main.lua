require 'src/Dependencies'
started = false 

local screenWidth, screenHeight = love.window.getDesktopDimensions()  
successBursts = {}


-- Function to unlock + play sound
function activateAudio()
    if not started then
        started = true
        bgm:play()
    end
end 


function playJumpSound()
    jumpSound:stop()  -- reset sound
    jumpSound:play()  -- play from start
end   

function playMoneySound()
    moneySound:stop()  -- reset sound
    moneySound:play()  -- play from start
end  


hooting = false 

function triggerTransactionAnimation(x, y)
    local burst = {
        x = x, y = y,
        particles = {},
        timer = 1.0 -- little longer
    }

    for i=1,50 do
        table.insert(burst.particles, {
            x = x, y = y,
            angle = math.rad(math.random(0,360)),
            speed = math.random(150,300),
            alpha = 1,
            size = math.random(4,9),
            gravity = math.random(30,80) / 100,
            vx = 0,
            vy = 0
        })
    end 

   

    table.insert(successBursts, burst)
end 



function love.load() 
    math.randomseed(os.time())  
    bgm = love.audio.newSource("music/bg_music_1.wav", "static") 
    jumpSound = love.audio.newSource("music/jump.wav", "static") 
    moneySound = love.audio.newSource("music/wow.wav", "static") 
    moneySound:setVolume(0.1)
    bgm:setVolume(0.1)
    bgm:setLooping(true)

    local screenWidth, screenHeight = love.window.getDesktopDimensions()

    love.window.setMode(900, 600, {
        fullscreen = false
    })

    gStateStack = StateStack()
    gStateStack:push(MainMenu())
    -- keep track of keypressed
    love.keyboard.keysPressed = {}
end

function love.update(dt) 
    Timer.update(dt)
    gStateStack:update(dt) 
    -- Timer.update(dt)

    love.keyboard.keysPressed = {} 
    love.mouse.buttonsPressed = {}
end 

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed = love.mouse.buttonsPressed or {}
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
    if love.mouse.buttonsPressed and love.mouse.buttonsPressed[button] then
        return true
    else
        return false
    end
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    love.keyboard.keysPressed[key] = true
end


function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.draw()
    -- push:start() 
    gStateStack:render()
    
    -- push:finish()
end
