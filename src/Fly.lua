

local Fly = {}
Fly.__index = Fly

local wasButtonPressed = false

local FlyState = {
    FLYING = "flying",
    RESTING = "resting",
    DEAD = "dead",
    STARVED = "starved"
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

    instance.windowWidth, instance.windowHeight = love.window.getMode()

    instance.state = FlyState.FLYING

    -- 260 width x height

    return instance
end

function Fly:update(deltaTime, input)
    if not input then
        return
    end

    if self.state == FlyState.DEAD then
        return
    end

    if self.state == FlyState.STARVED then
        return
    end

    local isButtonPressed = input:moveFly()

    self.state = isButtonPressed and FlyState.FLYING or FlyState.RESTING

    if self.state == FlyState.FLYING then
        local leftAxis = input:leftDirectionAxis() + 1
        local rightAxis = input:rightDirectionAxis() + 1

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

function Fly:draw(renderContext)
    renderContext:drawFly(self)
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
    self.state = FlyState.DEAD
end

function Fly:triggerStarve()
    self.state = FlyState.STARVED
end

function Fly:isDead()
    return self.state == FlyState.DEAD
end

function Fly:isResting()
    return self.state == FlyState.RESTING
end

function Fly:isCollidingWith(food)
    -- Simple AABB (Axis-Aligned Bounding Box) collision detection
    return self.x < food.x + food.width and
           self.x + self.width > food.x and
           self.y < food.y + food.height and
           self.y + self.height > food.y
end

return Fly