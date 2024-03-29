local pd <const> = playdate
local gfx <const> = pd.graphics

class('HealthDisplay').extends(gfx.sprite)

function HealthDisplay:init(x, y)
    HealthDisplay.super.init(self)
    self.healthImagetable = gfx.imagetable.new("images/health-table-32-12")
    self:setImage(self.healthImagetable:getImage(1))
    self:setCenter(0, 0)
    self:setZIndex(100)
    self:updatePosition(x, y)
    self:add()
end

function HealthDisplay:updateHealth(maxHealth, health)
    if health < maxHealth then
        if health <= 0 then
            self:setImage(self.healthImagetable:getImage(1))
        elseif health == 1 then
            self:setImage(self.healthImagetable:getImage(2))
        elseif health == 2 then
            self:setImage(self.healthImagetable:getImage(3))
        elseif health == 3 then
            self:setImage(self.healthImagetable:getImage(4))
        end
    end
end

function HealthDisplay:updatePosition(x, y)
    self:moveTo(x, y-12)
end

function HealthDisplay:removeDisplay()
    self:remove()
end