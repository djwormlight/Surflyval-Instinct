local Food = {}
Food.__index = Food

function Food:new(foodType, x, y, width, height)
    local instance = setmetatable({}, Food)

    instance.type = foodType

    instance.x = x
    instance.y = y

    instance.width = width
    instance.height = height

    return instance
end

function Food:update()

end

function Food:draw(renderContext)
    renderContext:drawFood(self)
end

return Food