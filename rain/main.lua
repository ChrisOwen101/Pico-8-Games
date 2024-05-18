poke(0x5F2D, 1)

stamps = {}

function fall()
    for i = 1, #stamps do
        random_distance = flr(rnd(3))
        windows_height = 122

        if stamps[i][2] < windows_height then
            stamps[i][2] = stamps[i][2] + random_distance
        else
            stamps[i][2] = 122
        end
    end
end

function _update()
    x = stat(32)
    y = stat(33)

    button = stat(34)
    if button == 1 then
        add(stamps, { x, y })
    end

    fall()
end

function _draw()
    cls()

    -- draw the background
    rectfill(0, 0, 127, 127, 1)

    x = stat(32)
    y = stat(33)

    for i = 1, #stamps do
        spr(1, stamps[i][1], stamps[i][2])
    end
end