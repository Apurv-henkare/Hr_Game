MainMenu = Class { __includes = BaseState }

function MainMenu:init()
    self.titleFont = love.graphics.newFont('eight-bit-dragon.otf', 30)
    self.textFont = love.graphics.newFont('eight-bit-dragon.otf', 18)

    self.blinkTimer = 0
    self.showText = true
    self.sparks = {}  -- particle table
end

function MainMenu:update(dt)
    -- Blink timer for "Press Enter"
    self.blinkTimer = self.blinkTimer + dt
    if self.blinkTimer > 0.6 then
        self.showText = not self.showText
        self.blinkTimer = 0
    end

    -- Update sparks (movement)
    for i = #self.sparks, 1, -1 do
        local s = self.sparks[i]
        s.y = s.y - s.speed * dt
        if s.y < 0 then table.remove(self.sparks, i) end
    end

    -- Spawn new sparks if under limit
    if #self.sparks < 50 then
        local screenW, screenH = 900, 600
        table.insert(self.sparks, {
            x = math.random(0, screenW),
            y = screenH,
            speed = math.random(20, 50),
            size = math.random(1, 3)
        })
    end

    -- Start game
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then 
        activateAudio()
        gStateStack:pop()
        gStateStack:push(PlayState())
    end
end

function MainMenu:render()
    local screenW, screenH = 900, 600

    -- 1️⃣ Gradient Background (evening feel)
    for y = 0, screenH do
        local t = y / screenH
        love.graphics.setColor(0.05, 0.05, 0.1 + 0.1 * t, 1) -- top dark bluish gray → lighter horizon
        love.graphics.rectangle("fill", 0, y, screenW, 1)
    end
    love.graphics.setColor(1, 1, 1)

    -- 2️⃣ Draw subtle particles (dust/fireflies)
    for i, s in ipairs(self.sparks) do
        love.graphics.setColor(1, 0.9, 0.7, 0.3) -- soft warm glow
        love.graphics.circle("fill", s.x, s.y, s.size)
    end
    love.graphics.setColor(1, 1, 1)

    -- 3️⃣ Pulsing Title Text
    local t = love.timer.getTime()
    local glow = 0.7 + 0.3 * math.sin(t * 2) -- pulsing alpha
    love.graphics.setFont(self.titleFont)
    love.graphics.setColor(1, 0.9, 0.7, glow) -- soft warm color
    love.graphics.printf("Take A Step Forward", 0, screenH / 2 - 60-70, screenW, "center")
    love.graphics.printf("Make Every Rupee Count", 0, screenH / 2 - 60+70-70, screenW, "center")

    -- 4️⃣ Blinking "Press ENTER to Start"
    if self.showText then
        love.graphics.setFont(self.textFont)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Press ENTER to Start", 0, screenH / 2 + 40+70-70, screenW, "center")
    end

    love.graphics.setColor(1, 1, 1)
end
