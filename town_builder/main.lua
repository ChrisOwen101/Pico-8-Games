poke(0x5F2D, 1)

camera_x = 0
camera_y = 0

crossroad = { x = 0, y = 96 }
vertical_road = { x = 16, y = 96 }
horizontal_road = { x = 32, y = 96 }
turn_left_up = { x = 48, y = 96 }
turn_right_up = { x = 48, y = 112 }
turn_left_down = { x = 64, y = 112 }
turn_right_down = { x = 32, y = 112 }
horiztonal_up = { x = 64, y = 96 }
horiztonal_down = { x = 80, y = 96 }
vertical_left = { x = 96, y = 96 }
vertical_right = { x = 112, y = 96 }
blank = { x = 0, y = 112 }

tiles = { {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {} }

function draw_tile(tile, x, y)
    sspr(tile.x, tile.y, 16, 16, x, y, 8, 8)
end

function choose_road_tile(x, y)
    x = flr(x / 8) + 1
    y = flr(y / 8) + 1

    if tiles[x - 1] and tiles[x - 1][y] == "ROAD" and tiles[x + 1] and tiles[x + 1][y] == "ROAD" and tiles[x] and tiles[x][y - 1] == "ROAD" and tiles[x] and tiles[x][y + 1] == "ROAD" then
        return crossroad
    end

    if tiles[x - 1] and tiles[x - 1][y] == "ROAD" and tiles[x + 1] and tiles[x + 1][y] == "ROAD" and tiles[x] and tiles[x][y - 1] == "ROAD" then
        return horiztonal_up
    end

    if tiles[x - 1] and tiles[x - 1][y] == "ROAD" and tiles[x + 1] and tiles[x + 1][y] == "ROAD" and tiles[x] and tiles[x][y + 1] == "ROAD" then
        return horiztonal_down
    end

    if tiles[x] and tiles[x][y - 1] == "ROAD" and tiles[x] and tiles[x][y + 1] == "ROAD" and tiles[x + 1] and tiles[x + 1][y] == "ROAD" then
        return vertical_right
    end

    if tiles[x] and tiles[x][y - 1] == "ROAD" and tiles[x] and tiles[x][y + 1] == "ROAD" and tiles[x - 1] and tiles[x - 1][y] == "ROAD" then
        return vertical_left
    end

    if tiles[x - 1] and tiles[x - 1][y] == "ROAD" and tiles[x] and tiles[x][y - 1] == "ROAD" then
        return turn_left_up
    end

    if tiles[x + 1] and tiles[x + 1][y] == "ROAD" and tiles[x] and tiles[x][y - 1] == "ROAD" then
        return turn_right_up
    end

    if tiles[x - 1] and tiles[x - 1][y] == "ROAD" and tiles[x] and tiles[x][y + 1] == "ROAD" then
        return turn_left_down
    end

    if tiles[x + 1] and tiles[x + 1][y] == "ROAD" and tiles[x] and tiles[x][y + 1] == "ROAD" then
        return turn_right_down
    end

    if tiles[x - 1] and tiles[x - 1][y] == "ROAD" or tiles[x + 1] and tiles[x + 1][y] == "ROAD" then
        return vertical_road
    end

    if tiles[x] and tiles[x][y - 1] == "ROAD" or tiles[x] and tiles[x][y + 1] == "ROAD" then
        return horizontal_road
    end

    return blank
end

function draw_tile_grid()
    for x = 0, 128, 8 do
        for y = 0, 128, 8 do
            tile_row = tiles[flr(x / 8) + 1]

            if tile_row then
                tile = tile_row[flr(y / 8) + 1]

                if tile and tile == "ROAD" then
                    draw_tile(choose_road_tile(x, y), x, y)
                end
            end
        end
    end
end

function is_mouse_clicked()
    clicked = stat(34) == 1

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

    if is_mouse_clicked() then
        x = flr(stat(32) / 8) + 1
        y = flr(stat(33) / 8) + 1

        if not tiles[x][y] then
            tiles[x][y] = "ROAD"
        end
    end
end

function draw_mouse()
    x = flr(stat(32) / 8) * 8
    y = flr(stat(33) / 8) * 8
    sspr(0, 112, 16, 16, x, y, 8, 8)
end

function _draw()
    cls()

    -- draw the background
    rectfill(-500, -500, 500, 500, 3)

    draw_tile_grid()

    -- draw unfixed items

    -- draw fixed items
    local old_camera_x, old_camera_y = camera_x, camera_y
    camera(0, 0)

    draw_mouse()

    camera(old_camera_x, old_camera_y)
    clicked_this_frame = false
    camera(camera_x, camera_y)
end