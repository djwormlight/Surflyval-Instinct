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

function Food:draw(renderContext)
    renderContext:drawFood(self)
end

return Food