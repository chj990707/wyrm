#include snake.p8
Instruction = {
    __call = function(self, part, remove)
    end,
    spr = 32,
    new = function(self, o)
        local o = o or {}
        setmetatable(o, self)
        self.__index = self
        return o
    end
}

Proceed = Instruction:new()
Proceed.__call = function(self, part, remove)
    if not remove then
        part.snake:add_address(1)
    end
end
Proceed.position = 1
Proceed.spr = 33

TurnLeft = Instruction:new()
TurnLeft.__call = function(self, part, remove)
    if not remove then
        part.snake:turn(true)
    end
end
TurnLeft.position = 2
TurnLeft.spr = 35

TurnRight = Instruction:new()
TurnRight.__call = function(self, part, remove)
    if not remove then
        part.snake:turn(false)
    end
end
TurnRight.position = 2
TurnRight.spr = 36

Burnt = Instruction:new()
Burnt.__call = function(self, part, remove)
    local remove = remove or { part }
    return remove
end
Burnt.position = 3
Burnt.spr = 37

Flame = Instruction:new()
Flame.__call = function(self, part, remove)
    if not remove then
        if part.next then part.next:add_inst(Burnt:new()) end
        if part.prev then part.prev:add_inst(Burnt:new()) end
    end
end
Flame.position = 3
Flame.spr = 38

Eternal = Instruction:new()
Eternal.__call = function(self, part, remove)
    if remove then
        del(remove, part)
    end
end
Eternal.position = 3
Eternal.spr = 39

Chained = Instruction:new()
Chained.__call = function(self, part, remove)
    if remove and count(remove, part) == 0 then
        for i = 1, #remove do
            if remove[i] == part.prev then
                add(remove, part, i + 1)
                break
            elseif remove[i] == part.next then
                add(remove, part, i)
                break
            end
        end
    end
end
Chained.position = 3
Chained.spr = 40

Body_part = {
    __call = function(self, remove)
        local remove = remove
        for i = 1, 4 do
            if self[i] then remove = self[i](self, remove) or remove end
        end
        return remove
    end,
    new = function(self, snake, prev, next)
        local o = {snake = snake, prev = prev, next = next}
        setmetatable(o, self)
        self.__index = self
        return o
    end,
    add_inst = function(self, inst)
        if not self[inst.position] then self[inst.position] = inst end
    end,
    inst_icons = function(self)
        local o = {32, 34, 32, 32}
        for i = 1, 4 do
            if self[i] then o[i] = self[i].spr end
        end
        return o
    end
}
