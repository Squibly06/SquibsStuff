---@diagnostic disable: undefined-global

-- EDITABLE SETTINGS
local songTitle = ''
local subtitle = 'Credits'

local credits = {
    'Music: idk',
    'Charting: idk',
    'Art: echoplasum',
    'Coding: squibly',
}

-- TIMING (seconds)
local fadeIn = 0.6
local holdTime = 4.5
local fadeOut = 0.8

-- APPEARANCE
local cardWidth = 700
local cardHeight = 330
local accentColor = '70E0D0'
local panelColor = '171923'
local textColor = 'FFFFFF'

-- INTERNAL SETTINGS
local x = (screenWidth - cardWidth) / 2
local y = (screenHeight - cardHeight) / 2

local objects = {
    'creditsDim',
    'creditsPanel',
    'creditsAccent',
    'creditsTitle',
    'creditsSubtitle',
    'creditsNames'
}


local function createBox(tag, xPos, yPos, width, height, color)
    makeLuaSprite(tag, '', xPos, yPos)
    makeGraphic(tag, width, height, color)
    setObjectCamera(tag, 'camHUD')
    setProperty(tag .. '.alpha', 0)
    addLuaSprite(tag, true)
end

local function createText(tag, text, size, xPos, yPos, color)
    makeLuaText(tag, text, cardWidth - 40, xPos, yPos)
    setTextSize(tag, size)
    setTextAlignment(tag, 'center')
    setTextColor(tag, color)
    setTextBorder(tag, 0, '000000')
    setObjectCamera(tag, 'camHUD')
    setProperty(tag .. '.alpha', 0)
    addLuaText(tag)
end

local function fadeObjects(alpha, duration, suffix)
    for _, tag in ipairs(objects) do
        doTweenAlpha(tag .. suffix, tag, alpha, duration, 'linear')
    end
end


function onCreate()
    -- Background overlay
    createBox('creditsDim', 0, 0, screenWidth, screenHeight, '000000')

    -- Card and accent stripe
    createBox('creditsPanel', x, y, cardWidth, cardHeight, panelColor)
    createBox('creditsAccent', x, y, cardWidth, 7, accentColor)

    -- Heading and subtitle
    createText('creditsTitle', songTitle, 38, x + 20, y + 35, textColor)
    createText('creditsSubtitle', subtitle, 22, x + 20, y + 88, accentColor)

    -- Join credit lines into one text object
    createText(
        'creditsNames',
        table.concat(credits, '\n'),
        20,
        x + 20,
        y + 135,
        textColor
    )
end

function onSongStart()
    -- Slightly darken the gameplay behind the card
    doTweenAlpha('creditsDimIn', 'creditsDim', 0.55, fadeIn, 'linear')

    -- Fade in the card and its contents
    for _, tag in ipairs(objects) do
        if tag ~= 'creditsDim' then
            doTweenAlpha(tag .. 'In', tag, 1, fadeIn, 'quadOut')
        end
    end
end

-- Start hold timer after the card finishes fading in
function onTweenCompleted(tag)
    if tag == 'creditsPanelIn' then
        runTimer('creditsHold', holdTime)
    end

    -- Remove objects after the fade-out finishes
    if tag == 'creditsPanelOut' then
        removeLuaSprite('creditsDim', true)
        removeLuaSprite('creditsPanel', true)
        removeLuaSprite('creditsAccent', true)

        removeLuaText('creditsTitle', true)
        removeLuaText('creditsSubtitle', true)
        removeLuaText('creditsNames', true)
    end
end

-- Hide

function onTimerCompleted(tag)
    if tag == 'creditsHold' then
        fadeObjects(0, fadeOut, 'Out')
    end
end
