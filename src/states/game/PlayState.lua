PlayState = Class {
    __includes = BaseState
}

function PlayState:enter()

end
function PlayState:init()
    self.player = Player()
    self.homeImage = love.graphics.newImage('Image/Home_3.png')
    self.fan= love.graphics.newImage("Image/fan.png") 
    self.bg = love.graphics.newImage("Image/C2.png") 
    self.scroll = 0
    self.SCROLL_SPEED = 50     -- pixels per second
    self.BG_LOOP_POINT = self.bg:getWidth()
    self.fanAngle = 0
end

function PlayState:update(dt)

    self.player:update(dt) 
    self.fanAngle = self.fanAngle + 20* dt  
    self.scroll = (self.scroll + self.SCROLL_SPEED * dt) % self.BG_LOOP_POINT

    if (self.player.x <=470) then 
        cam:lookAt(470,WINDOW_HEIGHT/2)
    elseif (self.player.x >470 and self.player.x <=1900) then
        cam:lookAt(self.player.x, WINDOW_HEIGHT/2) 
    elseif(self.player.x >1900 and love.keyboard.wasPressed('return')) then
        self.player.x =2500 
        cam:lookAt(2700,WINDOW_HEIGHT/2)
    end


end

function AABB(a, b)
    return a.x < b.x + b.width and b.x < a.x + a.width and a.y < b.y + b.height and b.y < a.y + a.height
end

function PlayState:render() 
    love.graphics.draw(self.bg, -self.scroll, 0) 
     love.graphics.draw(self.bg, -self.scroll + self.bg:getWidth(), 0)
    cam:attach() 
   

    --love.graphics.print("Background or map here", 100, 100)  
     -- background scroll--
    
    love.graphics.draw(self.homeImage,0,WINDOW_HEIGHT-600) 
    love.graphics.draw(
        self.fan,
        100, WINDOW_HEIGHT-400,
        self.fanAngle,
        1.2, 1.2,
        self.fan:getWidth() / 2,
        self.fan:getHeight() / 2
    )
    self.player:render()
    --love.graphics.print(self.player.x,200,200)
    cam:detach()  
    
    love.graphics.print(self.player.x,200,200)
   -- love.graphics.print("Use arrow keys to move, 1–15 to change style", 10, 10)

end

