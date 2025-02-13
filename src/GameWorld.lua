local asset = require "asset"

local HungerMeter = require "HungerMeter"
local Hand = require "Hand"
local Fly = require "Fly"
local Food = require "Food"

local GameWorld = {}
GameWorld.__index = GameWorld

function GameWorld:new(input)
    local instance = setmetatable({}, GameWorld)

    instance.background = asset:load("levels/background-01.png")

    instance.titleBackground = asset:load("screens/title.png")
    instance.retryBackground = asset:load("screens/gameover.png")

    instance.input = input

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
        if self.fly:isDead() then
            self.state = "retryScreen"
            return
        end

        if self.hungerMeter.starved then
            self.fly:triggerStarve()
            return
        end

        for index, food in ipairs(self.foods) do
            food:update(deltaTime)

            if self.fly:isResting() and self.fly:isCollidingWith(food) then
                self.hungerMeter:foodBeingEaten(deltaTime)
            end
        end

        self.fly:update(deltaTime, self.input)
        self.hand:update(deltaTime, self.fly, self.hungerMeter)

        self.hungerMeter:update(deltaTime)
    elseif self.state == "retryScreen" then
        if self.input:continuePressed() then
            self:reset()
        end
    elseif self.state == "startScreen" then
        if self.input:continuePressed() then
            self:reset()
        end
    end
end

function GameWorld:draw(renderContext)
    if self.state == "playing" then
        renderContext:drawPlayingScreen(self)
    elseif self.state == "retryScreen" then
        renderContext:drawRetryScreen(self)
    elseif self.state == "startScreen" then
        renderContext:drawStartScreen(self)
    end
end

function GameWorld:reset()
    self.fly = Fly:new(400, 300)
    self.hand = Hand:new()

    self.foods = {}

    local foodTypes = {"burger", "corn", "energydrink", "orange", "pancakes", "pizza", "shrimpcocktail", "sushi"}

    for i = 1, 3 do
        local foodType = foodTypes[math.random(#foodTypes)]

        local imageData = love.image.newImageData("assets/food/" .. foodType .. "-01.png")

        local foodSize = { imageData:getWidth(), imageData:getHeight() }

        table.insert(self.foods, Food:new(foodType, math.random(100, 700), math.random(100, 500), foodSize[1], foodSize[2]))
    end

    self.hungerMeter = HungerMeter:new()

    self.state = "playing"
end

return GameWorld