End = Class { __includes = BaseState }

function End:init(score) 
    self.score = score or 0
    self.textLines = {
        " The 5 Principles of Innovation ",
        
        "1. Associating : Collecting the right parts to fix a broken gear.",
        "2. Questioning : Asking the right question to unlock the best solution.",
        "3. Observing : Watching carefully for '?' hints and green lab clues.",
        "4. Experimenting : Placing bots around the circle to learn what works.",
        "5. Networking : Asking another robot where to go or what to try.",
        
        "Keep these skills alive : you're becoming an innovator! "
    }
    self.background = love.graphics.newImage('Image/planetbg.png')
    self.currentLine = 1
    self.displayedLines = {} -- full lines
    self.typing = ""
    self.charIndex = 1
    self.timer = 0
    self.charDelay = 0.03
    self.lineDelay = 1.0
    self.state = "typing" -- typing or waiting
end

function End:update(dt)
    if self.currentLine > #self.textLines then return end

    if self.state == "typing" then
        self.timer = self.timer + dt
        local fullText = self.textLines[self.currentLine]

        if self.timer >= self.charDelay then
            if self.charIndex <= #fullText then
                self.typing = fullText:sub(1, self.charIndex)
                self.charIndex = self.charIndex + 1
                self.timer = 0
            else
                table.insert(self.displayedLines, self.typing)
                self.typing = ""
                self.charIndex = 1
                self.currentLine = self.currentLine + 1
                self.timer = 0
                self.state = "waiting"
            end
        end

    elseif self.state == "waiting" then
        self.timer = self.timer + dt
        if self.timer >= self.lineDelay then
            self.state = "typing"
            self.timer = 0
        end
    end

    if love.keyboard.wasPressed("m") then
        gStateStack:pop() -- or change state 
        gStateStack:push(User(self.score))
    end
end

function End:render()
    --love.graphics.setFont(gFonts.medium) 
     love.graphics.setColor(1,1,1,0.5)
    love.graphics.draw(self.background, 0, 0)
    local y = 50

    local linesToShow = deepcopy(self.displayedLines)
    if self.typing ~= "" then
        table.insert(linesToShow, self.typing)
    end

    for _, line in ipairs(linesToShow) do
        local padding = 12
        local textWidth = love.graphics.getFont():getWidth(line)
        local textHeight = love.graphics.getFont():getHeight()
        local rectWidth = textWidth + padding * 2
        local rectHeight = textHeight + padding * 2
        local x = (VIRTUAL_WIDTH - rectWidth) / 2

        -- Draw background rectangle
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", x, y - padding, rectWidth, rectHeight, 8, 8)

        -- Draw white text
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(line, 0, y, VIRTUAL_WIDTH, "center")

        y = y + rectHeight + 10
    end 

    love.graphics.print(self.score,10,10)
end

-- Helper to clone tables (since Lua passes references)
function deepcopy(orig)
    local copy = {}
    for k, v in ipairs(orig) do
        copy[k] = v
    end
    return copy
end
