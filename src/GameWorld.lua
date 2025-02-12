local asset = require "asset"

local HungerMeter = require "HungerMeter"
local Hand = require "Hand"
local Fly = require "Fly"
local Food = require "Food"

local GameWorld = {}
GameWorld.__index = GameWorld

function GameWorld:new()
    local instance = setmetatable({}, GameWorld)

    instance.background = asset:load("levels/background-01.png")

    instance.titleBackground = asset:load("screens/title.png")
    instance.retryBackground = asset:load("screens/gameover.png")

    local joysticks = love.joystick.getJoysticks()

    joystick = joysticks[1]

    -- instance.fly = Fly:new(400, 300)

    -- instance.hand = Hand:new()

    -- instance.foods = {}

    -- table.insert(instance.foods, Food:new('pizza', math.random(200,700), math.random(200, 500)))
    -- table.insert(instance.foods, Food:new('burger', math.random(200,700), math.random(200, 500)))
    -- table.insert(instance.foods, Food:new('sushi', math.random(200,700), math.random(200, 500)))

    -- instance.hungerMeter = HungerMeter:new()

    instance.state = "startScreen"

    return instance
end

function GameWorld:update(deltaTime)
    if self.state == "playing" then
        if self.fly.isDead then
            self.state = "retryScreen"
            return
        end

        if self.hungerMeter.starved then
            self.fly:triggerStarve()
            return
        end

        for i, v in ipairs(self.foods) do
            v:update(deltaTime)

            if not self.fly.isDead and self.fly:isCollidingWith(v) and not self.fly.moving then
                self.hungerMeter:foodBeingEaten(deltaTime)
            end
        end

        self.fly:update(deltaTime, joystick)
        self.hand:update(deltaTime, self.fly, self.hungerMeter)

        self.hungerMeter:update(deltaTime)
    elseif self.state == "retryScreen" then
        if joystick:isDown(8) then
            self:reset()
        end
    elseif self.state == "startScreen" then
        if joystick:isDown(8) then
            self:reset()
        end
    end
end

function GameWorld:draw()
    if self.state == "playing" then
        love.graphics.draw(self.background, 0, 0)

        for i, v in ipairs(self.foods) do
            v:draw()
        end

        self.fly:draw()
        self.hand:draw()

        self.hungerMeter:draw()
    elseif self.state == "retryScreen" then
        love.graphics.draw(self.background, 0, 0)

        for i, v in ipairs(self.foods) do
            v:draw()
        end

        self.fly:draw()
        self.hand:draw()

        -- Draw the retry screen overlay
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Game Over! Press 'Start' to Retry", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    elseif self.state == "startScreen" then
        love.graphics.draw(self.titleBackground, 0, 0)

        -- -- Draw the retry screen overlay
        -- love.graphics.setColor(0, 0, 0, 0.7)
        -- love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        -- love.graphics.setColor(1, 1, 1)
        -- love.graphics.printf("Press Enter to Start", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end
end

function GameWorld:reset()
    self.fly = Fly:new(400, 300)
    self.hand = Hand:new()

    self.foods = {}

    local foodTypes = {"burger", "corn", "energy", "orange", "pancakes", "pizza", "shrimp", "sushi"}

    table.insert(self.foods, Food:new(foodTypes[math.random(#foodTypes)], math.random(100, 700), math.random(100, 500)))
    table.insert(self.foods, Food:new(foodTypes[math.random(#foodTypes)], math.random(100, 700), math.random(100, 500)))
    table.insert(self.foods, Food:new(foodTypes[math.random(#foodTypes)], math.random(100, 700), math.random(100, 500)))

    self.hungerMeter = HungerMeter:new()

    self.state = "playing"
end

return GameWorld