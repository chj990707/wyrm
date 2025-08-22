#include instruction.p8
#include snake.p8
#include vector.p8

function _init()
    testSnake = Snake:new(11, 9, 2)
    testSnake:add_inst()
    testSnake:add_inst()
    testSnake:add_inst()
    testSnake:add_inst()
    testSnake:add_inst(Burnt:new())
    testSnake:add_inst(Flame:new())
    testSnake:add_inst()
    testSnake:add_inst()
    testSnake:add_inst()
    testSnake:add_inst()
    testSnake:add_inst(TurnRight:new())
    t=0
end

function _update()
    if t == 6 then
        testSnake:update()
    end
    t+=1
    t%=12
end

function _draw()
    cls()
    testSnake:draw(vec2:new(4, 4))
    draw_program(testSnake)
    pal()
end

function draw_program(snake)
    local x, y, icons = 8, 88
    rect(10, 90, 117, 123)
    for i = 1, #snake do
        if i == snake.address then pal(7, 8) end
        icons = snake[i]:inst_icons()
        for j = 1, 4 do
            spr(icons[j], x + i * 8, y + j * 8)
        end
        pal()
    end
end