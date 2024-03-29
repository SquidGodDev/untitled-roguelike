class('Defender').extends(Player)

function Defender:init()
    self.maxHealth = 10
    self.abilityImage = playdate.graphics.image.new("images/abilities/defenderAbility")
    self.abilityCooldown = 9
    self.intimidateSound = playdate.sound.sample.new("sound/intimidate")
    Defender.super.init(self, "images/defender")
end

function Defender:useAbility()
    local usedAbility = Defender.super.useAbility(self)
    if usedAbility then
        self.intimidateSound:play()
        for i=1,self.map.maxX do
            for j=1,self.map.maxY do
                local curEntity = self.map:getEntity(i, j)
                if curEntity and curEntity:isa(Enemy) then
                    curEntity.stunned = true
                end
            end
        end
        screenShake(10)
    end
end