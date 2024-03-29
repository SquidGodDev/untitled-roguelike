local pd <const> = playdate
local gfx <const> = pd.graphics

class('Rogue').extends(Player)

function Rogue:init()
    self.maxHealth = 6
    self.abilityImage = gfx.image.new("images/abilities/rogueAbility")
    self.abilityCooldown = 12
    self.rogueImage = gfx.image.new("images/rogue")
    self.rogueImageInverted = gfx.image.new("images/rogueInverted")
    self.prepSound = pd.sound.sample.new("sound/preparation")
    Rogue.super.init(self, "images/rogue")
end

function Rogue:useAbility()
    local usedAbility = Rogue.super.useAbility(self)
    if usedAbility then
        self.prepSound:play()
        self.bonusAttack = 10
        self:setImage(self.rogueImageInverted)
    end
end

function Rogue:moveEntityBy(gridX, gridY)
    Rogue.super.moveEntityBy(self, gridX, gridY)
    if self.bonusAttack == 0 then
        self:setImage(self.rogueImage)
    else
        self:setImage(self.rogueImageInverted)
    end
end