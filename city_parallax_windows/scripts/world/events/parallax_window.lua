local ParallaxWindow, super = Class(Event)

function ParallaxWindow:init(data)
    super.init(self, data)

    local pr = data.properties or {}

    self.inverted = pr.inverted or false

    if Kristal.getLibConfig("city_parallax_windows", "useAlternateWindowCode") then
        self.sprite_path = "world/events/parallax_window/"
        self:setSprite(self.sprite_path .. "window" .. (self.inverted and "_inverted" or ""))
        self.sprite:stop()
        self.sprite:setScale(2)
        self.sprite.wrap_texture_x = true
        self.sprite.wrap_texture_y = true

        self.scaled_sprite = Sprite(self.sprite_path.."window" .. (self.inverted and "_inverted" or ""))
        self.scaled_sprite:stop()
        self.scaled_sprite.alpha = 0.3
        self.scaled_sprite:setScale(3)
        self.scaled_sprite.wrap_texture_x = true
        self.scaled_sprite.wrap_texture_y = true
        self:addChild(self.scaled_sprite)

        self:setSize(data.width, data.height)

        self.scissor_fx = ScissorFX(0, 0, self.width, self.height)
        self:addFX(self.scissor_fx)
    end

    self.siner = 0
    self.dontdraw = 0
end

function ParallaxWindow:draw()
    self.siner = self.siner + DTMULT

    local color = self.inverted and Utils.hexToRgb("#ff5ada") or COLORS["yellow"]
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)

    if self.dontdraw == 1 then
        return
    end

    if Kristal.getLibConfig("city_parallax_windows", "useAlternateWindowCode") then
        self.sprite:setFrame(math.floor(self.siner/8))
        self.sprite.x = self.sprite.x + (DTMULT/(3/2))
        self.sprite.y = self.sprite.y + (DTMULT/(6/2))

        self.scaled_sprite:setFrame(math.floor(self.siner/8))
        self.scaled_sprite.x = self.scaled_sprite.x + (DTMULT/(8/3))
        self.scaled_sprite.y = self.scaled_sprite.y + (DTMULT/(8/3))
 
        love.graphics.setColor(1, 1, 1)

        super.draw(self)
    end
end

return ParallaxWindow