local PlatformDesktop = {}
PlatformDesktop.__index = PlatformDesktop

function PlatformDesktop:new()
    local instance = setmetatable({}, PlatformDesktop)

    return instance
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