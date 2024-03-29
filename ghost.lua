import "enemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Ghost').extends(Enemy)

function Ghost:init(x, y, gameManager, map)
    self.maxHealth = 1
    self.health = self.maxHealth
    self.attack = 1
    Ghost.super.init(self, "images/ghost", x, y, gameManager, map)
end

function Ghost:step(playerX, playerY)
    self.attackedThisTurn = false
    if self.stunned then
        self.stunned = false
        return
    end
    Ghost.super.step(self, playerX, playerY)
    if not self.attackedThisTurn then
        local emptyNeighbors = self:getEmptyNeighbors()
        if #emptyNeighbors > 0 then
            table.sort(emptyNeighbors, function(a, b) return self:dist(a) < self:dist(b) end)
            local moveDir = emptyNeighbors[1]
            self:moveEntityBy(moveDir.x, moveDir.y)
        end
    end
end

