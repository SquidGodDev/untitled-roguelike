local pd <const> = playdate
local gfx <const> = pd.graphics

class('Entity').extends(gfx.sprite)

local tileSize = 32

function Entity:init(imagePath)
    Entity.super.init(self)

    self.entityImage = gfx.image.new(imagePath)
    self:setImage(self.entityImage)
    self:setCenter(0, 0)
    self.flipped = false
    self.moveAnimator = nil
    self.map = nil
    self.gridX = 1
    self.gridY = 1
    self.bonusAttack = 0
    self.hitSound = pd.sound.sample.new("sound/hit")
end

function Entity:getTruePosition()
    local trueX = (self.gridX - 1) * tileSize + 8
    local trueY = (self.gridY - 1) * tileSize + 32
    return trueX, trueY
end

function Entity:damage(amount)
    self.health -= amount
end

function Entity:update()
    Entity.super.update(self)

    if self.moveAnimator then
        local animationX = self.moveAnimator:currentValue().x
        local animationY = self.moveAnimator:currentValue().y
        self:moveTo(animationX, animationY)
        if self.moveAnimator:ended() then
            self.takeInput = true
        end
    end
end

function Entity:moveEntityBy(gridX, gridY)
    if self.flipped then
        self:setImage(self.entityImage, gfx.kImageFlippedX)
    else
        self:setImage(self.entityImage)
    end

    local curX, curY = self:getTruePosition()
    local curPos = pd.geometry.point.new(curX, curY)
    local moveTime = 100
    local moveEasingFunction = pd.easingFunctions.inOutQuad

    local validSpace = self:checkValidSpace(gridX, gridY)
    local targetX = self.gridX + gridX
    local targetY = self.gridY + gridY
    local entityAtTarget = self.map:getEntity(targetX, targetY)
    if not validSpace or entityAtTarget then
        local outX = curX + gridX * tileSize / 2
        local outY = curY + gridY * tileSize / 2
        local outLine = pd.geometry.lineSegment.new(curX, curY, outX, outY)
        self.moveAnimator = gfx.animator.new(moveTime, outLine, moveEasingFunction)
        self.map:destruct(targetX, targetY)
        if self:isa(Player) then
            if not validSpace then
                screenShake(1)
            else
                self.hitSound:play()
                screenShake(3)
            end
        end
        if entityAtTarget then
            entityAtTarget:damage(self.attack + self.bonusAttack)
            self.attackedThisTurn = true
            self.bonusAttack = 0
        end
        return false
    end

    self.map.entityMatrix[self.gridX][self.gridY] = nil
    self.gridX += gridX
    self.gridY += gridY
    self.map.entityMatrix[self.gridX][self.gridY] = self

    local x = gridX * tileSize
    local y = gridY * tileSize

    local newPos = pd.geometry.point.new(curX + x, curY + y)
    self.moveAnimator = gfx.animator.new(moveTime, curPos, newPos, moveEasingFunction)
    return true
end

function Entity:setMap(map)
    self.map = map
    self.map.entityMatrix[self.gridX][self.gridY] = self
end

function Entity:checkOutOfBounds(gridX, gridY)
    local targetX = self.gridX + gridX
    local targetY = self.gridY + gridY

    if targetX <= 0 then
        return true
    elseif targetX > self.map.maxX then
        return true
    elseif targetY <= 0 then
        return true
    elseif targetY > self.map.maxY then
        return true
    end
    return false
end

function Entity:checkValidSpace(gridX, gridY)
    local targetX = self.gridX + gridX
    local targetY = self.gridY + gridY

    if targetX <= 0 then
        return false
    elseif targetX > self.map.maxX then
        return false
    elseif targetY <= 0 then
        return false
    elseif targetY > self.map.maxY then
        return false
    end

    if self.map:isDestructible(targetX, targetY) then
        return false
    end

    return true
end