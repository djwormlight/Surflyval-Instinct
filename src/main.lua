if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local GameWorld = require "GameWorld"

function love.load(arg)
    love.window.setMode(1024, 768, { resizable = true, vsync = 0, minwidth = 400, minheight = 300 })
    love.graphics.setBackgroundColor(1, 1, 1)

    gameWorld = GameWorld:new()
end

function love.update(deltaTime)
    gameWorld:update(deltaTime)
end

function love.draw()
    gameWorld:draw()
end

function love.keypressed(a, b)
    if a == 'q' or a == 'escape' then
        love.event.quit()
    end
end

function resize(width, height)
    love.window.setMode(width, height)
end

function love.quit()

end
