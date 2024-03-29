local pd <const> = playdate
local gfx <const> = pd.graphics

class('Priest').extends(Player)

function Priest:init()
    self.maxHealth = 6
    self.abilityImage = gfx.image.new("images/abilities/priestAbility")
    self.abilityCooldown = 9
    self.priestImage = gfx.image.new("images/priest")
    self.priestImageInverted = gfx.image.new("images/priestInverted")
    self.healSound = pd.sound.sample.new("sound/heal")
    Priest.super.init(self, "images/priest")
end

function Priest:useAbility()
    local usedAbility = Priest.super.useAbility(self)
    if usedAbility then
        self.healSound:play()
        self:heal(2)
        self.invincibility = 2
        self:setImage(self.priestImageInverted)
    end
end

function Priest:moveEntityBy(gridX, gridY)
    Priest.super.moveEntityBy(self, gridX, gridY)
    if self.invincibility <= 1 then
        self:setImage(self.priestImage)
    else
        self:setImage(self.priestImageInverted)
    end
end