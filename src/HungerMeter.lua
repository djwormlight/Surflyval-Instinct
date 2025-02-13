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

function HungerMeter:draw(render_context)
    render_context:drawHungerMeter(self)
end

return HungerMeter