Intro = Class {
    __includes = BaseState
}

function Intro:init()
   -- self.player = Player()
    --self.background = love.graphics.newImage('Image/planetbg.png')
    self.text = "Planet Name: Nuvex-7 \n\n \n A remote, mineral-rich planet operated entirely by AI and robotic systems.\n\n Owned by the interstellar mining corporation Xylem Corp., the planet was a critical source of rare minerals for Earth.\n\nOne day, Nuvex-7 went completely silent. No shipments. No signals.\n\n You a corporate innovation agent are deployed to investigate."
    self.currentTextLength = 0
    self.textTimer = 0 
    self.joystick = love.joystick.getJoysticks()[1] 
    self.fadeAlpha = 0           -- starts transparent
    self.fading = false
end

function Intro:update(dt) 
    --self.player:update(dt)
    self.textTimer = self.textTimer + dt
    if self.textTimer >= 0.01 and self.currentTextLength < #self.text then
        self.currentTextLength = self.currentTextLength + 1
        self.textTimer = 0
    end 

    if love.keyboard.wasPressed('return') and not self.fading then
        -- gSounds['confirm']:play()

         self.fading = true       -- prevent retriggering fade

        -- Tween fadeAlpha from 0 to 1 over 1 second
        Timer.tween(1, {
            [self] = {fadeAlpha = 1}
        }):finish(function()
            -- Switch state after fade completes
            gStateStack:pop()
            gStateStack:push(PlayState())  -- or 'PlayState'
        end)
           
    end  
end 

function Intro:render()
    love.graphics.setFont(love.graphics.newFont(18))
    love.graphics.draw(self.background, 0, 0)
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 900, 50, 300, 500)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(self.text:sub(1, self.currentTextLength), 910, 60, 280, "left") 

    -- Draw the fade rectangle
    love.graphics.setColor(0, 0, 0, self.fadeAlpha)
    love.graphics.rectangle("fill", 0, 0, 1280,780)
    love.graphics.setColor(1, 1, 1, 1) -- reset color

    --self.player:render()
end
