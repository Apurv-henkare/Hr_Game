Player = Class {
    __includes = BaseState
}

function Player:init(x, y) 
    frameW, frameH = 256,256
    self.carObj = Car()
    self.x = 200
    self.y = WINDOW_HEIGHT - 16 * 6 - 50 - 70 
    self.width = 256*0.7
    self.height = 256
    self.speed = 420
    -- self.direction = 'right'
    self.state = 'idle'
    self.maxX = 0
    self.minX = 2250
    self.money = 10000
    self.direction = 1
    self.onCar = false
    self.car = nil
    self.carTriggered = false 
    self.carReached = false

    self.purchased = {}

    self.spriteSheet = love.graphics.newImage('Image/Girl.png')

    -- your frame size
    local grid = anim8.newGrid(frameW, frameH, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    -- define animation mapping per row (style)
    self.styles = {}
    local totalStyles = 1 -- number of character variations (rows)

    for row = 1, totalStyles do
        self.styles[row]= {
            idle = anim8.newAnimation(grid('1-1', 1), 0.05),
            -- walkLeft = anim8.newAnimation(grid('4-6', row), 0.1),
            walkRight = anim8.newAnimation(grid('1-6', 1), 0.1)
        } 
   end

    self.currentStyle = 1
    self.currentAnimation = self.styles[self.currentStyle].idle
end
local test = 1

function Player:update(dt)
    local moving = false 
     self.carObj:update(dt)

    if love.keyboard.isDown('right') then
        self.x = math.min(self.minX, self.x + self.speed * dt)
        self.direction = 1
        self.state = 'walkRight'
        moving = true
    elseif love.keyboard.isDown('left') then
        self.x = math.max(self.maxX, self.x - self.speed * dt)
        self.direction = -1
        self.state = 'walkLeft'
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
    -- else
    -- self.currentAnimation:gotoFrame(1) -- idle frame (middle one)
    -- end

    if love.keyboard.wasPressed('s') then
        if test == 8 then
            test = 0

        else
            test = test + 1
            self:setStyle(test % 9)
        end
    end


    for key,value in ipairs(self.purchased) do 
        if value == 13 then 
            self.carTriggered = true
        end 
    end 
    -- 🚗 Collision check and attach
    if not self.onCar then
        if self:collides(self.carObj) and self.carTriggered == true and self.carReached == false  then
            print("Player boarded the car!")
            self.onCar = true
            self.carObj.speed = 3000
            self.carObj.active = true 
            --gStateStack:push(QuestionSet(13,self.player))
        end
    else
        -- Move player with car
        self.x = self.carObj.x + 50 -- keep player slightly ahead on car
        self.y = self.carObj.y - 100

        -- 🚗 Detach when car stops at destination
        if not self.carObj.active then
            print("Player reached destination!") 
            self.carReached = true
            self.onCar = false
            self.car = nil
        end
    end
end

function Player:render()
    local scaleX = 0.3
    local offsetX = 0

    local frameW = 184.2 -- your frame width

    self.currentAnimation:draw(self.spriteSheet, self.x+100, self.y, 0, -- rotation
    0.7 * self.direction, -- flip if moving left
    0.7, -- y scale
    256/2-1* self.direction, -- origin x for flip
    0 -- origin y
    ) 
    
    love.graphics.setColor(1,0.5,0.1) 

    if self.x <=7700 then 
        self.currentAnimation:draw(self.spriteSheet, 8000, self.y, 0, -- rotation
        0.7 * self.direction, -- flip if moving left
        0.7, -- y scale
        256/2-1* self.direction, -- origin x for flip
        0 -- origin y
        ) 
    else  
        self.currentAnimation:draw(self.spriteSheet,self.x+300 , self.y, 0, -- rotation
        0.7 * self.direction, -- flip if moving left
        0.7, -- y scale
        256/2-1* self.direction, -- origin x for flip
        0 -- origin y
        ) 
    end

    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('line', self.x, self.y, self.width,self.height) 
    self.carObj:render()
end

-- 🔄 change to a different style (row)
function Player:setStyle(row)
    if self.styles[row] then
        self.currentStyle = row
    end
end 

function Player:collides(target)
    return self.x < target.x + target.width and
           self.x + frameW  > target.x and
           self.y < target.y + target.height and
           self.y + frameH > target.y
end

