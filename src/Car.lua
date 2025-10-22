Car = Class {
    __includes = BaseState
}

function Car:init(x, y)
    self.x = 3400
    self.y = WINDOW_HEIGHT-16*4-40
    self.width = 400
    self.height = 250
    self.speed = 0
    self.active = false  -- moving or not
    self.maxX = 7000
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
end

function Car:render()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1)
end
