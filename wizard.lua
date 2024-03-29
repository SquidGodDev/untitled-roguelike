class('Wizard').extends(Player)

function Wizard:init()
    self.maxHealth = 6
    self.abilityImage = playdate.graphics.image.new("images/abilities/wizardAbility")
    self.abilityCooldown = 30
    self.explosionSound = playdate.sound.sample.new("sound/explosion")
    Wizard.super.init(self, "images/wizard")
end

function Wizard:useAbility()
    local usedAbility = Wizard.super.useAbility(self)
    if usedAbility then
        self.explosionSound:play()
        for i=1,self.map.maxX do
            for j=1,self.map.maxY do
                local curEntity = self.map:getEntity(i, j)
                if curEntity and curEntity:isa(Enemy) then
                    curEntity:damage(1)
                end
            end
        end
        screenShake(15)
        self.gameManager:checkWin()
    end
end