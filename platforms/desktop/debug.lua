function Debug:DumpJoystickInfo()
    local joysticks = love.joystick.getJoysticks()

    -- Dump joystick information
    for i, joystick in ipairs(joysticks) do
        print("Joystick #" .. i .. ": " .. joystick:getName())
        print("  Number of Axes: " .. joystick:getAxisCount())
        print("  Number of Buttons: " .. joystick:getButtonCount())
        print("  Number of Hats: " .. joystick:getHatCount())

        -- Print axis positions
        for j = 1, joystick:getAxisCount() do
            print("  Axis " .. j .. " Position: " .. joystick:getAxis(j))
        end

        -- Print button states
        for j = 1, joystick:getButtonCount() do
            print("  Button " .. j .. " Pressed: " .. tostring(joystick:isDown(j)))
        end

        -- Print hat positions
        for j = 1, joystick:getHatCount() do
            print("  Hat " .. j .. " Position: " .. joystick:getHat(j))
        end

        print("----------")
    end
end

-- function Fly:DrawDebugInfo()
--     -- Convert angle to degrees (optional)
--     local angleDegrees = math.deg(self.angle)

--     -- Get the width of the text to properly position it in the top right corner
--     local text = string.format("Fly Angle: %.2f°", angleDegrees)

--     self:DebugText(text)
-- end

-- function Fly:DebugText(text)
--     -- Set the font and color (optional)
--     love.graphics.setColor(1, 1, 1) -- White color

--     -- Get the screen width
--     local screenWidth = love.graphics.getWidth()

--     local textWidth = love.graphics.getFont():getWidth(text)

--     -- Draw the text in the top right corner
--     love.graphics.print(text, screenWidth - textWidth - 10, 10)
-- end