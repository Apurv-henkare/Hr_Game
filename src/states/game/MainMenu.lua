MainMenu = Class { __includes = BaseState }

function MainMenu:init()
    self.titleFont = love.graphics.newFont('eight-bit-dragon.otf', 30)
    self.textFont = love.graphics.newFont('eight-bit-dragon.otf', 18)
    self.blinkTimer = 0
    self.showText = true
end

function MainMenu:update(dt)
    -- blink timer for "Press Enter"
    self.blinkTimer = self.blinkTimer + dt
    if self.blinkTimer > 0.6 then
        self.showText = not self.showText
        self.blinkTimer = 0
    end

    -- start game
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:pop()
        gStateStack:push(PlayState())
    end
end

function MainMenu:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(self.titleFont)
    love.graphics.printf("Gencraft : Rebuild Rethink Reinvent", 0, VIRTUAL_HEIGHT / 2 - 60, VIRTUAL_WIDTH, 'center')

    if self.showText then
        love.graphics.setFont(self.textFont)
        love.graphics.printf("Press ENTER to Start", 0, VIRTUAL_HEIGHT / 2 + 40, VIRTUAL_WIDTH, 'center')
    end
end
