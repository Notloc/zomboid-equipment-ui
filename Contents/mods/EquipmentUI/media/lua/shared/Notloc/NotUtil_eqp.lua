if not NotUtil then
    NotUtil = {}
end

NotUtil.createVanillaStackFromItem = function(item)
    return {{ ["items"] = {item, item} }}
end
