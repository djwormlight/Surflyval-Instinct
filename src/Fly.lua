local asset = require "asset"

local Fly = {}
Fly.__index = Fly

local wasButtonPressed = false

flyFlyingAnimation = {
    {
        asset:load("fly/fly-01-01.png"),
        asset:load("fly/fly-01-02.png")
    },
    {
        asset:load("fly/fly-02-01.png"),
        asset:load("fly/fly-02-02.png")
    },
    {
        asset:load("fly/fly-03-01.png"),
        asset:load("fly/fly-03-02.png")
    },
    {
        asset:load("fly/fly-04-01.png"),
        asset:load("fly/fly-04-02.png")
    },
    {
        asset:load("fly/fly-05-01.png"),
        asset:load("fly/fly-05-02.png")
    },
    {
        asset:load("fly/fly-06-01.png"),
        asset:load("fly/fly-06-02.png")
    },
    {
        asset:load("fly/fly-07-01.png"),
        asset:load("fly/fly-07-02.png")
    },
    {
        asset:load("fly/fly-08-01.png"),
        asset:load("fly/fly-08-02.png")
    },
    {
        asset:load("fly/fly-09-01.png"),
        asset:load("fly/fly-09-02.png")
    },
    {
        asset:load("fly/fly-10-01.png"),
        asset:load("fly/fly-10-02.png")
    },
    {
        asset:load("fly/fly-11-01.png"),
        asset:load("fly/fly-11-02.png")
    },
    {
        asset:load("fly/fly-12-01.png"),
        asset:load("fly/fly-12-02.png")
    }
}

flyRestAnimation = {
    asset:load("fly/fly-rest-01.png"),
    asset:load("fly/fly-rest-02.png"),
}

flyRubAnimation = {
    asset:load("fly/fly-rub-01.png"),
    asset:load("fly/fly-rub-02.png"),
    asset:load("fly/fly-rub-03.png"),
    asset:load("fly/fly-rub-04.png"),
    asset:load("fly/fly-rub-05.png"),
    asset:load("fly/fly-rub-06.png"),
    asset:load("fly/fly-rub-07.png")
}

flyDeathAnimation = {
    asset:load("fly/fly-dead-01.png"),
    asset:load("fly/fly-dead-02.png")
}

flyStarveAnimation = {
    asset:load("fly/fly-starve-01.png")
}

function Fly:new(x, y)
    local instance = setmetatable({}, Fly)

    instance.x = x
    instance.y = y

    instance.width = 64
    instance.height = 64

    instance.angle = 0
    instance.speed = 200 * 3 * 1.6
    instance.rotationSpeed = math.rad(180)

    instance.moving = false

    instance.windowWidth, instance.windowHeight = love.window.getMode()

    instance.frame = 1
    instance.frameTimer = 0
    instance.frameInterval = 0.1

    instance.activeAnimation = instance.moving and flyFlyingAnimation[1] or flyRubAnimation

    -- 260 width x height

    return instance
end

function Fly:update(deltaTime, joystick)
    if not joystick then
        return
    end

    if self.isDead then
        return
    end

    local isButtonPressed = joystick:isDown(1)

    -- toggle fly moving
    self.moving = isButtonPressed

    local flyingDirectionIndex = self:GetClockHour(self.angle)

    self.activeAnimation = self.moving and flyFlyingAnimation[flyingDirectionIndex] or flyRubAnimation

    if isButtonPressed then
        self.frame = 1
        self.frameTimer = 0
    end

    self.frameTimer = self.frameTimer + deltaTime

    if self.frameTimer >= self.frameInterval then
        self.frame = self.frame % #self.activeAnimation + 1
        self.frameTimer = 0
    end

    if self.moving then
        local flyingDirectionIndex = self:GetClockHour(self.angle)

        self.activeAnimation = self.moving and flyFlyingAnimation[flyingDirectionIndex] or flyRubAnimation

        local leftAxis = joystick:getAxis(5) + 1
        local rightAxis = joystick:getAxis(6) + 1

        if leftAxis > 0.1 then
            self.angle = (self.angle - self.rotationSpeed * leftAxis * deltaTime) % (math.pi * 2)
        end

        if rightAxis > 0.1 then
            self.angle = (self.angle + self.rotationSpeed * rightAxis * deltaTime) % (math.pi * 2)
        end

        self.windowWidth, self.windowHeight = love.window.getMode()

        self.x = (self.x + math.cos(self.angle) * self.speed * deltaTime) % self.windowWidth
        self.y = (self.y + math.sin(self.angle) * self.speed * deltaTime) % self.windowHeight
    end
end

function Fly:draw()
    love.graphics.push()

    love.graphics.translate(self.x, self.y)
    -- love.graphics.rotate(self.angle)
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(self.activeAnimation[self.frame], -self.activeAnimation[self.frame]:getWidth() / 2, -self.activeAnimation[self.frame]:getHeight() / 2)

    love.graphics.pop()

    -- debug
    -- self:DrawDebugInfo()
end

function Fly:DrawDebugInfo()
    -- Convert angle to degrees (optional)
    local angleDegrees = math.deg(self.angle)

    -- Get the width of the text to properly position it in the top right corner
    local text = string.format("Fly Angle: %.2f°", angleDegrees)
    
    self:DebugText(text)
end

function Fly:DebugText(text)
    -- Set the font and color (optional)
    love.graphics.setColor(1, 1, 1) -- White color

    -- Get the screen width
    local screenWidth = love.graphics.getWidth()

    local textWidth = love.graphics.getFont():getWidth(text)

    -- Draw the text in the top right corner
    love.graphics.print(text, screenWidth - textWidth - 10, 10)
end

function Fly:GetClockHour(angle)
    -- Convert angle to degrees
    local angleDegrees = math.deg(angle)

    -- Normalize the angle to the range [0, 360)
    angleDegrees = (angleDegrees % 360)

    -- Map degrees to clock hours
    local clockHour = math.floor(((angleDegrees + 15) % 360) / 30) + 3

    -- Adjust to fit into the 12-hour format (1-12)
    if clockHour > 12 then
        clockHour = clockHour - 12
    elseif clockHour <= 0 then
        clockHour = clockHour + 12
    end

    return clockHour
end

function Fly:triggerDeath()
    self.isDead = true
    self.activeAnimation = flyDeathAnimation
    self.frame = 1
    self.frameTimer = 0
end

function Fly:triggerStarve()
    self.isDead = true
    self.activeAnimation = flyStarveAnimation
    self.frame = 1
    self.frameTimer = 0
end

function Fly:isCollidingWith(food)
    -- Simple AABB (Axis-Aligned Bounding Box) collision detection
    return self.x < food.x + food.width and
           self.x + self.width > food.x and
           self.y < food.y + food.height and
           self.y + self.height > food.y
end

return Fly