local asset = require "asset"

local Food = {}
Food.__index = Food

burgerAnimation = {
    burger = {
        asset:load("food/burger-01.png")
    },
    corn = {
        asset:load("food/corn-01.png")
    },
    energy = {
        asset:load("food/energy-drink-01.png")
    },
    orange = {
        asset:load("food/orangesoda-01.png")
    },
    pancakes = {
        asset:load("food/pancakes-01.png")
    },
    pizza = {
        asset:load("food/pizza01.png")
    },
    shrimp = {
        asset:load("food/shrimpcocktail-01.png")
    },
    sushi = {
        asset:load("food/sushi-01.png")
    }
}

function Food:new(foodType, x, y)
    local instance = setmetatable({}, Food)

    instance.type = foodType

    instance.x = x
    instance.y = y

    instance.frame = 1

    instance.activeAnimation = burgerAnimation[foodType]

    instance.width = instance.activeAnimation[instance.frame]:getWidth()
    instance.height = instance.activeAnimation[instance.frame]:getHeight()

    return instance
end

function Food:update()

end

function Food:draw()
    love.graphics.push()

    love.graphics.translate(self.x, self.y)

    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(self.activeAnimation[self.frame], -self.activeAnimation[self.frame]:getWidth() / 2, -self.activeAnimation[self.frame]:getHeight() / 2)

    -- Set the color for the hitbox (e.g., red)
    love.graphics.setColor(1, 0, 0, 0.5)  -- Red with 50% transparency

    -- Draw the hitbox rectangle
    love.graphics.rectangle(
        "line",  -- Draw only the outline of the rectangle
        -self.width / 2,  -- Top-left corner X (relative to the origin)
        -self.height / 2, -- Top-left corner Y (relative to the origin)
        self.width,  -- Width of the rectangle
        self.height  -- Height of the rectangle
    )

    love.graphics.setColor(1, 1, 1)

    love.graphics.pop()
end

return Food