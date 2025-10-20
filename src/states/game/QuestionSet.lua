QuestionSet = Class {
    __includes = BaseState
}

function QuestionSet:init(startIndex, player)
    self.player = player  -- store player object

    self.questions = {
        { text = "Bought a cute dress/ nice T-shirt during a Myntra Sale on a great deal?", price = 800 },
        { text = "Ordered food on Swiggy, because food at home was boring?", price = 300 },
        { text = "Bought something from an ad on Instagram because it caught your eye?", price = 500 },
        { text = "Purchased the same dress your friend wore at a party to match their style?", price = 1000 },
        { text = "Went to a concert only because your friends were going?", price = 1200 },
        { text = "Rewatched a movie in the theatre to accompany a friend?", price = 400 },
        { text = "Bought a gadget during Amazon s Big Bang Sale because of the mega discount?", price = 1500 },
        { text = "Spent extra to waive off credit card charges?", price = 600 },
        { text = "Got a Starbucks coffee while waiting for a friend?", price = 350 },
        { text = "Tried a new hair treatment because your hairdresser recommended it?", price = 900 },
        { text = "Bought a cookie at the mall because of a sudden sweet craving?", price = 150 },
        { text = "Gave a gift to a child on impulse?", price = 500 },
        { text = "Took a cab or rickshaw instead of walking a short distance?", price = 200 },
        { text = "Bought vegetables just because they were cheap?", price = 100 },
        { text = "Spent money on online games after hitting a limit, just to keep playing?", price = 700 }
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
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 30, 30, 840, 200, 12)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(18))

    if self.transactionComplete then
        love.graphics.printf("Transaction COMPLETE! Remaining money: " .. self.player.money .. " | Press Enter to continue.", 50, 100, 800, "center")
    elseif self.failed then
        love.graphics.printf("Transaction FAILED! Not enough money: " .. self.player.money .. " | Press Enter to continue.", 50, 100, 800, "center")
    elseif self.cancelled then
        love.graphics.printf("No Transaction Performed! Press Enter to continue.", 50, 100, 800, "center")
    else
        love.graphics.printf(self.currentText, 50, 50, 800)
        local price = self.questions[self.currentIndex].price
        love.graphics.printf("Price: Rs " .. price, 50, 140, 800)
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
