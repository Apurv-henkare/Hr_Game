-- Mobile.lua
Mobile = Class { __includes = BaseState }

function Mobile:init(x, y, width, height)
    self.x = x or (900 - 250) / 2
    self.y = y or (600 - 400) / 2
    self.width = width or 250
    self.height = height or 400
    self.borderRadius = 30
end

function Mobile:render()
    -- Shadow
    love.graphics.setColor(0, 0, 0, 0.4)
    love.graphics.rectangle("fill", self.x + 5, self.y + 5, self.width, self.height, self.borderRadius, self.borderRadius)

    -- Phone Body
    love.graphics.setColor(0.95, 0.95, 0.95)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.borderRadius, self.borderRadius)

    -- Screen area
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.x + 10, self.y + 25, self.width - 20, self.height - 35, 20, 20)

    -- Camera notch
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.circle("fill", self.x + self.width / 2, self.y + 15, 5)

    -- Sample display text
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Mobile UI\n(S24 Style)", self.x, self.y + self.height / 2 - 30, self.width, "center")
end
