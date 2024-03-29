import "entity"
import "heartDisplay"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(Entity)

function Player:init(imagePath)
    Player.super.init(self, imagePath)
    self.attack = 1
    self.gridX = 1
    self.gridY = 1
    self:moveTo(self:getTruePosition())
    self.takeInput = true
    self.gameManager = nil
    self.health = self.maxHealth
    self.heartDisplay = HeartDisplay(self.maxHealth)
    self.abilityCounter = 0
    self.abilitySprite = gfx.sprite.new(self.abilityImage)
    self.abilitySprite:setZIndex(20)
    self.abilitySprite:moveTo(370, 16)
    self.abilitySprite:add()
    self.invincibility = 0
    self.moveSound = pd.sound.sample.new("sound/whoosh")
    self.hurtSound = pd.sound.sample.new("sound/hurt")
end

function Player:update()
    Player.super.update(self)

    if self.takeInput then
        if pd.buttonJustPressed(playdate.kButtonA) then
            self:useAbility()
        end
        if pd.buttonJustPressed(playdate.kButtonUp) then
            self:moveEntityBy(0, -1)
        elseif pd.buttonJustPressed(playdate.kButtonDown) then
            self:moveEntityBy(0, 1)
        elseif pd.buttonJustPressed(playdate.kButtonLeft) then
            self.flipped = true
            self:moveEntityBy(-1, 0)
        elseif pd.buttonJustPressed(playdate.kButtonRight) then
            self.flipped = false
            self:moveEntityBy(1, 0)
        end
    end
end

function Player:useAbility()
    if self.abilityCounter == 0 then
        self.abilityCounter = self.abilityCooldown
        self:updateAbilityDisplay()
        return true
    else
        return false
    end
end

function Player:updateAbilityDisplay()
    if self.abilityCounter == 0 then
        self.abilitySprite:setImage(self.abilityImage)
        self.abilitySprite:moveTo(370, 16)
    else
        local abilityCountImage = gfx.image.new(30, 14)
        gfx.pushContext(abilityCountImage)
            monochromeRPGNumbers:drawTextAligned(self.abilityCounter, 15, 0, kTextAlignment.center)
        gfx.popContext()
        self.abilitySprite:setImage(abilityCountImage)
        self.abilitySprite:moveTo(369, 16)
    end
end

function Player:damage(amount)
    if self.invincibility <= 0 then
        self.hurtSound:play()
        Player.super.damage(self, amount)
        self.heartDisplay:updateHealth(self.health)
    end
end

function Player:heal(amount)
    self.health += amount
    if self.health > self.maxHealth then
        self.health = self.maxHealth
    end
    self.heartDisplay:updateHealth(self.health)
end

function Player:setGameManager(gameManager)
    self.gameManager = gameManager
end

function Player:moveEntityBy(gridX, gridY)
    if self:checkOutOfBounds(gridX, gridY) then
        return
    end
    if self.invincibility > 0 then
        self.invincibility -= 1
    end

    self.takeInput = false
    if self.abilityCounter >= 1 then
        self.abilityCounter -= 1
        self:updateAbilityDisplay()
    end
    local moved = Player.super.moveEntityBy(self, gridX, gridY)
    if moved then
        self.moveSound:play()
    end
    self.gameManager:gameStep()
end

function Player:setMap(map)
    local emptyX, emptyY = map:getEmptySpace()
    self.gridX = emptyX
    self.gridY = emptyY
    Player.super.setMap(self, map)
    self:moveTo(self:getTruePosition())
end