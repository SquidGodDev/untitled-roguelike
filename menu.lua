import "knight"
import "ranger"
import "priest"
import "defender"
import "rogue"
import "wizard"

local pd <const> = playdate
local gfx <const> = pd.graphics

local spriteList = {}
local menuX = 200
local menuY = 170
local menuPadding = 64
local currentClassIndex = 1
local lastClassIndex = 1
local classList = {}
local menuAnimator = nil
local animating = false
local textSprite = nil

local UISelectSound = pd.sound.sample.new("sound/UISelect")
local UIErrorSound = pd.sound.sample.new("sound/UIError")

function displayMenu()
    spriteList = {}
    currentClassIndex = 1
    lastClassIndex = 1
    classList = getClassList()
    animating = false
    for i=1,#classList do
        local classImage = gfx.image.new("images/"..classList[i])
        local curClassSprite = gfx.sprite.new(classImage)
        curClassSprite:moveTo(menuX + (i-1)*menuPadding, menuY)
        curClassSprite:add()
        table.insert(spriteList, curClassSprite)
    end
    textSprite = gfx.sprite.new(100, 20)
    textSprite:setZIndex(20)
    textSprite:moveTo(menuX, menuY + 40)
    textSprite:add()
end

function menuUpdate()
    local textImage = gfx.image.new(100, 20)
    gfx.pushContext(textImage)
        gfx.drawTextAligned(getCurClass(), 50, 0, kTextAlignment.center)
    gfx.popContext()
    textSprite:setImage(textImage)

    if not animating then
        if pd.buttonJustPressed(playdate.kButtonLeft) then
            if currentClassIndex <= 1 then
                UIErrorSound:play()
            else
                currentClassIndex -= 1
                UISelectSound:play()
                moveMenu(1)
            end
        elseif pd.buttonJustPressed(playdate.kButtonRight) then
            if currentClassIndex >= #classList then
                UIErrorSound:play()
            else
                currentClassIndex += 1
                UISelectSound:play()
                moveMenu(-1)
            end
        end
    else
        local offset = menuAnimator:currentValue()
        for i=1,#spriteList do
            local curClassSprite = spriteList[i]
            curClassSprite:moveTo(menuX + (i-1)*menuPadding - ((lastClassIndex-1) * menuPadding) + offset, menuY)
        end
        if menuAnimator:ended() then
            lastClassIndex = currentClassIndex
            animating = false
        end
    end
end

function moveMenu(direction)
    animating = true
    menuAnimator = gfx.animator.new(400, 0, direction * menuPadding, pd.easingFunctions.inOutQuad)
end

function getClassList()
    return {'knight', 'ranger', 'priest', 'defender', 'rogue', 'wizard'}
end

function getCurClass()
    return classList[currentClassIndex]
end

function getClassConstructor()
    local class = getCurClass()
    if class == 'knight' then
        return Knight
    elseif class == 'ranger' then
        return Ranger
    elseif class == 'priest' then
        return Priest
    elseif class == 'defender' then
        return Defender
    elseif class == 'rogue' then
        return Rogue
    elseif class == 'wizard' then
        return Wizard
    end
end