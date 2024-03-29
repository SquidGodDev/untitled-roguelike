local pd <const> = playdate
local gfx <const> = pd.graphics

class('Map').extends()

function Map:init()
    self.map = gfx.tilemap.new()
    self.maxX = 12
    self.maxY = 6
    self:resetEntityMatrix()
    self.destructSound = pd.sound.sample.new("sound/woodChop")
end

function Map:resetEntityMatrix()
    self.entityMatrix = {}
    for i=1,self.maxX do
        self.entityMatrix[i] = {}
        for j=1,self.maxY do
            self.entityMatrix[i][j] = nil
        end
    end
end

function Map:generateMap()
    math.randomseed(pd.getSecondsSinceEpoch())
    local mapImagetable = gfx.imagetable.new("images/tilemap-table-32-32")

    local perlin_x = math.random() * 100
    local perlin_y = math.random() * 100
    local perlin_z = math.random() * 100    
    local scale = 6

    self.map:setImageTable(mapImagetable)
    self.map:setSize(self.maxX, self.maxY)

    local solidTileCount = 0
    for x = 1,self.maxX do
        for y = 1,self.maxY do
            local perlinValue = gfx.perlin((perlin_x + x) / scale, (perlin_y + y) / scale, perlin_z / scale, 0, 6, 1)
            if perlinValue > .52 then
                self.map:setTileAtPosition(x, y, 6)
                solidTileCount += 1
                if solidTileCount > 256 then
                    self.map:setTileAtPosition(x, y, math.random(1,3))
                end
            else
                self.map:setTileAtPosition(x, y, math.random(1,3))
            end
        end
    end
    self.mapSprite = gfx.sprite.new()
    self.mapSprite:setZIndex(-100)
    self.mapSprite:setTilemap(self.map)
    self.mapSprite:setCenter(0, 0)
    self.mapSprite:moveTo(8, 32)
    self.mapSprite:add()
end

function Map:draw(x, y)
    self.map:draw(x, y)
end

function Map:isDestructible(x, y)
    local curTile = self.map:getTileAtPosition(x, y)
    if curTile then
        return curTile >= 5
    end
    return false
end

function Map:destruct(x, y)
    local curTile = self.map:getTileAtPosition(x, y)
    if self:isDestructible(x, y) then
        self.destructSound:play()
        self.map:setTileAtPosition(x, y, curTile - 1)
    end
end

function Map:getEmptySpace()
    local curX = math.random(1, self.maxX)
    local curY = math.random(1, self.maxY)
    local isDestructible = self:isDestructible(curX, curY)
    local entityAtTile = self.entityMatrix[curX][curY]
    while isDestructible or entityAtTile do
        curX = math.random(1, self.maxX)
        curY = math.random(1, self.maxY)
        isDestructible = self:isDestructible(curX, curY)
        entityAtTile = self.entityMatrix[curX][curY]
    end
    return curX, curY
end

function Map:getEntity(x, y)
    if (x <= 0) or (x > self.maxX) then
        return nil
    elseif (y <= 0) or (y > self.maxY) then
        return nil
    end
    return self.entityMatrix[x][y]
end