local asset = require "asset"

local Hand = {}
Hand.__index = Hand

handAnimation = {
    asset:load("swatter/hand-01.png"),
    asset:load("swatter/hand-02.png"),
}

function Hand:new()
    local instance = setmetatable({}, Hand)

    instance.x = 0
    instance.y = 0

    instance.width = 192
    instance.height = 192

    instance.speed = 200

    instance.frame = 1
    instance.frameTimer = 0

    instance.activeAnimation = handAnimation

    instance.isSwatting = false
    instance.swatDuration = 0.2

    instance.handCompleted = false

    return instance
end

function Hand:update(deltaTime, fly, hungermeter)
    if self.handCompleted then
        return
    end

    if self.isSwatting then
        self.frame = 2

        self.swatTimer = self.swatTimer + deltaTime

        if self.swatTimer >= self.swatDuration then
            self.isSwatting = false

            self.frame = 1

            if self:isColliding(fly) then
                fly:triggerDeath()
                hungermeter:deathTriggered()

                self.handCompleted = true
            end
        end
    else
        -- Move the hand towards the fly's position
        if fly.x > self.x then
            self.x = self.x + self.speed * deltaTime
        elseif fly.x < self.x then
            self.x = self.x - self.speed * deltaTime
        end

        if fly.y > self.y then
            self.y = self.y + self.speed * deltaTime
        elseif fly.y < self.y then
            self.y = self.y - self.speed * deltaTime
        end

        if self:isReadyToSwat(fly) then
            self.isSwatting = true
            self.swatTimer = 0 -- reset the timer for swatting
        end
    end
end

function Hand:draw(renderContext)
    renderContext:drawHand(self)
end

function Hand:isColliding(fly)
    -- Simple AABB (Axis-Aligned Bounding Box) collision detection
    return self.x < fly.x + fly.width and
           self.x + self.width > fly.x and
           self.y < fly.y + fly.height and
           self.y + self.height > fly.y
end

function Hand:isReadyToSwat(fly)
    -- Check if the hand's bounding box is close enough to the fly's bounding box
    local horizontalOverlap = self.x < fly.x + fly.width and self.x + self.width > fly.x
    local verticalOverlap = self.y < fly.y + fly.height and self.y + self.height > fly.y
    
    -- Check if the hand is positioned right over the fly, ready to swat
    local closeEnough = math.abs(self.x - fly.x) < 10 and math.abs(self.y - fly.y) < 10
    
    return horizontalOverlap and verticalOverlap and closeEnough
end

return Hand