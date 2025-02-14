local Fly = {}
Fly.__index = Fly

local FlyState = require "FlyState"

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
        local computed = input:steerFly(self, deltaTime)

        self.angle = computed.angle

        self.x = computed.x
        self.y = computed.y
    end
end

function Fly:draw(renderContext)
    renderContext:drawFly(self)
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
