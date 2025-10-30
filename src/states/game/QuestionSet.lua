QuestionSet = Class {
    __includes = BaseState
}

function QuestionSet:init(startIndex, player)
    self.player = player -- store player object
    self.questions = {
    {
        text = "Snagged a cute dress and a trendy tee during the Myntra Sale  couldn't resist that deal!",
        price = 800,
        category = "Fashion"
    }, {
        text = "Ordered Swiggy because home food just wasn't vibing today!",
        price = 300,
        category = "Food and Lifestyle"
    }, {
        text = "Clicked 'Buy Now' on an Insta ad that totally caught your eye  no regrets!",
        price = 500,
        category = "Lifestyle"
    }, {
        text = "Matched your friend's party look by buying the same dress  twinning goals!",
        price = 1000,
        category = "Fashion"
    }, {
        text = "Went to a concert just because your squad was going  FOMO wins!",
        price = 1200,
        category = "Lifestyle"
    }, {
        text = "Rewatched a movie in theatres just to hang out with a friend  memories matter!",
        price = 400,
        category = "Lifestyle"
    }, {
        text = "Scored a gadget during Amazon's Big Bang Sale  mega discount magic!",
        price = 1500,
        category = "Tech"
    }, {
        text = "Paid extra to waive off credit card charges  peace of mind, right?",
        price = 600,
        category = "Lifestyle"
    }, {
        text = "Grabbed a Starbucks while waiting for a friend  treat yourself!",
        price = 350,
        category = "Food and Lifestyle"
    }, {
        text = "Tried a new hair treatment because your stylist swore by it  self-care unlocked!",
        price = 900,
        category = "Health"
    }, {
        text = "Picked up a cookie at the mall thanks to a sudden sweet craving  yum!",
        price = 150,
        category = "Food and Lifestyle"
    }, {
        text = "Gave a spontaneous gift to a child  heartwarming impulse!",
        price = 500,
        category = "Lifestyle"
    }, {
        text = "Took a cab or rickshaw instead of walking  comfort first!",
        price = 200,
        category = "Lifestyle"
    }, {
        text = "Bought veggies just because they were super cheap  who doesn't love a bargain?",
        price = 100,
        category = "Food and Lifestyle"
    }, {
        text = "Spent on online games after hitting a limit  just had to keep playing!",
        price = 700,
        category = "Tech"
    }
}

    self.currentIndex = startIndex or 1
    self.currentText = ""
    self.textTimer = 0
    self.textSpeed = 40
    self.done = false

    self.transactionComplete = false
    self.failed = false
    self.cancelled = false
end

-- Update typing effect and handle Y/N/Enter input
function QuestionSet:update(dt)
    -- Typing effect
    if not self.done then
        self.textTimer = self.textTimer + dt * self.textSpeed
        local fullText = self.questions[self.currentIndex].text
        local len = math.min(#fullText, math.floor(self.textTimer))
        self.currentText = string.sub(fullText, 1, len)
        if len == #fullText then
            self.done = true
        end
    end

    -- Handle Y/N input for transaction
    if self.done and not self.transactionComplete and not self.failed and not self.cancelled then
        if love.keyboard.wasPressed('y') then
            self:performTransaction()
        elseif love.keyboard.wasPressed('n') then
            print("Transaction cancelled by user.")
            self.cancelled = true
        end
    end

    -- Continue after transaction complete, failed, or cancelled
    if (self.transactionComplete or self.failed or self.cancelled) and love.keyboard.wasPressed('return') then
        print("Exiting question " .. self.currentIndex)
        -- Reset all flags
        self.transactionComplete = false
        self.failed = false
        self.cancelled = false
        self.currentText = ""
        self.textTimer = 0
        self.done = false
        -- Pop state or call external function
        gStateStack:pop()
    end
end

-- Render dialogue box
function QuestionSet:render()
    love.graphics.setColor(0.2, 0.2, 0.2, 0.98)
    love.graphics.rectangle("fill", 30-5, 30+ 35-5, 840+10, 200+10, 12) 
    love.graphics.setColor(0, 0, 0, 0.98)
    love.graphics.rectangle("fill", 30, 30+ 35, 840, 200, 12)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont('font_game.ttf',21))

    if self.transactionComplete then
        love.graphics.printf("Transaction COMPLETE!    Remaining money: " .. self.player.money, 50, 100+ 35, 800, "center") 
        love.graphics.printf("Press Enter to continue.", 50, 100+ 35+50, 800, "center")
        hooting = true
    elseif self.failed then
        love.graphics.printf("Transaction FAILED! Not enough money: " .. self.player.money, 50, 100+ 35, 800, "center")
        love.graphics.printf("Press Enter to continue.", 50, 100+ 35+50, 800, "center")
    elseif self.cancelled then
        love.graphics.printf("No Transaction Performed! ", 50, 100+ 35, 800, "center")
        love.graphics.printf("Press Enter to continue.", 50, 100+ 35+50, 800, "center")
    else
        love.graphics.printf(self.currentText, 50, 50+ 35, 800)
        local price = self.questions[self.currentIndex].price
        love.graphics.printf("Price: Rs " .. price, 50, 140+20, 800)
        if self.done then
            love.graphics.setColor(0.8, 0.8, 0.8)
            love.graphics.printf("[Y] Yes    [N] No", 0, 160, 900, "center")
        end
    end
end

-- Perform transaction immediately
function QuestionSet:performTransaction()
    local price = self.questions[self.currentIndex].price
    if self.player.money >= price then
        self.player.money = self.player.money - price
        print("Transaction CONFIRMED! Remaining money: " .. self.player.money)
        self.transactionComplete = true 
        table.insert(self.player.purchased, self.currentIndex)
        for key,value in pairs(self.player.purchased) do
           -- print(key.." "..value)    
            if self.currentIndex == 13 and value == 13 then 
                self.player.carTriggered = true 
                self.player.carReached = false
            end
        end
    else
        print("Transaction FAILED: insufficient funds!")
        self.failed = true
    end
end

-- Jump to a specific question
function QuestionSet:goTo(index)
    if index >= 1 and index <= #self.questions then
        self.currentIndex = index
        self.currentText = ""
        self.textTimer = 0
        self.done = false
        self.transactionComplete = false
        self.failed = false
        self.cancelled = false
    end
end
