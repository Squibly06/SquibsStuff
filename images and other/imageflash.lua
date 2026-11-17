---@diagnostic disable: undefined-global
local triggerStep = 200
local imageName = ""
local displayTime = 0.5

local triggered = false

function onCreate()
    precacheImage(imageName)
end

function onStepHit()
    if not triggered and curStep >= triggerStep then
        triggered = true
        showImage()
    end
end

function showImage()
    local tag = "flashImage"

    makeLuaSprite(tag, imageName, 0, 0)
    setObjectCamera(tag, "other")
    screenCenter(tag, "xy")

    addLuaSprite(tag, true)

    runTimer("fadeImage", displayTime)
end

function onTimerCompleted(tag)
    if tag == "fadeImage" then
        doTweenAlpha("fadeTween", "flashImage", 0, 0.2, "linear")
        runTimer("removeImage", 0.25)
    end

    if tag == "removeImage" then
        removeLuaSprite("flashImage", true)

    end
end


