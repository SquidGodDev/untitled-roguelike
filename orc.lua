import "enemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Orc').extends(Enemy)

function Orc:init(x, y, gameManager, map)
    self.maxHealth = 4
    self.health = self.maxHealth
    self.attack = 2
    Orc.super.init(self, "images/orc", x, y, gameManager, map)
end

function Orc:step(playerX, playerY)
    local startStunned = self.stunned
    Orc.super.step(self, playerX, playerY)
    if not startStunned then
        self.stunned = true
    end
end