local pd <const> = playdate
local gfx <const> = pd.graphics

class('HeartDisplay').extends(gfx.sprite)

function HeartDisplay:init(maxHealth)
    HeartDisplay.super.init(self)
    self.fullHeart = gfx.image.new("images/fullHeart")
    self.halfHeart = gfx.image.new("images/halfHeart")
    self.emptyHeart = gfx.image.new("images/emptyHeart")
    self.contextImage = gfx.image.new(240, 24)
    self.maxHealth = maxHealth
    self:updateHealth(maxHealth)
    self:setCenter(0, 0)
    self:moveTo(8, 3)
    self:add()
end

function HeartDisplay:updateHealth(health)
    self.contextImage:clear(gfx.kColorWhite)
    gfx.pushContext(self.contextImage)
    for i=2,self.maxHealth do
        if i % 2 == 0 then
            local toDraw = self.emptyHeart
            if i == health+1 then
                toDraw = self.halfHeart
            elseif i <= health then
                toDraw = self.fullHeart
            end
            toDraw:draw(((i-2)/2) * 24, 0)
        elseif i == self.maxHealth and self.maxHealth % 2 ~= 0 then
            local toDraw = self.emptyHeart
            if health == self.maxHealth then
                toDraw = self.halfHeart
            end
            toDraw:draw((i - 1)/2 * 24, 0)
        end
    end
    gfx.popContext(self.contextImage)
    self:setImage(self.contextImage)
end