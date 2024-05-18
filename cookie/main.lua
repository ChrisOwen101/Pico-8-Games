poke(0x5F2D, 1)

money = 0

mouse_down = false
clicked_this_frame = false

plus_one_locations = {}
cookie_locations = { { x = 0, y = 0 } }
auto_clicker_locations = {}

camera_x = -48
camera_y = -48

AUTO_CLICKER_COST = 10

function is_mouse_clicked()
    clicked = stat(34) == 1

    -- if the mouse is over the cookie and the primary button is pressed
    if clicked then
        mouse_down = true
    end

    if not clicked and mouse_down then
        mouse_down = false
        return true
    end

    return false
end

function is_over_cookie(cookie, x, y)
    return x > cookie.x and x < cookie.x + 32 and y > cookie.y and y < cookie.y + 32
end

function do_cookie_click(cookie)
    money = money + 1
    random_x = flr(rnd(32) - 16) + cookie.x + 16
    random_y = flr(rnd(32) - 16) + cookie.y + 16
    add(plus_one_locations, { x = random_x, y = random_y, life = 18 })
end

function _update()
    -- check if the mouse is over the cookie
    if is_mouse_clicked() then
        clicked_this_frame = true

        for i = 1, #cookie_locations do
            cookie = cookie_locations[i]
            x = stat(32) + camera_x
            y = stat(33) + camera_y
            if is_over_cookie(cookie, x, y) then
                do_cookie_click(cookie)
            end
        end
    end

    if btn(0) then
        camera_x = camera_x - 2
    end

    if btn(1) then
        camera_x = camera_x + 2
    end

    if btn(2) then
        camera_y = camera_y - 2
    end

    if btn(3) then
        camera_y = camera_y + 2
    end

    key_pressed = stat(31)
    if key_pressed == "a" and money >= AUTO_CLICKER_COST then
        add(auto_clicker_locations, { x = stat(32), y = stat(33) })
        money = money - AUTO_CLICKER_COST
    end
end

function get_plus_one_color(life_left)
    if life_left > 10 then
        return 7
    elseif life_left > 3 then
        return 6
    else
        return 5
    end
end

function draw_plus_ones()
    for i = 1, #plus_one_locations do
        plus_one_locations[i].life = plus_one_locations[i].life - 1

        if plus_one_locations[i].life <= 0 then
            del(plus_one_locations, i)
        else
            color = get_plus_one_color(plus_one_locations[i].life)
            plus_one_locations[i].y = plus_one_locations[i].y - 1
            print("+1", plus_one_locations[i].x, plus_one_locations[i].y, color)
        end
    end
end

function draw_money()
    print("Money: " .. money, 10, 10, 7)
end

function draw_mouse()
    x = stat(32)
    y = stat(33)
    if clicked_this_frame then
        sspr(112, 17, 16, 32, x, y)
    else
        sspr(0, 17, 16, 32, x, y)
    end
end

function draw_cookies()
    for i = 1, #cookie_locations do
        sspr(64, 0, 16, 16, cookie_locations[i].x, cookie_locations[i].y, 32, 32)
    end
end

function draw_auto_clickers()
    for i = 1, #auto_clicker_locations do
        sspr(0, 17, 16, 32, auto_clicker_locations[i].x, auto_clicker_locations[i].y)
    end
end

function find_closest_cookie(x, y)
    closest_cookie = nil
    closest_distance = 1000000

    for i = 1, #cookie_locations do
        distance = sqrt((cookie_locations[i].x - x) ^ 2 + (cookie_locations[i].y - y) ^ 2)
        if distance < closest_distance then
            closest_cookie = cookie_locations[i]
            closest_distance = distance
        end
    end

    return closest_cookie
end

function automate_auto_clicker()
    for i = 1, #auto_clicker_locations do
        clicker = auto_clicker_locations[i]

        if clicker["cookie"] == nil then
            clicker["cookie"] = find_closest_cookie(clicker.x, clicker.y)
        end

        -- move towards the cookie
        if clicker["cookie"] then
            aim_x = clicker["cookie"].x + 12
            aim_y = clicker["cookie"].y + 12

            if clicker.x < aim_x then
                clicker.x = clicker.x + 1
            elseif clicker.x > aim_x then
                clicker.x = clicker.x - 1
            end

            if clicker.y < aim_y then
                clicker.y = clicker.y + 1
            elseif clicker.y > aim_y then
                clicker.y = clicker.y - 1
            end
        end

        -- click the cookie
        if flr(rnd(30)) == 1 then
            if clicker["cookie"] and is_over_cookie(clicker["cookie"], clicker.x, clicker.y) then
                do_cookie_click(clicker["cookie"])
            end
        end
    end
end

function draw_buy_auto_clicker_button()
    if money >= AUTO_CLICKER_COST then
        print("Buy Auto Clicker (a)", 10, 120, 7)
    end
end

function _draw()
    cls()

    -- draw the background
    rectfill(-500, -500, 500, 500, 1)

    -- draw unfixed items
    draw_cookies()
    draw_plus_ones()
    draw_auto_clickers()
    automate_auto_clicker()

    -- draw fixed items
    local old_camera_x, old_camera_y = camera_x, camera_y
    camera(0, 0)

    draw_mouse()
    draw_money()
    draw_buy_auto_clicker_button()

    camera(old_camera_x, old_camera_y)

    clicked_this_frame = false
    camera(camera_x, camera_y)
end