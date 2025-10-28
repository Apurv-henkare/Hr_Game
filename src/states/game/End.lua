End = Class { __includes = BaseState }

function End:init(question,amount)
    -- Table with two keys
    self.data = {
        Attempted = question, -- table to store attempted levels, questions, etc.
        money = amount       -- score, coins, or total earned
    }

    -- Example text
    self.title = "Game Over"
    self.subtitle = "Press Enter to Restart" 

     jsonData = json.encode(self.data)
end

function End:update(dt) 

     if (JS.retrieveData(dt)) then
        return
    end
    -- Example: pressing Enter returns to StartState
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then 
        JS.callJS([[receiveFromLua(]] .. jsonData .. [[)]])
        --gStateMachine:change('start')
    end 
end

function End:render()
    -- Draw title and summary
 
    love.graphics.printf(self.title, 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')


    love.graphics.printf(self.subtitle, 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')

    -- Show summary data
  
    love.graphics.printf("Money Earned: " .. tostring(self.data.money), 0, VIRTUAL_HEIGHT * 0.7, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Attempts: " .. tostring(self.data.Attempted), 0, VIRTUAL_HEIGHT * 0.75, VIRTUAL_WIDTH, 'center')
end
