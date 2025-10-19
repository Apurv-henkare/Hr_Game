Player = Class {
    __includes = BaseState
}

function Player:init(x, y)
    self.x = 200
    self.y = WINDOW_HEIGHT-16*6-50
    self.speed = 420
    self.direction = 'right'
    self.state = 'idle' 
    self.maxX = 0 
    self.minX = 2250

    self.spriteSheet = love.graphics.newImage('Image/player_spritesheet .png')

    local frameW, frameH = 16, 16 -- your frame size
    local grid = anim8.newGrid(frameW, frameH, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    -- define animation mapping per row (style)
    self.styles = {}
    local totalStyles = 8 -- number of character variations (rows)

    for row = 1, totalStyles do
        self.styles[row] = {
            idle = anim8.newAnimation(grid('1-1', row), 0.01),
            walkLeft = anim8.newAnimation(grid('4-6', row), 0.1),
            walkRight = anim8.newAnimation(grid('7-9', row), 0.1)
        }
    end

    self.currentStyle = 1
    self.currentAnimation = self.styles[self.currentStyle].idle
end
local test = 1

function Player:update(dt)
    local moving = false

    if love.keyboard.isDown('right') then
        self.x = math.min(self.minX,self.x + self.speed * dt)
        self.direction = 'right'
        self.state = 'walkRight'
        moving = true
    elseif love.keyboard.isDown('left') then
        self.x = math.max(self.maxX,self.x - self.speed * dt)
        self.direction = 'left'
        self.state = 'walkLeft'
        moving = true
    end

    self.currentAnimation = self.styles[self.currentStyle][self.state]
    -- self.currentAnimation:update(dt) 
    if moving then
        self.currentAnimation:update(dt)
        -- else
        -- self.currentAnimation:gotoFrame(1) -- idle frame (middle one)
    end

    if love.keyboard.wasPressed('s') then
        if test == 8 then
            test = 0

        else
            test = test + 1
            self:setStyle(test % 9)
        end
    end
end

function Player:render()
    self.currentAnimation:draw(self.spriteSheet, self.x, self.y, 0, 6, 6)
end

-- 🔄 change to a different style (row)
function Player:setStyle(row)
    if self.styles[row] then
        self.currentStyle = row
    end
end
