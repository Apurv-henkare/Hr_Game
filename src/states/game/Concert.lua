Concert = Class { __includes = BaseState }

function Concert:init()
    self.image = love.graphics.newImage('Image/club.jpeg')

    -- start fully visible
    self.alpha = 1

    -- fade direction: -1 = fading out first
    self.fadeDirection = -1

    -- speed of fade (lower = slower)
    self.fadeSpeed = 0.3

    -- flag to stop after one full cycle
    self.doneFading = false
end

function Concert:update(dt) 


    if self.doneFading then
        --return  
        gStateStack:pop()

    end

    -- update alpha based on direction
    self.alpha = self.alpha + self.fadeDirection * self.fadeSpeed * dt

    -- fade out complete → start fading in
    if self.alpha <= 0 then
        self.alpha = 0
        self.fadeDirection = 1
    -- fade in complete → stop fading
    elseif self.alpha >= 1 and self.fadeDirection == 1 then
        self.alpha = 1
        self.doneFading = true
    end 


end

function Concert:render()
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill',0,0,900,600)
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.draw(self.image, 0, 0,0,0.7,0.8)
    love.graphics.setColor(1, 1, 1, 1) -- reset color 
    love.graphics.setColor(1,1,1)
end
