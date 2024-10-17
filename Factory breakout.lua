t = 0 

robot = {
    spr = 256,
    movespeed = 10,
    jumpSpeed = 10,
    hitbox = {
        x = 0,
        y = 64,
        width = 16,
        height = 16
    }
}

finish = {
    spr = 270 ,
    hitbox = {
        x = 208,
        y = 63,
        width = 16,
        height = 16
    }
}

barels = {
    {
        spr = 266,
        hitbox = {
            x = 32,
            y = 10,
            width = 16,
            height = 16
        }
    },
    {
        spr = 266,
        hitbox = {
            x = 48,
            y = 128,
            width = 16,
            height = 16
        }
    },
    {
        spr = 266,
        hitbox = {
            x = 112,
            y = 112,
            width = 16,
            height = 16
        }
    },
    {
        spr = 266,
        hitbox = {
            x = 128,
            y = 84,
            width = 16,
            height = 16
        }
    },
}

score = 0
game = false
game_over = false 
robotsprite = 256 + t % 60 // 100
selected_option = 1
local music_playing = false
local music_menu_playing = false

function TIC()
    if game then
        cls()
        map(0, 0, 30, 17, 0, 0)
        spr(finish.spr, finish.hitbox.x, finish.hitbox.y, 7, 1, 0, 0, 2, 2)
        for i, barel in ipairs(barels) do
            spr(barel.spr, barel.hitbox.x, barel.hitbox.y, 7, 1, 0, 0, 2, 2) 
        end
        robotchange()
        move()
        MapLimits()
        hole_floor()
        win()
        enemies()
        showscore()
        restart()
        if not music_playing then
            music_game()
            music_playing = true
            music_menu_playing = false
        end
    elseif game_over then
        cls()
        print("You Lose", 70, 60, 9, false, 2)
        print("Press space to play again", 47, 85, 9, false, 1)
        if keyp(48) then
            reset_game()
        end
    else
        main_menu()
        if not music_menu_playing then
            music_menu()
            music_playing = false 
            music_menu_playing = true
        end
    end 
    t = t + 1 
    
end

function showscore()
    if game then
        print("score " .. score, 5, 2, 5)
    end
end

function move()
    if btnp(3) then 
        robot.hitbox.x = robot.hitbox.x + 16 
    end
    if btnp(2) then 
        robot.hitbox.x = robot.hitbox.x - 16 
    end
    if btnp(1) then 
        robot.hitbox.y = robot.hitbox.y + 16 
    end
    if btnp(0) then 
        robot.hitbox.y = robot.hitbox.y - 16 
    end
end

function restart()
    if not game and keyp(48) then reset() end
end

function MapLimits()
    if robot.hitbox.x >= 228 then robot.hitbox.x = 228 end
    if robot.hitbox.x < 0 then robot.hitbox.x = 0 end
    if robot.hitbox.y < 32 then robot.hitbox.y = 32 end
    if robot.hitbox.y >= 96 then robot.hitbox.y = 96 end
end

function iscoliding(boxA, boxB)
    local intersectionX = boxA.x < (boxB.x + boxB.width) and (boxA.x + boxA.width) > boxB.x
    local intersectionY = boxA.y < (boxB.y + boxB.height) and (boxA.y + boxA.height) > boxB.y
    return intersectionX and intersectionY
end

function win()
    if iscoliding(robot.hitbox, finish.hitbox) then
        score = score + 1
        robot.hitbox.x = 0
        robot.hitbox.y = 64
        sfx(33)
    end
end

function hole_floor()
    if mget(robot.hitbox.x//8 , robot.hitbox.y//8) == 71 then
        game_over = true
        game = false 
        music(-1)
        sfx(32)    
    end
end

function enemies()
    for i, barel in ipairs(barels) do
        if i % 2 == 1 then
            barel.hitbox.y = barel.hitbox.y + 2
                if barel.hitbox.y > 142 then 
                    barel.hitbox.y = 20
                end
        else
            barel.hitbox.y = barel.hitbox.y - 2
            if barel.hitbox.y < 20 then 
                barel.hitbox.y = 142
            end
        end
        if iscoliding(robot.hitbox, barel.hitbox) then
            game_over = true 
            game = false 
            music(-1)
            sfx(32)
        end
    end
end

function robotchange()
    if btnp(3) then
        robotsprite = 256 + t % 60 // 100
    elseif btnp(2) then
        robotsprite = 260 + t % 60 // 100
    elseif btnp(1) then
        robotsprite = 292 + t % 60 // 100
    elseif btnp(0) then
        robotsprite = 288 + t % 60 // 100
    end
    spr(robotsprite, robot.hitbox.x, robot.hitbox.y, 7, 1, 0, 0, 2, 2)
end

function music_game()
    music(0, 0, 1, true)
end

function music_menu()
    music(1, 0, 1, true)
end

function main_menu()
    cls()
    if btnp(0) then
        selected_option = selected_option - 1
        if selected_option < 1 then selected_option = 2 end 
    end
    if btnp(1) then
        selected_option = selected_option + 1
        if selected_option > 2 then selected_option = 1 end 
    end
    if selected_option == 1 then
        print("PLAY", 100, 60, 7)
    else
        print("PLAY", 100, 60, 12)
    end
    
    if selected_option == 2 then
        print("QUIT", 100, 80, 7) 
    else
        print("QUIT", 100, 80, 12) 
    end
    if keyp(50) then
        if selected_option == 1 then
            game = true 
            music_playing = false
            music_menu_playing = false
            cls() 
            reset_game() 
        elseif selected_option == 2 then
            exit() 
        end
    end
end

function reset_game()
    score = 0
    robot.hitbox.x = 0
    robot.hitbox.y = 64
    game_over = false 
    game = true 
    music_game() 
end

