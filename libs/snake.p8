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
    address = 1,
    direction = 0,
    body_direction = {},
    body_position = {},
    new = function(self, x, y, d, col)
        local o = {
            direction = d,
            body_direction = {d, d},
            body_position = {vec2:new(x,y), vec2:new(x,y) - Directions[d]},
            color = col
        }
        setmetatable(o, self)
        self.__index = self
        return o
    end,
    update = function(self)
        if #self < 1 then return end
        local remove = self[self.address]()
        self:remove_part(remove)
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
    add_address = function(self, increment)
        self:set_address(self.address + increment or 1)
    end,
    set_address = function(self, idx)
        local newidx = mid(idx, 1, #self)
        if newidx ~= idx then newidx = 1 end
        self.address = newidx
    end,
    turn = function(self, left)
        if left then self.direction += 1
        else self.direction -= 1 end
        self.direction %= 4
    end,
    add_inst = function(self, instruction, idx)
        local idx = idx or #self + 1
        local newidx = mid(1, ceil(idx), #self + 1)
        if newidx ~= idx or #self < newidx then
            self:add_part(newidx)
        end
        if instruction ~= nil then
            self[newidx]:add_inst(instruction)
        end
    end,
    add_part = function(self, idx)
        local prev, next = nil, nil
        if idx > 1 then prev = self[idx - 1] end
        if idx < #self + 1 then next = self[idx] end
        local new_part = Body_part:new(self, prev, next)
        add(self, new_part, idx)
        if prev then prev.next = new_part end
        if next then next.prev = new_part end
        self[idx]:add_inst(Proceed:new())
    end,
    remove_part = function(self, toRemove)
        if toRemove == nil then return end
        for i = 1, #self do
            self[i](toRemove)
        end
        for i = #self, 1, -1 do
            self[i](toRemove)
        end
        if #toRemove > 0 then
            for d = 1, #toRemove do
                local d_body = toRemove[d]
                local d_prev, d_next = d_body.prev, d_body.next
                if d_next then d_next.prev = d_prev end
                if d_prev then d_prev.next = d_next end
                del(self, d_body)
            end
            self:add_address(-#toRemove)
        end
    end,
    remove_part_at = function(self, idx)
        self:remove_part(self[idx])
    end
}