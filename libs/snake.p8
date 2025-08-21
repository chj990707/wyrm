#include vector.p8
Directions = {
    [0] = vec2:new(1,0),
    vec2:new(0,-1),
    vec2:new(-1,0),
    vec2:new(0,1)
}

Bodies = {
    {5, 7, 0, 9},
    {6, 8, 9, 0},
    {0, 4, 5, 6},
    {4, 0, 7, 8}
}

Anim_d2 = {
    [0] = 0,
    1,
    1,
    0,
    -1,
    -1
}

Snake = {
    anim = 0,
    animCount = 12,
    counter = 1,
    direction = 0,
    body_direction = {},
    body_position = {},
    new = function(self, x, y, d, col)
        local o = {
            direction = d,
            body_direction = {d},
            body_position = {vec2:new(x,y)},
            color = col
        }
        setmetatable(o, self)
        self.__index = self
        return o
    end,
    update = function(self)
        self[self.counter](self)
        add(self.body_direction, self.direction, 1)
        add(self.body_position, self.body_position[1] + Directions[self.direction], 1)
        while #self.body_position > #self + 1 do
            deli(self.body_position, #self.body_position)
            deli(self.body_direction, #self.body_direction)
        end
    end,
    draw = function(self, offset)
        local offset = offset or vec2:new(0, 0)
        if self.color then
            pal(8, self.color[1])
            pal(14, self.color[2])
            pal(2, self.color[3])
        end
        local pdir, dir, sprite = self.direction, self.direction, dir
        local segment = self.anim * 6 \ self.animCount
        local pos = self.body_position[1] * 8 + Anim_d2[segment] * Directions[(dir + 1) % 4] + offset
        spr(dir, pos.x, pos.y)
        local l = #self.body_position
        for i = 2, l - 1 do
            dir = self.body_direction[i]
            pos = self.body_position[i] * 8 + offset
            sprite = Bodies[dir+1][pdir+1]
            segment -= 1
            segment %= 6
            if pdir == dir then
                pos += Anim_d2[segment] * Directions[(dir + 1) % 4]
            elseif Anim_d2[segment] > 0 then
                sprite += 16
            end
            spr(sprite, pos.x, pos.y)
            pdir = dir
        end
        segment -= 1
        segment %= 6
        pos = self.body_position[l] * 8 + Anim_d2[segment] * Directions[(dir + 1) % 4] + offset
        spr(10 + dir, pos.x, pos.y)
        pal()
        self.anim += 1
        self.anim %= self.animCount
    end,
    add_counter = function(self, incr)
        self.counter += incr or 1
        if self.counter > #self then self.counter = 1 end
    end,
    set_counter = function(self, idx)
        self.counter = idx or 1
        if self.counter > #self then self.counter = 1 end
    end,
    turn = function(self, left)
        if left then self.direction += 1
        else self.direction -= 1 end
        self.direction %= 4
    end,
    remove_event = {},
    add_inst = function(self, inst, idx)
        if mid(idx, 1, #self + 1) ~= idx then idx = #self + 1 end
        self[idx] = inst
    end,
    remove_inst = function(self, idx)
        if mid(idx, 1, #self + 1) ~= idx then idx = #self + 1 end
        for f in all(self.remove_event[idx]) do
            f(self, idx)
        end
        deli(remove_event,idx)
        deli(self, idx)
    end,
    add_remove_event = function(self, func, idx)
        self.remove_event[idx] = self.remove_event[idx] or {}
        add(self.remove_event[idx], func)
    end
}