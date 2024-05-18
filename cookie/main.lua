poke(0x5F2D, 1)

function _update()
end

function _draw()
    cls()

    -- draw the background
    rectfill(0, 0, 127, 127, 1)

    x = stat(32)
    y = stat(33)

    -- draw the cookie
    sspr(64, 0, 16, 16, 32, 32, 32, 32)

    -- draw the mouse
    sspr(0, 17, 16, 32, x, y)
end