local Asset = {}
Asset.__index = Asset

function Asset:new()
    local instance = setmetatable({}, Asset)

    return instance
end

function Asset:load(imagePath)
    return self:replaceTransparencyColor("assets/" .. imagePath, 255, 0, 255)
end

function Asset:replaceTransparencyColor(imagePath, r, g, b)
    -- Load the image as ImageData
    local imageData = love.image.newImageData(imagePath)
    
    -- -- Define the transparency color (FF00FF)
    -- local transR, transG, transB = r / 255, g / 255, b / 255
    
    -- -- Map over each pixel and replace the transparency color with transparent pixels
    -- imageData:mapPixel(function(x, y, r, g, b, a)
    --     if r == transR and g == transG and b == transB then
    --         return r, g, b, 0 -- Set alpha to 0 for transparency
    --     else
    --         return r, g, b, a -- Keep the original pixel
    --     end
    -- end)
    
    -- Create an Image from the modified ImageData
    return love.graphics.newImage(imageData)
end

return Asset