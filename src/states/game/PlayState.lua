PlayState = Class {
    __includes = BaseState
}
time = 0
collision_obj = {{
    x = 3400,
    y = WINDOW_HEIGHT - 16 * 4 - 40,
    width = 400,
    height = 250,
    key = 13,
    choice = false
}, {
    x = 12100,
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
}, {
    x = 8239 + 40,
    y = WINDOW_HEIGHT - 16 * 6 - 50 - 70 - 60,
    width = 100,
    height = 50 + 50,
    key = 9
}, {
    x = 8864 + 40,
    y = WINDOW_HEIGHT - 16 * 6 - 50 - 70 - 60,
    width = 100,
    height = 50 + 50,
    key = 4
}, {
    x = 9465 + 40,
    y = WINDOW_HEIGHT - 16 * 6 - 50 - 70 - 60,
    width = 100,
    height = 50 + 50,
    key = 6
}, {
    x = 10089 + 40,
    y = WINDOW_HEIGHT - 16 * 6 - 50 - 70 - 60,
    width = 100,
    height = 50 + 50,
    key = 11
}, {
    x = 10698 + 40,
    y = WINDOW_HEIGHT - 16 * 6 - 50 - 70 - 60,
    width = 100,
    height = 50 + 50,
    key = 10
}} 

signs = {
        { x = 4050, y = 200, text = "4 Km left\nYou’re stronger than you think!" },
        { x = 5500, y = 200, text = "2 Km left\nKeep moving, step by step!" },
        { x = 6200, y = 200, text = "Almost there!\nFeel the energy, keep going!" },
        { x = 6900, y = 200, text = "You made it!\nCelebrate your effort 🎉" },
        { x = 13900, y = 200, text = "4 Km left\nYou’re stronger than you think!" },
        { x = 14500, y = 200, text = "2 Km left\nKeep moving, step by step!" },
        { x = 15500, y = 200, text = "Almost there!\nFeel the energy, keep going!" },
        { x = 16000, y = 200, text = "You made it!\nCelebrate your effort 🎉" }
    } 

fans = {
        {
            x = 550,
            y = 140,
            radius = 120,
            bladeCount = 5,
            rotation = 0,
            speed = 7.0
        },
        {
            x = 550+900,
            y = 140,
            radius = 120,
            bladeCount = 5,
            rotation = 0,
            speed = 7.0
        }
    }
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

stars = {}
for i = 1, 100 do
    table.insert(stars, {
        x = math.random(0, love.graphics.getWidth()),
        y = math.random(0, love.graphics.getHeight()),
        size = math.random(1, 3),
        brightness = math.random() -- used for twinkle
    })
end

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
    self.back = love.graphics.newImage("Image/back.png")
    self.club = love.graphics.newImage("Image/club.png")
    self.city = love.graphics.newImage('Image/city.png')
    -- self.night = love.graphics.newImage('Image/pahad.png')
    self.jungle = love.graphics.newImage('Image/jungle.png')
    self.mall_front = love.graphics.newImage('Image/Mall_front.png')
    self.mall_back = love.graphics.newImage('Image/Mall_back.png')
    self.scroll = 0
    self.SCROLL_SPEED = 50 -- pixels per second
    self.BG_LOOP_POINT = self.bg:getWidth()
    self.fanAngle = 0
    self.choice = false
    self.cross1 = false
    self.movie1 = false
    self.bot = false
    self.sunset = 0
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

    for x = 12000, 16000, gap do
        table.insert(lamps, {
            x = x,
            y = baseY
        })
    end
end 

function drawFan(fan)
    local cx, cy = fan.x, fan.y
    local t = love.timer.getTime()
    local pulse = (math.sin(t * 2) + 1) / 2

    -- ceiling rod
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", cx - 2, 0, 4, cy - 10)

    -- light glow
    love.graphics.setColor(1, 0.95, 0.75, 0.15 + pulse * 0.1)
    --love.graphics.circle("fill", cx, cy + 100, 70)

    -- draw blades
    for i = 1, fan.bladeCount do
        local baseAngle = (i - 1) * (2 * math.pi / fan.bladeCount)
        local angle = fan.rotation + baseAngle
        local depth = math.sin(angle)
        local fade = 0.3 + 0.7 * (1 - math.abs(depth))

        local x1 = cx
        local y1 = cy
        local x2 = cx + math.cos(angle) * fan.radius
        local y2 = cy + math.sin(angle) * 10

        love.graphics.setColor(0.3 + 0.5 * fade, 0.1 + 0.3 * fade, 0.1, fade)
        love.graphics.setLineWidth(12 * fade)
        love.graphics.line(x1, y1, x2, y2)
    end

    -- hub
    love.graphics.setColor(0.15, 0.15, 0.18)
    love.graphics.circle("fill", cx, cy, 14)

    -- highlight
    love.graphics.setColor(1, 1, 1, 0.2)
    love.graphics.circle("fill", cx - 3, cy - 2, 5)
end 

function drawRoundedRect(x, y, w, h, r)
    love.graphics.rectangle("fill", x + r, y, w - 2 * r, h)
    love.graphics.rectangle("fill", x, y + r, w, h - 2 * r)
    love.graphics.circle("fill", x + r, y + r, r)
    love.graphics.circle("fill", x + w - r, y + r, r)
    love.graphics.circle("fill", x + r, y + h - r, r)
    love.graphics.circle("fill", x + w - r, y + h - r, r)
end

function PlayState:update(dt)
    time = time + dt
    self.player:update(dt) 
    for _, fan in ipairs(fans) do
        fan.rotation = fan.rotation + fan.speed * dt
    end
    self.fanAngle = self.fanAngle + 20 * dt
    self.scroll = (self.scroll + self.SCROLL_SPEED * dt) % self.BG_LOOP_POINT

    if (self.player.x <= 470) then
        cam:lookAt(470, WINDOW_HEIGHT / 2)
    elseif (self.player.x > 470 and self.player.x <= 1900) then
        self.cross1 = true
        cam:lookAt(self.player.x, WINDOW_HEIGHT / 2)
    elseif (self.player.x > 1900) and self.cross1 == true then
        self.player.maxX = 2500
        self.player.minX = 9000
        self.player.x = 2500
        self.cross1 = false
        cam:lookAt(2900, WINDOW_HEIGHT / 2)
    elseif (self.player.x >= 2900 and self.player.x < 7000) then
        cam:lookAt(self.player.x, WINDOW_HEIGHT / 2)
    elseif (self.player.x >= 7000) then
        self.player.maxX = 7000
        self.player.minX = 23000
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

    for key, value in ipairs(self.player.purchased) do
        if value == 6 and self.movie1 == false then
            self.movie1 = true
            -- self.carTriggered = true
            gStateStack:push(Movie())
        end
        if value == 1 then
            self.player.myntra = true
        end
        if value == 4 then
            self.player.dress = true
        end
        if value == 10 then
            self.player.hair = true
        end
        if value == 7 then
            self.player.gadget = true
        end
    end

    for key, value in ipairs(vegetables) do
        if AABB(value, self.player) then
            value.x = -20000
            -- gStateStack:push(QuestionSet(value.key,self.player))
        end
    end

    if love.keyboard.wasPressed('l') or self.player.x >= 20000 then
        gStateStack:pop()
        gStateStack:push(End(self.player.purchased, self.player.money))
    end

    if self.player.x >= 13000 then
        self.sunset = math.min(250, self.sunset + 10 * dt)

    end
end

local function hsvToRgb(h, s, v)
    local c = v * s
    local x = c * (1 - math.abs((h / 60) % 2 - 1))
    local m = v - c
    local r, g, b = 0, 0, 0

    if h < 60 then
        r, g, b = c, x, 0
    elseif h < 120 then
        r, g, b = x, c, 0
    elseif h < 180 then
        r, g, b = 0, c, x
    elseif h < 240 then
        r, g, b = 0, x, c
    elseif h < 300 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end

    return r + m, g + m, b + m
end

function AABB(a, b)
    return a.x < b.x + b.width and b.x < a.x + a.width and a.y < b.y + b.height and b.y < a.y + a.height
end

function PlayState:render()
    if self.player.x <= 9000 then
        love.graphics.setColor(1, 1, 1, 0.7)
    elseif self.player.x > 9000 and self.player.x <= 19000 then
        -- love.graphics.setColor(1, 0.3, 0, 0.9) 
        love.graphics.setColor(1, 0.4, 0.4, 0.9)
        -- love.graphics.setColor(0.0, 0.0, 0.2, 0.4) 
    else
        love.graphics.setColor(0.0, 0.0, 0.2, 0.4)
    end
    love.graphics.draw(self.bgImage, 0, 0, 0, 3, 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setColor(1, 1, 1)
    if self.player.x <= 9000 then
        love.graphics.draw(self.back, 0 - self.player.bgx, WINDOW_HEIGHT - 400, 0, 2, 2)

        -- 🌤 Afternoon Burning Sun
        local sunX, sunY = 700, 120
        local sunRadius = 60

        -- 🔥 Heat shimmer timing
        local t = love.timer.getTime()

        -- 🔆 Glowing shimmer layers (slow moving heat)
        for i = 1, 8 do
            -- subtle alpha flicker (soft breathing light)
            local alpha = 0.05 + math.sin(t * (0.8 + i * 0.2)) * 0.02

            -- very small offset to simulate rising heat shimmer
            local shimmer = math.sin(t * (0.5 + i * 0.1) + i) * 1.5

            love.graphics.setColor(1, 0.9, 0.4, alpha)
            love.graphics.circle("fill", sunX, sunY + shimmer, sunRadius + i * 5)
        end

        -- ☀️ Main bright sun (steady core, no pulse)
        love.graphics.setColor(1, 1, 0.6, 1)
        love.graphics.circle("fill", sunX, sunY, sunRadius)

        -- reset
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.bg, -self.scroll, 0)
        love.graphics.draw(self.bg, -self.scroll + self.bg:getWidth(), 0)
    elseif self.player.x > 9000 and self.player.x <= 19000 then
        -- 🌇 Sunset Sun
        -- 🌆 Evening Burning Sun
        local sunX, sunY = 600, 150 -- position in sky
        local sunRadius = 50
        local t = love.timer.getTime()

        -- 🔥 Soft glowing shimmer (slow, stable)
        for i = 1, 10 do
            -- subtle transparency flicker for warm sunlight
            local alpha = 0.05 + math.sin(t * (0.7 + i * 0.15)) * 0.015

            -- slow vertical shimmer (rising heat distortion)
            local shimmer = math.sin(t * (0.4 + i * 0.1) + i) * 1.2

            love.graphics.setColor(1, 0.6, 0.1, alpha)
            love.graphics.circle("fill", sunX, sunY + 50 + shimmer + self.sunset, sunRadius + i * 5)
        end

        -- ☀️ Main sunset sun core (no radius change)
        love.graphics.setColor(1, 0.6, 0.3, 1)
        love.graphics.circle("fill", sunX, sunY + 50 + self.sunset, sunRadius)

        -- reset color and draw city
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.city, 0 - self.player.city_x, 100)

    elseif self.player.x > 19000 then

        -- ✨ Draw stars
        for _, star in ipairs(stars) do
            local alpha = 0.5 + 0.5 * math.sin(love.timer.getTime() * 2 + star.brightness * 10)
            love.graphics.setColor(1, 1, 1, alpha)
            love.graphics.circle("fill", star.x, star.y, star.size)
        end

        local moonX, moonY = 700, 100 -- position
        local moonRadius = 40

        -- glow layer (soft light)
        for i = 1, 10 do
            love.graphics.setColor(1, 1, 0.8, 0.05) -- pale yellow glow
            love.graphics.circle("fill", moonX, moonY, moonRadius + i * 3)
        end

        -- solid moon
        love.graphics.setColor(1, 1, 0.9, 1)
        love.graphics.circle("fill", moonX, moonY, moonRadius)
        love.graphics.draw(self.jungle, 0 - self.player.bgx, 100)
    end

    -- love.graphics.setColor(1, 1, 1, 1)
    -- love.graphics.draw(self.bg, -self.scroll, 0)
    -- love.graphics.draw(self.bg, -self.scroll + self.bg:getWidth(), 0)
    love.graphics.setColor(1, 1, 1, 1)
    -- love.graphics.rectangle('fill', 0, WINDOW_HEIGHT - 16 * 6, 10000, 16 * 6 - 10) 

    local roadY = WINDOW_HEIGHT - 16 * 6
    local roadHeight = 16 * 6 - 10 + 20

    -- Base road
    love.graphics.setColor(0.2, 0.2, 0.2) -- asphalt gray
    love.graphics.rectangle('fill', 0, roadY, 10000, roadHeight)

    -- Road top and bottom edges
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle('fill', 0, roadY, 10000, 4) -- top border
    love.graphics.rectangle('fill', 0, roadY + roadHeight - 4, 10000, 4) -- bottom border

    -- -- Center dashed line
    -- love.graphics.setColor(1, 1, 0.6)
    -- for i = 0, 10000, 80 do
    --     love.graphics.rectangle('fill', i, roadY + roadHeight / 2 - 2, 40, 4)
    -- end

    -- Road texture (optional small dots)
    love.graphics.setColor(0.25, 0.25, 0.25, 0.5)
    for i = 1, 200 do
        local x = math.random(0, 10000)
        local y = math.random(roadY, roadY + roadHeight)
        love.graphics.circle('fill', x, y, 1)
    end

    love.graphics.setColor(1, 1, 1)

    -- love.graphics.draw(self.homeImage, 0, WINDOW_HEIGHT - 600,0,1)
    cam:attach()
    -- love.graphics.print("Background or map here", 100, 100)  
    -- background scroll-- 
    -- love.graphics.draw(self.back,2000,WINDOW_HEIGHT-400,0,10,3)
    -- love.graphics.rectangle('fill', 2000, WINDOW_HEIGHT - 16 * 6, 10000, 16 * 6 - 10)
    love.graphics.draw(self.homeImage, -50, WINDOW_HEIGHT - 600, 0, 1)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.mall_front, 8000-277, WINDOW_HEIGHT - 600-5, 0, 1, 1.03)
    love.graphics.draw(self.mallImage, 8000, WINDOW_HEIGHT - 600, 0, 1, 1)
    love.graphics.draw(self.mall_back, 8000+3000, WINDOW_HEIGHT - 600-5, 0, 1, 1.03)
    --love.graphics.draw(self.fan, 100, WINDOW_HEIGHT - 400, self.fanAngle, 1.2, 1.2, self.fan:getWidth() / 2,
     --   self.fan:getHeight() / 2)

    local t = love.timer.getTime()
    local pulse = (math.sin(t * 2) + 1) / 2
    local grow = 1 + pulse * 0.3 -- subtle scale pulse

    -- 🎨 deep pink–red tint values
    local baseR, baseG, baseB = 1.0, 0.2, 0.4 -- main glow tone (pink-red)
    local brightR, brightG, brightB = 1.0, 0.2, 0.5 -- highlight tone

    for _, cp in ipairs(collision_obj) do

    end 
    for _, fan in ipairs(fans) do
        drawFan(fan)
    end

    love.graphics.setColor(1, 1, 1)
    for i, value in pairs(vegetables) do
        love.graphics.rectangle('line', value.x, value.y, value.width, value.height)
    end 

    -- simple ground
    -- love.graphics.setColor(0.4, 0.3, 0.2)
    -- love.graphics.rectangle("fill", 0, 340, 800, 60)

    -- player (circle)
    love.graphics.setColor(0.1, 0.1, 0.1)
   -- love.graphics.circle("fill", self.player.x, player.y - 20, 15)

    -- motivational blocks
    for _, s in ipairs(signs) do
        local w, h, r = 220, 80, 14
        local dist = math.abs(self.player.x - s.x)
        local glow = math.max(0, 1 - dist / 200)

        -- background block
        love.graphics.setColor(1.0, 0.8 + 0.1 * glow, 0.3 + 0.4 * glow, 0.7)
        drawRoundedRect(s.x - w / 2, s.y, w, h, r)

        -- text inside (centered)
        love.graphics.setColor(0.1, 0.1, 0.1)
        love.graphics.printf(s.text, s.x - w / 2 + 10, s.y + 20, w - 20, "center")
    end
    love.graphics.setColor(1,1,1)
    self.player:render() 
    love.graphics.setColor(1,1,1)
    for i, value in pairs(lamps) do
        love.graphics.draw(self.lampImage, value.x, value.y, 0, 1, 1)
    end
    -- love.graphics.print(self.player.x,200,200) 
    love.graphics.print("heloo", 3400, 200)
    cam:detach()

    -- love.graphics.print(self.player.x, 200, 200)

    -- love.graphics.print("Use arrow keys to move, 1–15 to change style", 10, 10)

end

