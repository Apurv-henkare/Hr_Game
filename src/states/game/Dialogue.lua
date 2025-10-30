Dialogues = Class {
    __includes = BaseState
}



function Dialogues:init(index, player)
    self.player = player
    self.dialogues = {{
        text = "Hey there, traveler! Hows your journey been so far?"
    }, {
        text = "It is morning do you want to make breakfast or order Swiggy?"
    }, {
        text = "Some say money talks — others say silence is golden."
    }, {
        text = "Youve come far. But are you ready for whats next?"
    }, {
        text = "Not all questions seek answers. Some just seek you."
    }}

    -- use passed index or default 1
    self.currentIndex = index or 1
    self.currentText = ""
    self.textTimer = 0
    self.textSpeed = 40
    self.done = false
    self.exiting = false 

end

function Dialogues:update(dt)
    if self.exiting then
        return
    end

    local fullText = self.dialogues[self.currentIndex].text

    if not self.done then
        self.textTimer = self.textTimer + dt * self.textSpeed
        local len = math.min(#fullText, math.floor(self.textTimer))
        self.currentText = string.sub(fullText, 1, len)

        -- if enter pressed, instantly show full text
        if love.keyboard.wasPressed('return') and len < #fullText then
            self.currentText = fullText
            self.done = true
            return
        end

        if len == #fullText then
            self.done = true
        end
    else
        -- if done and press enter again → exit immediately
        if love.keyboard.wasPressed('return') then
            self.exiting = true
            gStateStack:pop()
        end
    end
end

function Dialogues:render()
    if self.exiting then
        return
    end
    love.graphics.setColor(0, 0, 0, 0.9)
    love.graphics.rectangle("fill", 30, 30 + 35, 840, 200, 12)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont('font_game.ttf', 21))
    love.graphics.printf(self.currentText, 50, 60 + 35, 800) 

    if self.done then
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.printf("Press Enter to continue", 0, 180, 900, "center")
    end
end
