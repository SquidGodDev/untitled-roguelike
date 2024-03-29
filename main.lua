import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animator"

import "player"
import "gameManager"
import "map"
import "menu"

local pd <const> = playdate
local gfx <const> = pd.graphics

monochromeRPGNumbers = gfx.font.new("fonts/MonochromeRPGNumbers")

local transitioning = false
local sceneAnimator = nil
local nextScene = nil
local transitionSprite = nil
local transitionImage = nil

local curScene = "menu"

local curLevel = 1

local gameManger = nil

local shakeAmount = 0

local levelWinSound = pd.sound.sample.new("sound/levelWin")
local gameStartSound = pd.sound.sample.new("sound/gameStart")
local gameWinSound = pd.sound.sample.new("sound/gameWin")
local gameLoseSound = pd.sound.sample.new("sound/gameLose")

function screenShake(amount)
    if shakeAmount < amount then
        shakeAmount = amount
    end
end

local function gameScene()
    curScene = "game"
    playerConstructor = getClassConstructor()

    local player = playerConstructor()
    player:add()

    gameManager = GameManager(player, curLevel)

    local backgroundImage = gfx.image.new("images/background")
    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            gfx.setClipRect(x, y, width, height)
            backgroundImage:draw(0, 0)
            gfx.clearClipRect()
        end
    )
end

local function menuScene()
    curScene = "menu"
    displayMenu()
    local backgroundImage = gfx.image.new("images/mainMenu")
    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            gfx.setClipRect(x, y, width, height)
            backgroundImage:draw(0, 0)
            gfx.clearClipRect()
        end
    )
end

local function winScreen()
    curScene = "win"
    curLevel = 1
    local backgroundImage = gfx.image.new("images/winScreen")
    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            gfx.setClipRect(x, y, width, height)
            backgroundImage:draw(0, 0)
            gfx.clearClipRect()
        end
    )
end

local function loseScreen()
    curScene = "lose"
    curLevel = 1
    local backgroundImage = gfx.image.new("images/loseScreen")
    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
            gfx.setClipRect(x, y, width, height)
            backgroundImage:draw(0, 0)
            gfx.clearClipRect()
        end
    )
end

local scene = menuScene
scene()

function changeScene(newScene)
    -- shakeAmount = 0
    -- pd.display.setOffset(0, 0)
    sceneAnimator = gfx.animator.new(700, 0, 400, pd.easingFunctions.outCubic)
    transitioning = true
    transitionSprite = gfx.sprite.new()
    transitionSprite:setCenter(0, 0)
    transitionSprite:setZIndex(200)
    transitionSprite:add()
    transitionImage = gfx.image.new(400, 240)
    nextScene = newScene
end

function playdate.update()
    if shakeAmount > 0 then
        local shakeAngle = math.random()*math.pi*2;
        shakeX = math.floor(math.cos(shakeAngle)*shakeAmount);
        shakeY = math.floor(math.sin(shakeAngle)*shakeAmount);
        shakeAmount -= 1
        pd.display.setOffset(shakeX, shakeY)
    else
        pd.display.setOffset(0, 0)
    end
    if transitioning then
        if sceneAnimator then
            gfx.pushContext(transitionImage)
            gfx.fillRect(0, 0, sceneAnimator:currentValue(), 240)
            gfx.popContext(transitionImage)
            transitionSprite:setImage(transitionImage)
        end
        if sceneAnimator:ended() then
            gfx.sprite.removeAll()
            transitionSprite:add()
            transitioning = false
            sceneAnimator = gfx.animator.new(700, 400, 0, pd.easingFunctions.inCubic)
            nextScene()
        end
    else
        if sceneAnimator then
            transitionImage:clear(gfx.kColorClear)
            gfx.pushContext(transitionImage)
            gfx.fillRect(0, 0, sceneAnimator:currentValue(), 240)
            gfx.popContext(transitionImage)
            transitionSprite:setImage(transitionImage)
            if sceneAnimator:ended() then
                transitionSprite:remove()
            end
        end
        if curScene == "game" then
            if gameManager then
                if gameManager.won then
                    if curLevel >= 20 then
                        gameWinSound:play()
                        changeScene(winScreen)
                    else
                        curLevel += 1
                        levelWinSound:play()
                        changeScene(gameScene)
                    end
                elseif gameManager.player.health <= 0 then
                    gameLoseSound:play()
                    changeScene(loseScreen)
                end
            end
        elseif curScene == "menu" then
            if pd.buttonJustPressed(pd.kButtonA) then
                gameStartSound:play()
                changeScene(gameScene)
            end
        elseif curScene == "lose" or curScene == "win" then
            if pd.buttonJustPressed(pd.kButtonA) then
                changeScene(menuScene)
            end
        end
    end
    if curScene == "menu" then
        menuUpdate()
    end

    gfx.sprite.update()
    pd.timer.updateTimers()
end