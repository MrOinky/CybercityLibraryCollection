local TrafficCarGenerator, super = Class(Event)

function TrafficCarGenerator:init(data)
    super.init(self, data)
    
    local pr = data["properties"]

    self.gen_rate       = pr["gen_rate"]        or 30
    self.gen_speed      = pr["gen_speed"]       or 20
    self.skip_every     = pr["skip_every"]      or 0
    self.prepopulate    = pr["prepopulate"]     or true
    self.walking        = pr["walking"]         or false
    self.always_walking = pr["always_walking"]  or false
    self.car_type       = pr["car_type"]        or "down"
    self.car_sprite     = pr["car_sprite"]      or "traffic_car"
    self.group          = pr["group"]           or 0

    self.timer = 0
    self._active        = true
    
    self.groupcheck     = 0
    self.extflag        = 0
    self.speedadjust    = false
    self.makecar        = 0
    self.carcount       = 0

    Kristal.callEvent("onTrafficCarGeneratorInit", self)
end

function TrafficCarGenerator:getDebugInfo()
    local info = {
        "gen_rate: " .. self.gen_rate,
        "gen_speed: " .. self.gen_speed,
        "skip_every: " .. self.skip_every,
        "walking: " .. tostring(self.walking),
        "always_walking: " .. tostring(self.always_walking),
        "car_type: " .. self.car_type,
        "car_sprite: " .. self.car_sprite,
        "timer: " .. self.timer,
    }

    return info
end

function TrafficCarGenerator:update()
    if Kristal.callEvent("beforeTrafficCarGeneratorUpdate", self) then
        return
    end

    if self.prepopulate then
        -- This does not take skipping into account, but the same happens in DELTARUNE
        for i=0,5 do
            self:makeCar(self.x, self.y + ((self.gen_speed * self.gen_rate) * i))
        end

        self.prepopulate = false
    end
    
    if self._active and not Game.world.cutscene and not Game.world.menu and not Game.world.car_collision then
        self.timer = self.timer + (0.25 * DTMULT)
        if not self.walking then
            self.timer = self.timer + (0.75 * DTMULT)
        end
    end

    if (self.timer >= self.gen_rate) then
        self.carcount = self.carcount + 1
        if self.skip_every ~= 0 then
            if self.carcount % self.skip_every == 0 then
                self.makecar = 0
            else
                self.makecar = 1
            end
        else
            self.makecar = 1
        end

        if self.makecar == 1 then
            self:makeCar(self.x, self.y)

            self.makecar = 0
        end
        self.timer = 0
    end

    Kristal.callEvent("onTrafficCarGeneratorUpdate", self)
end

function TrafficCarGenerator:makeCar(x, y)
    local car = Registry.createEvent("traffic_car", {x = x, y = y})
    car.speed = self.gen_speed
    car.remspeed = self.gen_speed
    car.car_path = self.car_sprite
    car.group = self.group
    car.walking = self.walking
    car.alwayswalking = self.always_walking
    car.speedadjust = self.speedadjust
    car:setWalking(self.car_type)
    
    Game.world:spawnObject(car)
    Kristal.callEvent("onTrafficCarGeneratorMakeCar", self, car)

    return car
end

return TrafficCarGenerator