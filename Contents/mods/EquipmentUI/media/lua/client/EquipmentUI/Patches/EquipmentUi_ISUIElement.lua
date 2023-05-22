require "ISUI/ISUIElement"

function ISUIElement:drawTextureCenteredAndSquare(texture, x, y, targetSizePixels, alpha, r, g, b)
    local texW = texture:getWidth()
    local texH = texture:getHeight()

    local largestDimension = math.max(texW, texH)
    local scaler = targetSizePixels / largestDimension
    
    largestDimension = largestDimension * scaler
    texW = texW * scaler
    texH = texH * scaler

    local x2 = x - (largestDimension + texW) * 0.25
    local y2 = y - (largestDimension + texH) * 0.25
    self:drawTextureScaledUniform(texture, x2, y2, scaler, alpha, r, g, b);
end

ISUIElement.isMouseOverAnyUI = function()
    local mouseOverUi = false
    local mx, my = getMouseX(), getMouseY()
    local allUi = UIManager.getUI()
    for i = 0, allUi:size() - 1 do
        local ui = allUi:get(i)
        if ui:isPointOver(mx, my) then
            mouseOverUi = true
            break
        end
    end
    return mouseOverUi
end