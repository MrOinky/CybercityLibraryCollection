local BackgroundSign, super = Class(Event)

function BackgroundSign:init(data)
    super.init(self, data)

    self.columns    = math.max(1.0, math.floor(self.height / 80))
    self.rows       = math.max(1.0, math.floor(self.width  / 80))

    self.siner = 0

    local pr = data["properties"]

    self.sprite_name = pr["sprite"] or "dog"
end

function BackgroundSign:draw()
    super.draw(self)

    for i=0,self.rows-1 do
        for j=0, self.columns-1 do
            local path = "world/events/bg_sign/cityad_" .. self.sprite_name

            love.graphics.setColor(1, 1, 1, ((math.sin(((i + j) + (self.siner / 8))) * 0.5) + 0.5))
            love.graphics.draw(Assets.getTexture(path), i * 80, j * 80, 0, 2, 2)
        end
    end

    self.siner = self.siner - DTMULT
end

return BackgroundSign