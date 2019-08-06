util = {
}

function util.say(...)
    local args = { ... }
    ngx.say(table.concat(args, " "), "<br>")
end

return util