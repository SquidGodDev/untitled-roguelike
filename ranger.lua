local pd <const> = playdate
local gfx <const> = pd.graphics

class('Ranger').extends(Player)

function Ranger:init()
    self.maxHealth = 6
    self.abilityImage = gfx.image.new("images/abilities/rangerAbility")
    self.abilityCooldown = 12
    local arrowUpImage = gfx.image.new("images/abilities/arrow")
    local arrowRightImage = arrowUpImage:rotatedImage(90)
    local arrowDownImage = arrowUpImage:rotatedImage(180)
    local arrowLeftImage = arrowUpImage:rotatedImage(270)
    self.arrowUp = gfx.sprite.new(arrowUpImage)
    self.arrowRight = gfx.sprite.new(arrowRightImage)
    self.arrowDown = gfx.sprite.new(arrowDownImage)
    self.arrowLeft = gfx.sprite.new(arrowLeftImage)
    self.abilityAnimator = nil
    self.arrowSound = pd.sound.sample.new("sound/arrow")
    Ranger.super.init(self, "images/ranger")
end

function Ranger:useAbility()
    local usedAbility = Ranger.super.useAbility(self)
    if usedAbility then
        self.arrowSound:play()
        for i=1,self.map.maxX do
            local curEntity = self.map:getEntity(i, self.gridY)
            if curEntity and curEntity:isa(Enemy) then
                curEntity:damage(1)
            end
        end
        for j=1,self.map.maxY do
            local curEntity = self.map:getEntity(self.gridX, j)
            if curEntity and curEntity:isa(Enemy) then
                curEntity:damage(1)
            end
        end
        self.abilityAnimator = gfx.animator.new(330, 0, 400, pd.easingFunctions.inSine)
        self.firePosX, self.firePosY = self:getTruePosition()
        self.firePosX += 16
        self.firePosY += 16
        self.arrowUp:remove()
        self.arrowUp:add()
        self.arrowRight:remove()
        self.arrowRight:add()
        self.arrowDown:remove()
        self.arrowDown:add()
        self.arrowLeft:remove()
        self.arrowLeft:add()
        self.gameManager:checkWin()
    end
end

function Ranger:update()
    Ranger.super.update(self)
    if self.abilityAnimator then
        local animatorValue = self.abilityAnimator:currentValue()
        self.arrowUp:moveTo(self.firePosX, self.firePosY - 5 - animatorValue)
        self.arrowDown:moveTo(self.firePosX, self.firePosY + 5 + animatorValue)
        self.arrowLeft:moveTo(self.firePosX - 5 - animatorValue, self.firePosY)
        self.arrowRight:moveTo(self.firePosX + 5 + animatorValue, self.firePosY)
        if self.abilityAnimator:ended() then
            self.abilityAnimator = nil
        end
    end
end