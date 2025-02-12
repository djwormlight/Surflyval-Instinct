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