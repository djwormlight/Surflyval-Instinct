local Animation = {}
Animation.__index = Animation

local FrameAction = require "FrameAction"

function Animation:new(frames, frameInterval)
    local instance = setmetatable({}, self)

    instance.frames = frames
    instance.frameInterval = frameInterval or 0.1
    instance.frameTimer = 0
    instance.currentFrame = 1

    instance.finished = false

    return instance
end

function Animation:update(deltaTime)
    if self.finished or #self.frames == 1 then
        return
    end

    self.frameTimer = self.frameTimer + deltaTime

    if self.frameTimer >= self.frameInterval then
        self.frameTimer = 0

        self:advanceFrame()
    end
end

function Animation:advanceFrame()
    local totalFrames = #self.frames
    local nextFrame = self.currentFrame + 1

    while nextFrame <= totalFrames do
        local frame = self.frames[nextFrame]

        if frame == FrameAction.SKIP then
            nextFrame = nextFrame + 1
        elseif frame == FrameAction.STOP then
            self.finished = true
            return
        elseif frame == "HOLD" then
            return
        else
            self.currentFrame = nextFrame
            return
        end
    end

    self.currentFrame = 1
end

function Animation:getCurrentFrame()
    return self.frames[self.currentFrame] or nil
end

function Animation:changeFrames(newFrames)
    self.frames = newFrames
    self.frameTimer = 0
    self.currentFrame = 1

    self.finished = false
end

function Animation:isFinished()
    return self.finished
end

return Animation