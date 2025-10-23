PlayState = Class {
    __includes = BaseState
}

collision_obj = {{
    x = 3400,
    y = WINDOW_HEIGHT - 16 * 4 - 40,
    width = 400,
    height = 250,
    key = 13,
    choice = false
}, {
    x = 736,
    y = WINDOW_HEIGHT - 16 * 6 - 50 - 70,
    width = 50,
    height = 70,
    key = 14
}, {
    x = 1751 + 40,
    y = WINDOW_HEIGHT - 16 * 6 - 50 - 70 - 60,
    width = 100,
    height = 50 + 50,
    key = 1
}, {
    x = 1751 + 60 + 110,
    y = WINDOW_HEIGHT - 16 * 6 - 50 - 70 - 60,
    width = 100,
    height = 50 + 50,
    key = 7
}}

vegetables = {{
    x = 810 + 40,
    y = WINDOW_HEIGHT - 16 * 6 - 50 - 70 - 60,
    width = 50 + 30,
    height = 50 + 50
}, {
    x = 860 + 40 + 30,
    y = WINDOW_HEIGHT - 16 * 6 - 50 - 70 - 60,
    width = 50 + 30,
    height = 50 + 50
}, {
    x = 910 + 40 + 30 + 30,
    y = WINDOW_HEIGHT - 16 * 6 - 50 - 70 - 60,
    width = 50 + 30,
    height = 50 + 50
}}

lamps = {}

ui = {
    width = 220,
    height = 400,
    x = (900 - 250) / 2,
    y = (600 - 400) / 2,
    borderRadius = 30
}

function PlayState:enter()
    gStateStack:push(Dialogues(1))

end
function PlayState:init()
    self.player = Player()
    self.homeImage = love.graphics.newImage('Image/Home_3.png')
    self.bgImage = love.graphics.newImage('Image/Bg.jpg')
    self.mallImage = love.graphics.newImage('Image/Mall (3).png')
    self.lampImage = love.graphics.newImage('Image/lamp.png')
    self.fan = love.graphics.newImage("Image/fan.png")
    self.bg = love.graphics.newImage("Image/C2.png")
    self.scroll = 0
    self.SCROLL_SPEED = 50 -- pixels per second
    self.BG_LOOP_POINT = self.bg:getWidth()
    self.fanAngle = 0
    self.choice = false 
    self.cross1 = false

    local startX = 3000
    local endX = 7300
    local gap = 500
    local baseY = WINDOW_HEIGHT - 16 * 6 - 50 - 70 - 60 - 100

    for x = startX, endX, gap do
        table.insert(lamps, {
            x = x,
            y = baseY
        })
    end
end

function PlayState:update(dt)

    self.player:update(dt)
    self.fanAngle = self.fanAngle + 20 * dt
    self.scroll = (self.scroll + self.SCROLL_SPEED * dt) % self.BG_LOOP_POINT

    if (self.player.x <= 470) then
        cam:lookAt(470, WINDOW_HEIGHT / 2)
    elseif (self.player.x > 470 and self.player.x <= 1900) then
        self.cross1= true
        cam:lookAt(self.player.x, WINDOW_HEIGHT / 2)
    elseif (self.player.x > 1900 )and self.cross1 == true then
        self.player.maxX = 2500
        self.player.minX = 9000
        self.player.x = 2500 
        self.cross1 = false
        cam:lookAt(2900, WINDOW_HEIGHT / 2)
    elseif (self.player.x >= 2900 and self.player.x < 7000) then
        cam:lookAt(self.player.x, WINDOW_HEIGHT / 2)
    elseif (self.player.x >= 7000) then
        self.player.maxX = 7000
        self.player.minX = 13000
        cam:lookAt(self.player.x, WINDOW_HEIGHT / 2)
    end

    if love.keyboard.wasPressed('r') then
        gStateStack:push(QuestionSet(3, self.player))
    end


    for i, value in pairs(collision_obj) do
        if AABB(value, self.player) then
            value.x = -20000
            gStateStack:push(QuestionSet(value.key, self.player))
        end
    end

    for key, value in ipairs(vegetables) do
        if AABB(value, self.player) then
            value.x = -20000
            -- gStateStack:push(QuestionSet(value.key,self.player))
        end
    end
end

function AABB(a, b)
    return a.x < b.x + b.width and b.x < a.x + a.width and a.y < b.y + b.height and b.y < a.y + a.height
end

function PlayState:render() 
    if self.player.x <=9000 then 
        love.graphics.setColor(1, 1, 1, 0.7)
    else 
        love.graphics.setColor(1, 0.3, 0, 0.9)
    end
    love.graphics.draw(self.bgImage, 0, 0, 0, 3, 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.bg, -self.scroll, 0)
    love.graphics.draw(self.bg, -self.scroll + self.bg:getWidth(), 0)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', 0, WINDOW_HEIGHT - 16 * 6, 10000, 16 * 6 - 10)
    -- love.graphics.draw(self.homeImage, 0, WINDOW_HEIGHT - 600,0,1)
    cam:attach()
    -- love.graphics.print("Background or map here", 100, 100)  
    -- background scroll-- 

    love.graphics.draw(self.homeImage, -50, WINDOW_HEIGHT - 600, 0, 1)
    love.graphics.draw(self.mallImage, 8000, WINDOW_HEIGHT - 600, 0, 1, 1)
    love.graphics.draw(self.fan, 100, WINDOW_HEIGHT - 400, self.fanAngle, 1.2, 1.2, self.fan:getWidth() / 2,
        self.fan:getHeight() / 2)

    for i, value in pairs(collision_obj) do
        love.graphics.rectangle('line', value.x, value.y, value.width, value.height)
    end
    for i, value in pairs(vegetables) do
        love.graphics.rectangle('line', value.x, value.y, value.width, value.height)
    end

    self.player:render()
    for i, value in pairs(lamps) do
        love.graphics.draw(self.lampImage, value.x, value.y, 0, 1, 1)
    end
    -- love.graphics.print(self.player.x,200,200) 
    love.graphics.print("heloo", 3400, 200)
    cam:detach()

    love.graphics.print(self.player.x, 200, 200)

    -- love.graphics.print("Use arrow keys to move, 1–15 to change style", 10, 10)

end

