Girl = Class {
    __includes = BaseState
}

function Girl:init(x, y)
    self.frameW,self.frameH = 150,177
    self.happy= false
    self.isJumping = false
    
    self.x = 19500
    self.y= WINDOW_HEIGHT - 16 * 6 - 50 - 70
    self.jumpSpeed = -600 -- upward velocity
    self.gravity = 1500 -- how strong gravity pulls down
    self.dy = 0 -- vertical velocity
    self.groundY = self.y 
    self.state = 'idle'
    self.spriteSheet = love.graphics.newImage('Image/WalkingGirl.png')

    local grid = anim8.newGrid(self.frameW, self.frameH, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    -- define animation mapping per row (style)
    self.styles = {}
    local totalStyles = 1 -- number of character variations (rows)

    for row = 1, totalStyles do
        self.styles[row] = {
            idle = anim8.newAnimation(grid('1-4', row), 0.15),
            -- walkLeft = anim8.newAnimation(grid('4-6', row), 0.1),
            -- walkRight = anim8.newAnimation(grid('1-6', row), 0.1),
            jump = anim8.newAnimation(grid('1-4', row), 0.1)
        }
    end

    self.currentStyle = 1
    self.currentAnimation = self.styles[self.currentStyle].idle
end
local test = 1
local moving = false
function Girl:update(dt)
    -- moving = false


    -- Start jump

    

    -- Movement and jumping
    if self.happy == true and not self.isJumping then
        -- Jump start
        self.isJumping = true
        self.dy = self.jumpSpeed
        self.state = 'jump'
    end

    -- -- Horizontal movement (always allowed)
    -- if love.keyboard.isDown('right') then
    --     self.x = math.min(self.minX, self.x + self.speed * dt)
    --     self.direction = 1
    --     if not self.isJumping then
    --         self.state = 'walkRight'
    --     end
    --     moving = true

    -- elseif love.keyboard.isDown('left') then
    --     self.x = math.max(self.maxX, self.x - self.speed * dt)
    --     self.direction = -1
    --     if not self.isJumping then
    --         self.state = 'walkLeft'
    --     end
    --     moving = true

    -- else
    --     if not self.isJumping then
    --         self.state = 'idle'
    --     end
    --     moving = false
    -- end

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
        print(self.currentStyle)
        self.currentAnimation = self.styles[self.currentStyle].walkRight
    end

    -- self.currentAnimation = self.styles[self.currentStyle][self.state]
    -- self.currentAnimation:update(dt) 
    -- if moving then
    self.currentAnimation:update(dt)

end

function Girl:render()
    self.currentAnimation:draw(self.spriteSheet, self.x + 100, self.y, 0, -- rotation
    0.7 * 1, -- flip if moving left
    0.7, -- y scale
    256 / 2 - 1 * 1, -- origin x for flip
    0 -- origin y
    )

    love.graphics.setColor(1, 0.8, 0.2)

    love.graphics.setColor(1, 1, 1)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height) 
end
-- 🔄 change to a different style (row)

function Girl:collides(target)
    return self.x < target.x + target.width and self.x + self.frameW > target.x and self.y < target.y + target.height and
               self.y + self.frameH > target.y
end