require "ISUI/ISUIElement"

function ISUIElement:drawTextureCenteredAndSquare(texture, x, y, targetSizePx, alpha, r, g, b)
    local texW = texture:getWidth()
    local texH = texture:getHeight()

    local largestDimension = math.max(texW, texH)
    local scaler = targetSizePx / largestDimension
    
    local ratioX = texW / largestDimension
    local ratioY = texH / largestDimension

    texW = texW * scaler
    texH = texH * scaler

    local off = math.max(texW, texH)

    local x2 = x - off / 2 * ratioX
    x2 = math.floor(x2)
    
    local y2 = y - off / 2 * ratioY
    y2 = math.floor(y2)



    self:drawTextureScaledUniform(texture, x2, y2, scaler, alpha, r, g, b);
end
