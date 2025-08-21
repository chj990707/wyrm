#include instruction.p8
#include snake.p8
#include vector.p8

function _init()
    testSnake = {}
    testSnake[1] = Snake:new(9, 8, 2)
    testSnake[2] = Snake:new(6, 9, 1,{12, 6, 13})
    testSnake[3] = Snake:new(5, 6, 0)
    testSnake[4] = Snake:new(8, 5, 3,{12, 6, 13})
    testSnake[5] = Snake:new(3, 4, 3,{5, 13, 1})
    testSnake[6] = Snake:new(11, 10, 1,{6, 7, 13})
    for i=1,4 do
        testSnake[i]:add_inst(Instruction:new())
        testSnake[i]:add_inst(Turn:new(true))
        testSnake[i]:add_inst(Instruction:new())
        testSnake[i]:add_inst(Turn:new(true))
    end
    for i=5,6 do
        testSnake[i]:add_inst(Instruction:new())
        testSnake[i]:add_inst(Instruction:new())
        testSnake[i]:add_inst(Instruction:new())
        testSnake[i]:add_inst(Instruction:new())
        testSnake[i]:add_inst(Instruction:new())
        testSnake[i]:add_inst(Instruction:new())
        testSnake[i]:add_inst(Instruction:new())
        testSnake[i]:add_inst(Turn:new(true))
    end
    t=0
end

function _update()
    if t == 0 then
        for s in all(testSnake) do
            s:update()
        end
    end
    t+=1
    t%=6
end

function _draw()
    cls()
    for s in all(testSnake) do
        s:draw(vec2:new(4, 4))
    end
end
