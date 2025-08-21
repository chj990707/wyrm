vec2 = {
    __add = function(a, b)
        return vec2:new(a.x + b.x, a.y + b.y)
    end,
    __sub = function(a, b)
        return vec2:new(a.x - b.x, a.y - b.y)
    end,
    __mul = function(a,b)
        if type(a) == "number" then
            return vec2:new(a * b.x, a * b.y)
        elseif type(b) == "number" then
            return vec2:new(b * a.x, b * a.y)
        end
        return a.x * b.x + a.y * b.y
    end,
    __unm = function(a)
        return vec2:new(-a.x, -a.y)
    end,
    new = function(self, x, y)
        local o = {x = x or 0,y = y or 0}
        setmetatable(o, self)
        self.__index = self
        return o
    end
}