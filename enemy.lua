import "entity"
import "healthDisplay"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Enemy').extends(Entity)

function Enemy:init(enemySpritePath, x, y, gameManager, map)
    Enemy.super.init(self, enemySpritePath)
    self.gridX = x
    self.gridY = y
    self:moveTo(self:getTruePosition())
    self.gameManager = gameManager
    self:setMap(map)
    self.playerX = nil
    self.playerY = nil
    self.range = 3
    self.stunned = false
    self.healthDisplay = HealthDisplay(self:getTruePosition())
    self.canDestruct = false
end

function Enemy:damage(amount)
    self.stunned = true
    Enemy.super.damage(self, amount)
    self.healthDisplay:updateHealth(self.maxHealth, self.health)
    if self.health <= 0 then
        self:die()
    end
end

function Enemy:die()
    self.map.entityMatrix[self.gridX][self.gridY] = nil
    self:remove()
    self.healthDisplay:removeDisplay()
end

function Enemy:step(playerX, playerY)
    if self.stunned then
        self.stunned = false
        return
    end
    self.playerX = playerX
    self.playerY = playerY
    local emptyNeighbors = self:getEmptyNeighbors()
    if #emptyNeighbors > 0 then
        table.sort(emptyNeighbors, function(a, b) return self:dist(a) < self:dist(b) end)
        local moveDir = emptyNeighbors[1]
        self:moveEntityBy(moveDir.x, moveDir.y)
    end
end

function Enemy:dist(direction)
    -- returns mahattan distance to player
    return math.abs(self.gridX + direction.x - self.playerX) + math.abs(self.gridY + direction.y - self.playerY)
end

function Enemy:getEmptyNeighbors()
    local emptyNeighbors = {}
    local leftDir = pd.geometry.point.new(-1, 0)
    local rightDir = pd.geometry.point.new(1, 0)
    local upDir = pd.geometry.point.new(0, -1)
    local downDir = pd.geometry.point.new(0, 1)
    local neighbors = {leftDir, rightDir, upDir, downDir}
    for k in pairs(neighbors) do
        local curDir = neighbors[k]
        local validSpace = self:checkValidSpace(curDir.x, curDir.y)
        local targetX = self.gridX + curDir.x
        local targetY = self.gridY + curDir.y
        if self.canDestruct then
            validSpace = validSpace or self.map:isDestructible(targetX, targetY)
        end
        if validSpace then
            local entityAtTarget = self.map:getEntity(targetX, targetY)
            if not entityAtTarget then
                table.insert(emptyNeighbors, curDir)
            elseif entityAtTarget:isa(Player) then
                table.insert(emptyNeighbors, curDir)
            end
        end
    end
    return emptyNeighbors
end

function Enemy:moveTo(x, y)
    Enemy.super.moveTo(self, x, y)
    if self.healthDisplay then
        self.healthDisplay:updatePosition(x, y)
    end
end

function Enemy:playerInRange()
    if math.abs(self.gridX - self.playerX) > self.range then
        return false
    elseif math.abs(self.gridY - self.playerY) > self.range then
        return false
    end
    return true
end