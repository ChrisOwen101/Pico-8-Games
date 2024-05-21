poke(0x5F2D, 1)

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

function _update()
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

function _draw()
    cls()

    -- draw the background
    rectfill(-500, -500, 500, 500, 1)

    -- draw unfixed items

    -- draw fixed items
    local old_camera_x, old_camera_y = camera_x, camera_y
    camera(0, 0)

    draw_mouse()

    camera(old_camera_x, old_camera_y)
    clicked_this_frame = false
    camera(camera_x, camera_y)
end