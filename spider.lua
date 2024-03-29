import "enemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Spider').extends(Enemy)

function Spider:init(x, y, gameManager, map)
    self.maxHealth = 3
    self.health = self.maxHealth
    self.attack = 1
    Spider.super.init(self, "images/spider", x, y, gameManager, map)
    self.canDestruct = true
end

