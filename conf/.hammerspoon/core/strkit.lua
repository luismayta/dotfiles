strkit = {}
function strkit.firstUp(str)
    return (string.lower(str):gsub("^%l", string.upper))
end
return strkit