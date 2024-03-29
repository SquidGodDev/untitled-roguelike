local pd <const> = playdate
local gfx <const> = pd.graphics

class('Knight').extends(Player)

function Knight:init()
    self.maxHealth = 8
    self.abilityImage = gfx.image.new("images/abilities/knightAbility")
    self.abilityCooldown = 8
    local swordImage = gfx.image.new("images/abilities/sword")
    self.swordSprite = gfx.sprite.new(swordImage)
    self.swordSprite:setZIndex(50)
    self.swordSound = pd.sound.sample.new("sound/swordSwing")
    Knight.super.init(self, "images/knight")
end

function Knight:useAbility()
    local usedAbility = Knight.super.useAbility(self)
    if usedAbility then
        self.swordSound:play()
        for i=-1,1 do
            for j=-1,1 do
                local entityInstance = self.map:getEntity(self.gridX + i, self.gridY + j)
                if entityInstance and entityInstance:isa(Enemy) then
                    entityInstance:damage(1)
                end
            end
        end
        self.swordSprite:add()
        local swingPosX, swingPosY = self:getTruePosition()
        swingPosX += 16
        swingPosY += 16
        self.swordSprite:moveTo(swingPosX, swingPosY)
        self.swordAnimator = gfx.animator.new(600, 0, 360, pd.easingFunctions.inOutExpo)
        self.gameManager:checkWin()
    end
end

function Knight:update()
    Knight.super.update(self)
    if self.swordAnimator then
        local animatorValue = self.swordAnimator:currentValue()
        self.swordSprite:setRotation(animatorValue)
        if self.swordAnimator:ended() then
            self.swordAnimator = nil
            self.swordSprite:remove()
        end
    end
end