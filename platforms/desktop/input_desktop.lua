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

return InputDesktop