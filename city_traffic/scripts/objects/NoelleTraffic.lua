local NoelleTraffic, super = Class(Sprite)

function NoelleTraffic:init(x, y)
    local texture = Assets.getTexture("party/noelle/noelle_cower_right_1")
    super:init(self, texture, x, y)
    self:setScale(2)
    self:stop(false)
    self:setOrigin(0.5, 1)

    self.path = "party/noelle"

    self.ideal_pos_progress = 0
    self.ideal_x = self.x
    self.ideal_y = self.y

    self.pos = "up"
    self.prevpos = "down"
    
    self.noelle = nil
    self.region = nil
end

function NoelleTraffic:update()
    super.update(self)

    if self.ideal_pos_progress < 1 then
        self.ideal_pos_progress = self.ideal_pos_progress + (0.08*DTMULT)
        if self.ideal_pos_progress > 1 then
            self.ideal_pos_progress = 1
        end
    end

    local clamp = self.region.properties["noelle_clamp_y"]
    if clamp then
        self.ideal_x = Game.world.player.x - 4 + math.abs(Game.world.player.width - self.width)
        self.ideal_y = Game.world.player.y + 30 + (math.abs(Game.world.player.height - self.height) * 2)
        self.ideal_y = Utils.clamp(self.ideal_y, 0, clamp)
    else
        if Game.world.player.y > Game.world.player.last_y  then
            self.pos = "down"
        elseif Game.world.player.y < Game.world.player.last_y then
            self.pos = "up"
        end

        if self.pos ~= self.prevpos then
            self.ideal_pos_progress = 0
        end
        self.ideal_x = Game.world.player.x - 4
        if self.pos == "up" then
            self.ideal_y = Game.world.player.y + 30
        end
        if self.pos == "down" then
            self.ideal_y = Game.world.player.y - 30
        end

        self.prevpos = self.pos
    end
    self.ideal_x = self.ideal_x
    self.ideal_y = self.ideal_y
    self.x = Utils.lerp(self.x, self.ideal_x, self.ideal_pos_progress)
    self.y = Utils.lerp(self.y, self.ideal_y, self.ideal_pos_progress)
    if self.last_x < self.x then
        self:set("noelle_cower_right")
    elseif self.last_x > self.x then
        self:set("noelle_cower_left")
    end
    self:setFrame(Game.world.player.sprite.frame)
end

return NoelleTraffic