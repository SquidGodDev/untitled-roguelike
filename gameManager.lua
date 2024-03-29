import "skeleton"
import "orc"
import "ghost"
import "spider"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('GameManager').extends()

function GameManager:init(player, level)
    math.randomseed(playdate.getSecondsSinceEpoch())
    self.enemies = {}
    self.player = player
    self.player:setGameManager(self)
    self.level = level
    self.won = false
    self:generateMap()
    self:displayLevel()
end

function GameManager:displayLevel()
    local levelImage = gfx.image.new(30, 14)
    gfx.pushContext(levelImage)
        monochromeRPGNumbers:drawTextAligned(self.level, 0, 0, kTextAlignment.left)
    gfx.popContext()
    local levelSprite = gfx.sprite.new()
    levelSprite:setImage(levelImage)
    levelSprite:moveTo(310, 16)
    levelSprite:add()
end

function GameManager:gameStep()
    for i=#self.enemies,1,-1 do
        local curEnemy = self.enemies[i]
        if curEnemy.health <= 0 then
            table.remove(self.enemies, i)
        else
            curEnemy:step(self.player.gridX, self.player.gridY)
        end
    end
    if #self.enemies == 0 then
        self.won = true
    end
end

function GameManager:checkWin()
    for i=#self.enemies,1,-1 do
        local curEnemy = self.enemies[i]
        if curEnemy.health <= 0 then
            table.remove(self.enemies, i)
        end
    end
    if #self.enemies == 0 then
        self.won = true
    end
end

function GameManager:generateMap()
    self.map = Map()
    self.map:generateMap()
    self.player:setMap(self.map)
    local enemyConstructors = {}
    if self.level > 9 then
        enemyConstructors = {Skeleton, Orc, Ghost, Spider}
    elseif self.level > 6 then
        enemyConstructors = {Skeleton, Orc, Ghost}
    elseif self.level > 3 then
        enemyConstructors = {Skeleton, Orc}
    else
        enemyConstructors = {Skeleton}
    end

    local numberOfEnemies = self.level+1
    if numberOfEnemies > 12 then
        numberOfEnemies = 12
    end
    for i=1,numberOfEnemies do
        local emptyX, emptyY = self.map:getEmptySpace()
        local curEnemyConstructor = enemyConstructors[math.random(#enemyConstructors)]
        local newEnemy = curEnemyConstructor(emptyX, emptyY, self, self.map)
        table.insert(self.enemies, newEnemy)
        newEnemy:add()
    end
end