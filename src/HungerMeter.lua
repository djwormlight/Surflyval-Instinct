local HungerMeter = {}
HungerMeter.__index = HungerMeter

function HungerMeter:new()
    local instance = setmetatable({}, HungerMeter)

    instance.value = 100
    instance.maxValue = 100

    instance.dps = 3

    instance.width = 800
    instance.height = 25

    instance.x = (1024 - instance.width) / 2
    instance.y = 15

    instance.starved = false

    return instance
end

function HungerMeter:deathTriggered()
    self.value = 0
    self.starved = false
end

function HungerMeter:starveTriggered()
    self.value = 0
    self.starved = true
end

function HungerMeter:foodBeingEaten(dt)
    self.value = self.value + 10 * dt

    if self.value > self.maxValue then
        self.value = self.maxValue
    end
end

function HungerMeter:update(deltaTime)
    self.value = self.value - self.dps * deltaTime

    if self.value <= 0 then
        self:starveTriggered()
    end
end

function HungerMeter:draw()
    love.graphics.push()

    -- Draw the background of the hunger meter
    love.graphics.setColor(0.7, 0.11, 0.14)  -- Red color for the background
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Draw the filled portion representing the current hunger value
    local fillWidth = (self.value / self.maxValue) * self.width
    love.graphics.setColor(0.7, 0.9, 0.11)  -- Green color for the filled portion
    love.graphics.rectangle("fill", self.x, self.y, fillWidth, self.height)

    -- Optionally, draw the outline of the hunger meter
    love.graphics.setColor(0, 0, 0)  -- White color for the outline
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    love.graphics.setColor(1,1,1)

    love.graphics.pop()
end

return HungerMeter