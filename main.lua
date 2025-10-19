require 'src/Dependencies'

local screenWidth, screenHeight = love.window.getDesktopDimensions()

function love.load() 
    math.randomseed(os.time())

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
