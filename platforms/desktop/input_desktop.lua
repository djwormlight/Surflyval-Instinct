local InputDesktop = {}
InputDesktop.__index = InputDesktop

function InputDesktop:new()
    local instance = setmetatable({}, InputDesktop)

    local joysticks = love.joystick.getJoysticks()

    instance.joystick = joysticks[1]

    return instance
end

function InputDesktop:continuePressed()
    return self.joystick:isDown(8)
end

function InputDesktop:moveFly()
    return self.joystick:isDown(1)
end

function InputDesktop:leftDirectionAxis()
    return self.joystick:getAxis(5)
end

function InputDesktop:rightDirectionAxis()
    return self.joystick:getAxis(6)
end

function InputDesktop:steerFly(fly, deltaTime)
    local computed = {
        x = fly.x,
        y = fly.y,
        angle = fly.angle
    }

    local leftAxis = self:leftDirectionAxis() + 1
    local rightAxis = self:rightDirectionAxis() + 1

    if leftAxis > 0.1 then
        computed.angle = (computed.angle - fly.rotationSpeed * leftAxis * deltaTime) % (math.pi * 2)
    end

    if rightAxis > 0.1 then
        computed.angle = (computed.angle + fly.rotationSpeed * rightAxis * deltaTime) % (math.pi * 2)
    end

    self.windowWidth, self.windowHeight = love.window.getMode()

    computed.x = (computed.x + math.cos(computed.angle) * fly.speed * deltaTime) % self.windowWidth
    computed.y = (computed.y + math.sin(computed.angle) * fly.speed * deltaTime) % self.windowHeight

    return computed
end

return InputDesktop