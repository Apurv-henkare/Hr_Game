End = Class { __includes = BaseState }

function End:init(question, amount)
    -- Store results
    self.data = {
        Attempted = question or 0,
        money = amount or 0
    }

    self.title = "GAME OVER"
    self.subtitle = "Press Enter to Submit Your Score"
    self.alpha = 0 -- for fade-in animation

    -- JSON encode data for JS interop
    self.jsonData = json.encode(self.data)
end

function End:update(dt)
    -- Fade-in effect
    if self.alpha < 1 then
        self.alpha = math.min(1, self.alpha + dt * 0.8)
    end

    -- JS retrieval check
    if JS.retrieveData(dt) then return end

    -- Restart when pressing Enter
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then 
        JS.callJS([[receiveFromLua(]] .. self.jsonData .. [[)]])
        -- gStateMachine:change('start')
    end
end

function End:render()
    -- Background overlay
    love.graphics.setColor(0, 0, 0, 0.7 * self.alpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    -- Reset color for text
    love.graphics.setColor(1, 1, 1, self.alpha)

    -- Title
    love.graphics.printf(self.title, 0, VIRTUAL_HEIGHT * 0.25, VIRTUAL_WIDTH, 'center')

    -- Subtitle
    love.graphics.setColor(0.9, 0.9, 0.9, self.alpha)
    love.graphics.printf(self.subtitle, 0, VIRTUAL_HEIGHT * 0.4, VIRTUAL_WIDTH, 'center')

    -- Divider
    love.graphics.setColor(1, 0.8, 0.2, self.alpha)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH * 0.25, VIRTUAL_HEIGHT * 0.48, VIRTUAL_WIDTH * 0.5, 2)

    -- Stats box
    love.graphics.setColor(1, 1, 1, 0.9 * self.alpha)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH * 0.2, VIRTUAL_HEIGHT * 0.5, VIRTUAL_WIDTH * 0.6, VIRTUAL_HEIGHT * 0.20, 12)

    -- Stats text
    love.graphics.setColor(0, 0, 0, self.alpha)
    local statsY = VIRTUAL_HEIGHT * 0.58

    love.graphics.printf("Total Money Spent:", VIRTUAL_WIDTH * 0.25, statsY, VIRTUAL_WIDTH * 0.5, 'left')
    love.graphics.printf(tostring(self.data.money), VIRTUAL_WIDTH * 0.55, statsY, VIRTUAL_WIDTH * 0.2, 'right')

    -- Footer tip
    love.graphics.setColor(1, 1, 1, 0.7 * self.alpha)
    love.graphics.printf("Tip: Keep practicing to improve your score!", 0, VIRTUAL_HEIGHT * 0.88, VIRTUAL_WIDTH, 'center')
end
