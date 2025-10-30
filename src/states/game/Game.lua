Game = Class {
    __includes = BaseState
}
function Game:init()
    self.windowW, self.windowH = 900, 600
    self.gameW, self.gameH = 500, 350
    self.gameX, self.gameY = (self.windowW-self.gameW)/2, (self.windowH-self.gameH)/2

    self.player = {
        x = self.gameX + self.gameW/2,
        y = self.gameY + self.gameH - 40,
        w = 20, h = 20,
        speed = 240
    }

    self.bullets = {}
    self.enemies = {}
    self.spawnTimer = 0
    self.shootCool = 0
    self.score = 0
end

function Game:update(dt)
    -- Player movement
    if love.keyboard.isDown("left") then
        self.player.x = math.max(self.gameX+5, self.player.x - self.player.speed*dt)
    elseif love.keyboard.isDown("right") then
        self.player.x = math.min(self.gameX+self.gameW - self.player.w - 5, self.player.x + self.player.speed*dt)
    end

    -- Shooting
    if love.keyboard.isDown("space") and self.shootCool <= 0 then
        table.insert(self.bullets, {x=self.player.x + self.player.w/2, y=self.player.y})
        self.shootCool = 0.12
    end
    self.shootCool = self.shootCool - dt

    -- Bullets move
    for i=#self.bullets,1,-1 do
        local b = self.bullets[i]
        b.y = b.y - 400*dt
        if b.y < self.gameY then table.remove(self.bullets,i) end
    end

    -- Spawn enemies
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer > 0.8 then
        self.spawnTimer = 0
        local spawnX = self.gameX + 10 + math.random() * (self.gameW - 20)
        table.insert(self.enemies, {x=spawnX, y=self.gameY+5, size=30, speed=140})
    end

    -- Enemies move + collision
    for i=#self.enemies,1,-1 do
        local e = self.enemies[i]
        e.y = e.y + e.speed * dt

        for j=#self.bullets,1,-1 do
            local b = self.bullets[j]
            if b.x >= e.x and b.x <= e.x+e.size and b.y >= e.y and b.y <= e.y+e.size then
                table.remove(self.enemies,i)
                table.remove(self.bullets,j)
                self.score = self.score + 1
                break
            end
        end

        if e.y + e.size >= self.gameY + self.gameH then
            table.remove(self.enemies,i)
        end
    end 

    if self.score >=10 then 
        gStateStack:pop()
    end
end

function Game:render()
    local pulse = (math.sin(love.timer.getTime()*3)+1)/2 
    love.graphics.setColor(0, 0,0)
    love.graphics.rectangle("fill", 0, 0, 900, 600)

    -- Neon Border
    love.graphics.setColor(0, 0.9, 1, 0.9)
    love.graphics.setLineWidth(5 + pulse*2)
    love.graphics.rectangle("line", self.gameX, self.gameY, self.gameW, self.gameH, 12, 12)

    -- Outer Glow
    love.graphics.setColor(0, 0.8, 1, 0.15 + pulse*0.15)
    love.graphics.setLineWidth(14)
    love.graphics.rectangle("line", self.gameX-3, self.gameY-3, self.gameW+6, self.gameH+6, 12, 12)

    -- Player
    love.graphics.setColor(0,1,0.8)
    love.graphics.rectangle("fill", self.player.x, self.player.y, self.player.w, self.player.h)

    -- Bullets
    love.graphics.setColor(1,1,1)
    for _,b in ipairs(self.bullets) do
        love.graphics.rectangle("fill", b.x, b.y, 3, 10)
    end

    -- Enemies
    love.graphics.setColor(1,0,0.3)
    for _,e in ipairs(self.enemies) do
        love.graphics.rectangle("fill", e.x, e.y, e.size, e.size)
    end

    -- Score text
    love.graphics.setColor(0,1,1)
    love.graphics.print("SCORE: "..self.score, self.gameX, self.gameY - 30) 
    love.graphics.print("Max 10: "..self.score, self.gameX+400, self.gameY - 30)
end