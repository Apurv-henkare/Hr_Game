--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

MainMenu = Class { __includes = BaseState }

local highlighted = 1

local BACKGROUND_SCROLL_SPEED = 50
local BACKGROUND_SCROLL_SPEED2 = 80
local BACKGROUND_SCROLL_SPEED3 = 120
local GROUND_SCROLL_SPEED = 60
local BACKGROUND_LOOPING_POINT = 1280

function MainMenu:init()
    self.bg2 = 0
    self.joystick = love.joystick.getJoysticks()[1]
    self.inputCooldown = 0 -- cooldown to avoid fast repeated inputs

    -- define clickable menu button rectangles
    local centerX = VIRTUAL_WIDTH / 2
    local baseY = VIRTUAL_HEIGHT / 2 - 70
    self.menuItems = {
        { text = "START", y = baseY, action = function()
            gStateStack:pop()
            gStateStack:push(PlayState())
        end },
        { text = "INSTRUCTIONS", y = baseY + 50, action = function()
            -- gStateStack:pop()
            -- gStateStack:push(Instructions())
        end },
        { text = "CREDITS", y = baseY + 100, action = function()
            gStateStack:push(Credits())
        end },
        { text = "EXIT", y = baseY + 150, action = function()
            love.event.quit()
        end }
    }

    self.font = love.graphics.newFont('eight-bit-dragon.otf', 20)

    -- approximate button dimensions (based on text width)
    for _, item in ipairs(self.menuItems) do
        local textWidth = self.font:getWidth(item.text)
        local textHeight = self.font:getHeight()
        item.x = centerX - textWidth / 2
        item.width = textWidth
        item.height = textHeight
    end
end

function MainMenu:update(dt)
    self.bg2 = (self.bg2 + 100 * dt) % 4500
    self.inputCooldown = self.inputCooldown - dt

    -- Joystick navigation
    if self.joystick and self.inputCooldown <= 0 then
        local dy = self.joystick:getAxis(2)

        if self.joystick:isGamepadDown("dpup") or dy < -0.5 then
            highlighted = highlighted - 1
            if highlighted < 1 then highlighted = #self.menuItems end
            self.inputCooldown = 0.2
        elseif self.joystick:isGamepadDown("dpdown") or dy > 0.5 then
            highlighted = highlighted + 1
            if highlighted > #self.menuItems then highlighted = 1 end
            self.inputCooldown = 0.2
        elseif self.joystick:isGamepadDown("a") or self.joystick:isGamepadDown("start") then
            self.menuItems[highlighted].action()
            self.inputCooldown = 0.3
        end
    end

    -- Keyboard navigation
    if love.keyboard.wasPressed('up') then
        highlighted = highlighted - 1
        if highlighted < 1 then highlighted = #self.menuItems end
    elseif love.keyboard.wasPressed('down') then
        highlighted = highlighted + 1
        if highlighted > #self.menuItems then highlighted = 1 end
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.menuItems[highlighted].action()
    end

    -- Mouse hover and click detection
    local mx, my = love.mouse.getPosition()
    local scaleX = love.graphics.getWidth() / VIRTUAL_WIDTH
    local scaleY = love.graphics.getHeight() / VIRTUAL_HEIGHT

    -- convert actual mouse pos to virtual coordinates
    mx = mx / scaleX
    my = my / scaleY

    for i, item in ipairs(self.menuItems) do
        if self:isColliding(mx, my, 1, 1, item.x, item.y, item.width, item.height) then
            highlighted = i

            if love.mouse.wasPressed(1) then -- left click
                item.action()
            end
        end
    end
end

function MainMenu:isColliding(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

function MainMenu:render()
    love.graphics.setColor(1, 1, 1, 0.95)
    love.graphics.setFont(love.graphics.newFont('eight-bit-dragon.otf', 30))
    love.graphics.printf("Gencraft : Rebuild Rethink Reinvent ", 0, VIRTUAL_HEIGHT / 2 - 200, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(self.font)

    for i, item in ipairs(self.menuItems) do
        if i == highlighted then
            love.graphics.setColor(103 / 255, 1, 1, 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end

        love.graphics.printf(item.text, 0, item.y, VIRTUAL_WIDTH, 'center')
    end

    -- optional: draw a small rectangle to visualize the mouse hitbox
    local mx, my = love.mouse.getPosition()
    local scaleX = love.graphics.getWidth() / VIRTUAL_WIDTH
    local scaleY = love.graphics.getHeight() / VIRTUAL_HEIGHT
    mx, my = mx / scaleX, my / scaleY
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", mx, my, 1, 1)
    love.graphics.setColor(1, 1, 1)
end
