local Lightset, super = Class(Event)

function Lightset:init(data)
    super.init(self, data)
    
    self:setSprite("world/events/lightset/city_lightset")
    self.sprite.alpha = 0
    self:setOriginExact(0, 40)

    self.l = data.width / self.sprite.width
    self.h = data.height / self.sprite.height

    self.a = data.height

    self.siner = 0
    self.seed = Utils.random(45000)
    self.mode = 2
    self.timer = 0
    self.minitimer = 0

    self.sprites = {}
    for i=1, self.l do
        self.sprites[i] = Sprite("world/events/lightset/city_lightset", (i-1) * 40, 0)
        local sp = self.sprites[i]
        sp:setScaleOrigin(0, 1)
        self:addChild(sp)

        sp.barsiner = Utils.random(4600)
        sp.scale_y = Utils.random(1) * self.scale_y
        local r, g, b = Utils.hsvToRgb(((i-1) * 255 / self.l)/255, 128/255, 255/255)
        sp.color = {r, g, b}
    end
end

function Lightset:draw()
    self.timer = self.timer + DTMULT
    self.minitimer = self.minitimer + DTMULT
    self.timerthreshold = 12
    self.minitimerthreshold = 2
    for i=1, self.l do
        local sp = self.sprites[i]
        if self.mode == 2 and self.minitimer >= self.minitimerthreshold then
            sp.barsiner = sp.barsiner + 1
            sp.scale_y = (0.6 * self.h) + (math.sin(sp.barsiner / 2) * 0.3) * self.h + (math.sin(sp.barsiner / 3) * 0.1) * self.h
        end
    end

    if self.timer >= self.timerthreshold then
        self.timer = 0
    end
    if self.minitimer >= self.minitimerthreshold then
        self.minitimer = 0
    end
    super.draw(self)
end

return Lightset