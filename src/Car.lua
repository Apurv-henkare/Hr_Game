Car = Class {
    __includes = BaseState
}

function Car:init(x, y)
    self.x = x or 3400
    self.y = WINDOW_HEIGHT - 16 * 4 - 40
    self.width = 400
    self.height = 250
    self.speed = 0
    self.active = false -- moving or not
    self.maxX = 7000

    self.spriteSheet = love.graphics.newImage('Image/Taxi.png')

    -- your frame size
    local grid = anim8.newGrid(296/2, 53, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    -- define animation mapping per row (style)
    self.styles = {}
    local totalStyles = 1 -- number of character variations (rows)

    for row = 1, totalStyles do
        self.styles[row] = {
            idle = anim8.newAnimation(grid('1-1', 1), 0.05),
            -- walkLeft = anim8.newAnimation(grid('4-6', row), 0.1),
            walkRight = anim8.newAnimation(grid('1-2', 1), 0.1)
        }
    end

    self.currentStyle = 1
    self.currentAnimation = self.styles[self.currentStyle].idle
end

function Car:update(dt)
    if self.active then
        self.x = self.x + self.speed * dt
        if self.x >= self.maxX then
            self.x = self.maxX
            self.speed = 0
            self.active = false
        end
    end

    if love.keyboard.isDown('right') then
       -- self.x = math.min(self.minX, self.x + self.speed * dt)
       -- self.direction = 1
        self.state = 'walkRight'
        moving = true
    else
        self.state = 'idle'
    end

    -- Set animation based on state
    if self.state == 'idle' then
        self.currentAnimation = self.styles[self.currentStyle].idle
    else
        self.currentAnimation = self.styles[self.currentStyle].walkRight
    end

    -- self.currentAnimation = self.styles[self.currentStyle][self.state]
    -- self.currentAnimation:update(dt) 
    -- if moving then
    self.currentAnimation:update(dt)
end

function Car:render()
    love.graphics.setColor(1, 1,1)
    --love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    self.currentAnimation:draw(self.spriteSheet, self.x -100, self.y-100, 0, -- rotation
    4, -- flip if moving left
    4, -- y scale
   0,
    0 -- origin y
    )
    love.graphics.setColor(1, 1, 1)
end
