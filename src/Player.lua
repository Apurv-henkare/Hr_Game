Player = Class {
    __includes = BaseState
}

function Player:init(x, y)
    frameW, frameH = 256, 256
    self.carObj = Car()
    self.x = 200
    self.y = WINDOW_HEIGHT - 16 * 6 - 50 - 70
    self.width = 256 * 0.7
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
    self.carSecondTriggered = false
    self.carReached = false
    self.carTimes = 0
    self.carPos = 1

    self.purchased = {}

    self.myntra = false
    self.dress = false
    self.hair = false
    self.gadget = false
    self.botAngle = 0

    self.bgx = 0
    self.spriteSheet = love.graphics.newImage('Image/girl2.png')
    self.bot = love.graphics.newImage('Image/bot.png')

    self.isJumping = false
    self.jumpSpeed = -600 -- upward velocity
    self.gravity = 1500 -- how strong gravity pulls down
    self.dy = 0 -- vertical velocity
    self.groundY = self.y
    self.city_x = 0

    -- your frame size
    local grid = anim8.newGrid(frameW, frameH, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    -- define animation mapping per row (style)
    self.styles = {}
    local totalStyles = 6 -- number of character variations (rows)

    for row = 1, totalStyles do
        self.styles[row] = {
            idle = anim8.newAnimation(grid('1-1', row), 0.05),
            -- walkLeft = anim8.newAnimation(grid('4-6', row), 0.1),
            walkRight = anim8.newAnimation(grid('1-6', row), 0.1),
            jump = anim8.newAnimation(grid('1-1', row), 0.1)
        }
    end

    self.currentStyle = 1
    self.currentAnimation = self.styles[self.currentStyle].idle
end
local test = 1
local moving = false
function Player:update(dt)
    -- moving = false
    self.carObj:update(dt)

    -- Start jump

    self.botAngle = self.botAngle + 10 * dt

    -- Movement and jumping
    if love.keyboard.wasPressed and love.keyboard.wasPressed('space') and not self.isJumping then
        -- Jump start
        playJumpSound()
        self.isJumping = true
        self.dy = self.jumpSpeed
        self.state = 'jump'
    end

    -- Horizontal movement (always allowed)
    if love.keyboard.isDown('right') then
        self.x = math.min(self.minX, self.x + self.speed * dt)
        self.direction = 1
        if not self.isJumping then
            self.state = 'walkRight'
        end
        moving = true

    elseif love.keyboard.isDown('left') then
        self.x = math.max(self.maxX, self.x - self.speed * dt)
        self.direction = -1
        if not self.isJumping then
            self.state = 'walkLeft'
        end
        moving = true

    else
        if not self.isJumping then
            self.state = 'idle'
        end
        moving = false
    end

    -- Apply gravity if jumping
    if self.isJumping then
        self.dy = self.dy + self.gravity * dt
        self.y = self.y + self.dy * dt

        -- Land on ground
        if self.y >= self.groundY then
            self.y = self.groundY
            self.isJumping = false
            self.dy = 0
            self.state = moving and (self.direction == 1 and 'walkRight' or 'walkLeft') or 'idle'
        else
            self.state = 'jump' -- always keep jump anim while in air
        end
    end

    -- Set animation based on state
    if self.state == 'idle' then
        self.currentAnimation = self.styles[self.currentStyle].idle
    elseif self.state == 'jump' then
        self.currentAnimation = self.styles[self.currentStyle].jump
    else
        -- print(self.currentStyle)
        self.currentAnimation = self.styles[self.currentStyle].walkRight
    end

    -- self.currentAnimation = self.styles[self.currentStyle][self.state]
    -- self.currentAnimation:update(dt) 
    -- if moving then
    self.currentAnimation:update(dt)

    if ((self.x >= 2200 and self.x <= 7000) and moving == true) then
        if self.state == 'walkRight' then
            self.bgx = self.bgx + 10 * dt
        elseif self.state == 'walkLeft' then
            self.bgx = self.bgx - 10 * dt
        end
    end

    if ((self.x > 12000 and self.x <= 16000) and moving == true) then
        if self.state == 'walkRight' then
            self.city_x = self.city_x + 5 * dt
        elseif self.state == 'walkLeft' then
            self.city_x = self.city_x - 5 * dt
        end
    end
    -- else
    -- self.currentAnimation:gotoFrame(1) -- idle frame (middle one)
    -- end

    -- if love.keyboard.wasPressed('s') then
    --     if test == 8 then
    --         test = 0

    --     else
    --         test = test + 1
    --         print("Hello")
    --         self:setStyle(test % 9)
    --     end
    -- end

    -- for key, value in ipairs(self.purchased) do
    --     if value == 13  then         
    --             -- first time 13 appears
    --             self.carTriggered = true 
    --             self.carReached = false
    --             print("First 13 found")
    --     end
    -- end
    -- 🚗 Collision check and attach
    if not self.onCar then
        if self:collides(self.carObj) and (self.carTriggered == true) and self.carReached == false then
            print("Player boarded the car!")
            self.onCar = true
            self.carObj.speed = 3000
            self.carObj.active = true
            -- gStateStack:push(QuestionSet(13,self.player))
        end
    else
        -- Move player with car
        self.x = self.carObj.x + 50 -- keep player slightly ahead on car
        self.y = self.carObj.y - 100
        self.bgx = self.bgx + 10 * dt

        -- 🚗 Detach when car stops at destination
        if not self.carObj.active then
            print("Player reached destination appoo!")
            self.carTriggered = false
            self.carReached = true
            self.onCar = false
            self.car = nil
        end
    end

    if self.carPos == 1 and self.x >= 8000 then
        self.carObj.x = 12000
        self.carPos = 2
        self.carObj.maxX = 16000
    end

    if self.carPos == 2 and self.x >= 16500 then
        self.carObj.x = 19600
        self.carPos = 3
        self.carObj.maxX = 23000
    end

    if self.myntra and self.dress and self.hair then
        --  print("🟢 All three are true") 
        self:setStyle(6)

    elseif self.myntra and self.dress and not self.hair then
        -- print("Case: myntra + dress true, hair false") 
        self:setStyle(5)

    elseif self.myntra and not self.dress and self.hair then
        -- print("Case: myntra + hair true, dress false") 
        self:setStyle(4)

    elseif not self.myntra and self.dress and self.hair then
        -- print("Case: dress + hair true, myntra false")
        self:setStyle(6)

    elseif self.myntra and not self.dress and not self.hair then
        -- print("Case: only myntra true")
        self:setStyle(2)

    elseif not self.myntra and self.dress and not self.hair then
        -- print("Case: only dress true") 
        self:setStyle(5)

    elseif not self.myntra and not self.dress and self.hair then
        -- print("Case: only hair true")
        self:setStyle(3)
    else
        -- print("🔴 All are false") 
        self:setStyle(1)
    end

    -- self:setStyle(6)

end

function Player:render()
    local scaleX = 0.3
    local offsetX = 0

    local frameW = 184.2 -- your frame width

    if self.onCar == false then
        self.currentAnimation:draw(self.spriteSheet, self.x + 100, self.y, 0, -- rotation
        0.7 * self.direction, -- flip if moving left
        0.7, -- y scale
        256 / 2 - 1 * self.direction, -- origin x for flip
        0 -- origin y
        )
    end

    love.graphics.setColor(1, 0.8, 0.2)

    if self.onCar == false then
        if self.x <= 7700 then
            self.currentAnimation:draw(self.spriteSheet, 8000, self.y, 0, -- rotation
            0.7 * self.direction, -- flip if moving left
            0.7, -- y scale
            256 / 2 - 1 * self.direction, -- origin x for flip
            0 -- origin y
            )
        else
            self.currentAnimation:draw(self.spriteSheet, math.min(18500, self.x + 300), self.y, 0, -- rotation
            0.7 * self.direction, -- flip if moving left
            0.7, -- y scale
            256 / 2 - 1 * self.direction, -- origin x for flip
            0 -- origin y
            )
        end
    end

    love.graphics.setColor(1, 1, 1)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height) 
    if self.gadget == true and moving == true then
        love.graphics.draw(self.bot, self.x, self.y - 5, self.botAngle, 0.65, 0.65, (100) / 2, (120) / 2)
    elseif self.gadget == true and moving == false then
        love.graphics.draw(self.bot, self.x, self.y - 5, 0, 0.65, 0.65, (100) / 2, (120) / 2)
    end
    self.carObj:render()
end

-- 🔄 change to a different style (row)
function Player:setStyle(row)
    if self.styles[row] then
        self.currentStyle = row
    end
end

function Player:collides(target)
    return self.x < target.x + target.width and self.x + frameW > target.x and self.y < target.y + target.height and
               self.y + frameH > target.y
end

