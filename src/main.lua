dt = 0.016666666666666666

p1 = 300
p2 = 300
ball_x = 395
ball_y = 295
ball_x_speed = 0 
ball_y_speed = 0
padheight = 50
boardheight = 600
boardwidth = 800
p1score = 0
p2score = 0
paused = false

function newgame()
    p1 = boardheight / 2 - padheight/2
    p2 = p1
    ball_x = boardwidth/2-5
    ball_y = boardheight/2-5
    if math.random()>0.5 then
        ball_x_speed = 3
    else
        ball_x_speed = -3
    end
    ball_y_speed = 0
end


function love.load()
    newgame()
end

function playerupdate(keyup, keydown, dp)
    if love.keyboard.isDown(keydown) then
        return 4
    end
    if love.keyboard.isDown(keyup) then
        return -4
    end
    return 0
end

function move_and_checkfloors(p, dp)
    p = p+dp
    if p<0 then
        return 0,0
    elseif p>boardheight - padheight then
        return boardheight - padheight, 0
    end
    return p, dp 
end

function move_ball()
    if ball_x <= 0 then
        p2score = p2score + 1
        newgame()
    elseif ball_x >= boardwidth then
        p1score = p1score + 1
        newgame()
    elseif 750 <= ball_x+ball_x_speed and ball_x <=750 and ball_x_speed >0 and p2-10 <= ball_y and ball_y <= p2+padheight then
        part =((750-ball_x)/ball_x_speed)
        ball_x = ball_x + part*ball_x_speed
        ball_y = ball_y + part*ball_y_speed
        ball_x_speed = -ball_x_speed -1
        ball_y_speed = -(p2+padheight/2-ball_y)/10
        ball_x = ball_x - part*ball_x_speed
        ball_y = ball_y - part*ball_y_speed
     elseif ball_x+ball_x_speed <= 50 and ball_x_speed < 0 and p1-10 <= ball_y and ball_y <= p1+padheight then
        part = ((ball_x-50)/ball_x_speed)
        ball_x = ball_x + part*ball_x_speed
        ball_y = ball_y + part*ball_y_speed
        ball_x = ball_x + ball_x_speed
        ball_y = ball_y + ball_y_speed
        ball_x_speed = -ball_x_speed + 1
        ball_y_speed = -(p1+padheight/2-ball_y)/10
        ball_x = ball_x - part*ball_x_speed
        ball_y = ball_y - part*ball_y_speed
    end
    ball_x = ball_x + ball_x_speed
    ball_y = ball_y + ball_y_speed
    if ball_y <= 0 or ball_y >= boardheight -10 then
        ball_y_speed = - ball_y_speed
    end
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    if love.keyboard.isDown("p") then
        paused = not paused
    end
    if paused then
        return
    end
    dp1 = playerupdate("e", "d", dp1)
    dp2 = playerupdate("up", "down", dp2)
    p1, dp1 = move_and_checkfloors(p1, dp1) 
    p2, dp2 = move_and_checkfloors(p2, dp2)
    move_ball()
end
    
function love.draw()
    if paused then
        love.graphics.print("PAUSED", 380, 50+(ball_y+400)%500)
    end
    love.graphics.rectangle('fill', 40, p1, 10, padheight)
    love.graphics.rectangle('fill', 750, p2, 10, padheight)
    love.graphics.circle('fill', ball_x+5, ball_y+5, 5, 100)
    love.graphics.print(""..tostring(p1score).." - "..tostring(p2score), boardwidth/2-30, 40)
    --love.graphics.print("bxs:"..tostring(ball_x_speed).." bys:"..tostring(ball_y_speed), 300, 400)
    --love.graphics.print("p1:"..tostring(p1).." p2:"..tostring(p2).." ", 300, 450)
    --love.graphics.print("right_hit:"..tostring(750-ball_x_speed*2 <= ball_x)..tostring(ball_x <=750+ball_x_speed*2)..tostring(ball_x_speed >0)..tostring(p2-10 <= ball_y)..tostring(ball_y <= p2+padheight), 300, 500)
    --love.graphics.print("left  hit:"..tostring( 50-ball_x_speed*2 <= ball_x)..tostring( ball_x <=50+ball_x_speed*2)..tostring( ball_x_speed < 0)..tostring( p1-10 <= ball_y)..tostring( ball_y <= p1+padheight),300, 550)

end
