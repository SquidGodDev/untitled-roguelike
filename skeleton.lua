import "enemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Skeleton').extends(Enemy)

function Skeleton:init(x, y, gameManager, map)
    self.maxHealth = 2
    self.health = self.maxHealth
    self.attack = 1
    Skeleton.super.init(self, "images/skeleton", x, y, gameManager, map)
end