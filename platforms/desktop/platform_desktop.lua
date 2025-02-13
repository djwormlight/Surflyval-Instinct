local PlatformDesktop = {}
PlatformDesktop.__index = PlatformDesktop

local Animation = require "Animation"

local asset = require "asset"

local FlyState = {
    FLYING = "flying",
    RESTING = "resting",
    DEAD = "dead",
    STARVED = "starved"
}

local FrameAction = {
    SKIP = "SKIP",
    STOP = "STOP",
    HOLD = "HOLD"
}

FlyAnimationFrames = {
    [FlyState.FLYING] = {
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
    },
    [FlyState.RESTING] = {
        asset:load("fly/fly-rest-01.png"),
        asset:load("fly/fly-rest-02.png"),
    },
    ["rubbing"] = {
        asset:load("fly/fly-rub-01.png"),
        asset:load("fly/fly-rub-02.png"),
        asset:load("fly/fly-rub-03.png"),
        asset:load("fly/fly-rub-04.png"),
        asset:load("fly/fly-rub-05.png"),
        asset:load("fly/fly-rub-06.png"),
        asset:load("fly/fly-rub-07.png")
    },
    [FlyState.DEAD] = {
        asset:load("fly/fly-dead-01.png"),
        asset:load("fly/fly-dead-02.png"),
        FrameAction.STOP
    },
    [FlyState.STARVED] = {
        asset:load("fly/fly-starve-01.png"),
        FrameAction.STOP
    },
}

local previousState = {}

function PlatformDesktop:new()
    local instance = setmetatable({}, PlatformDesktop)

    instance.animations = {}

    return instance
end

function PlatformDesktop:updateAnimations(deltaTime)
    for _key, animation in pairs(self.animations) do
        animation:update(deltaTime)
    end
end

function PlatformDesktop:drawPlayingScreen(gameWorld)
    love.graphics.draw(gameWorld.background, 0, 0)

    for i, v in ipairs(gameWorld.foods) do
        v:draw(self)
    end

    gameWorld.fly:draw(self)
    gameWorld.hand:draw(self)

    gameWorld.hungerMeter:draw(self)
end

function PlatformDesktop:drawRetryScreen(gameWorld)
    love.graphics.draw(gameWorld.background, 0, 0)

    for i, v in ipairs(gameWorld.foods) do
        v:draw(self)
    end

    gameWorld.fly:draw(self)
    gameWorld.hand:draw(self)

    -- Draw the retry screen overlay
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Game Over! Press 'Start' to Retry", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
end

function PlatformDesktop:drawStartScreen()
    love.graphics.draw(gameWorld.titleBackground, 0, 0)

    -- -- Draw the retry screen overlay
    -- love.graphics.setColor(0, 0, 0, 0.7)
    -- love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- love.graphics.setColor(1, 1, 1)
    -- love.graphics.printf("Press Enter to Start", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
end

function PlatformDesktop:drawFly(fly)
    local objId = tostring(fly)

    self.animations[objId] = self.animations[objId] or Animation:new()

    if previousState[objId] ~= fly.state then
        if fly.state == FlyState.FLYING then
            self.animations[objId]:changeFrames(FlyAnimationFrames[FlyState.FLYING][fly:GetClockHour(fly.angle)])
        else
            self.animations[objId]:changeFrames(FlyAnimationFrames[fly.state])
        end
    end

    love.graphics.push()

    love.graphics.translate(fly.x, fly.y)

    love.graphics.setColor(1, 1, 1)

    local currentFrame = self.animations[objId]:getCurrentFrame()

    love.graphics.draw(currentFrame, -currentFrame:getWidth() / 2, -currentFrame:getHeight() / 2)

    love.graphics.pop()

    previousState[objId] = fly.state
end

function PlatformDesktop:drawFood(food)
    love.graphics.push()

    love.graphics.translate(food.x, food.y)

    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(food.activeAnimation[food.frame], -food.activeAnimation[food.frame]:getWidth() / 2, -food.activeAnimation[food.frame]:getHeight() / 2)

    -- Set the color for the hitbox (e.g., red)
    love.graphics.setColor(1, 0, 0, 0.5)  -- Red with 50% transparency

    -- Draw the hitbox rectangle
    love.graphics.rectangle(
        "line",  -- Draw only the outline of the rectangle
        -food.width / 2,  -- Top-left corner X (relative to the origin)
        -food.height / 2, -- Top-left corner Y (relative to the origin)
        food.width,  -- Width of the rectangle
        food.height  -- Height of the rectangle
    )

    love.graphics.setColor(1, 1, 1)

    love.graphics.pop()
end

function PlatformDesktop:drawHand(hand)
    love.graphics.push()

    love.graphics.translate(hand.x, hand.y)

    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(hand.activeAnimation[hand.frame], -hand.activeAnimation[hand.frame]:getWidth() / 2, -hand.activeAnimation[hand.frame]:getHeight() / 2)

    love.graphics.pop()
end

function PlatformDesktop:drawHungerMeter(hungerMeter)
    love.graphics.push()

    -- Draw the background of the hunger meter
    love.graphics.setColor(0.7, 0.11, 0.14)  -- Red color for the background
    love.graphics.rectangle("fill", hungerMeter.x, hungerMeter.y, hungerMeter.width, hungerMeter.height)

    -- Draw the filled portion representing the current hunger value
    local fillWidth = (hungerMeter.value / hungerMeter.maxValue) * hungerMeter.width
    love.graphics.setColor(0.7, 0.9, 0.11)  -- Green color for the filled portion
    love.graphics.rectangle("fill", hungerMeter.x, hungerMeter.y, fillWidth, hungerMeter.height)

    -- Optionally, draw the outline of the hunger meter
    love.graphics.setColor(0, 0, 0)  -- White color for the outline
    love.graphics.rectangle("line", hungerMeter.x, hungerMeter.y, hungerMeter.width, hungerMeter.height)

    love.graphics.setColor(1,1,1)

    love.graphics.pop()
end

return PlatformDesktop