#include snake.p8
Instruction = {
    __call = function(self, snake)
        snake:add_counter()
    end,
    spr = 4,
    new = function(self, o)
        local o = o or {}
        setmetatable(o, self)
        self.__index = self
        return o
    end
}
Turn = {
    __call = function(self, snake)
        snake:add_counter()
        snake:turn(self.left)
    end,
    spr = 4,
    new = function(self, isLeft)
        local o = {left = isLeft or false}
        setmetatable(o, self)
        self.__index = self
        return o
    end
}