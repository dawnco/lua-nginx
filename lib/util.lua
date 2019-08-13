-- author daw
-- date 2019-08-07
local util = {
}

function util.say(...)
    local args = { ... }

    local new = {}
    for key, val in pairs(args) do
        if val then
            table.insert(new, val)
        end
    end

    ngx.say(table.concat(new, " "), "<br>")
end



return util