local c = require "EquipmentUI/Settings"

local og_createChildren = ISInventoryPage.createChildren
function ISInventoryPage:createChildren()  
    og_createChildren(self)
    
    if self.onCharacter then
        self.equipmentUi = EquipmentUIWindow:new(0, 0, self.inventoryPane, self.player);
        self.equipmentUi:initialise()
        self.equipmentUi:addToUIManager()

        local toggleButton = EquipmentUIToggle:new(self.equipmentUi, self.inventoryPane)
        toggleButton:initialise()
        toggleButton:addToUIManager()

        if not InventoryTetris then
            local dragRenderer = EquipmentDragItemRenderer:new(self.equipmentUi, self.inventoryPane)
            dragRenderer:initialise()
            dragRenderer:addToUIManager()
        end
    end
end

local og_render = ISInventoryPage.prerender
function ISInventoryPage:prerender()
    og_render(self)

    if self.equipmentUi and not self.equipmentUi.isClosed then
        self.equipmentUi:onInventoryVisibilityChanged(self.pin or not self.isCollapsed);
    end
end

function ISInventoryPage:isMouseOverEquipmentUi()
    if(self.equipmentUi and self.equipmentUi.playerNum == 0) then
        local mouseX = getMouseX()
        local mouseY = getMouseY()
        if mouseX >= self.equipmentUi:getAbsoluteX() and mouseX <= self.equipmentUi:getAbsoluteX() + self.equipmentUi:getWidth() and
            mouseY >= self.equipmentUi:getAbsoluteY() and mouseY <= self.equipmentUi:getAbsoluteY() + self.equipmentUi:getHeight() then
            return true
        end

        if mouseX >= self.equipmentUi.toggleElement:getAbsoluteX() and mouseX <= self.equipmentUi.toggleElement:getAbsoluteX() + self.equipmentUi.toggleElement:getWidth() and
            mouseY >= self.equipmentUi.toggleElement:getAbsoluteY() and mouseY <= self.equipmentUi.toggleElement:getAbsoluteY() + self.equipmentUi.toggleElement:getHeight() then
            return true
        end
    end
    return false
end

local og_onMouseDownOutside = ISInventoryPage.onMouseDownOutside
function ISInventoryPage:onMouseDownOutside(x, y)
    local wasPin = self.pin
    if self:isMouseOverEquipmentUi() then
        self.pin = true
    end 
    local ret =  og_onMouseDownOutside(self, x, y)
    self.pin = wasPin
    return ret
end

local og_onRightMouseDownOutside = ISInventoryPage.onRightMouseDownOutside
function ISInventoryPage:onRightMouseDownOutside(x, y)
    local wasPin = self.pin
    if self:isMouseOverEquipmentUi() then
        self.pin = true
    end 
    local ret =  og_onRightMouseDownOutside(self, x, y)
    self.pin = wasPin
    return ret
end

local og_onMouseMoveOutside = ISInventoryPage.onMouseMoveOutside
function ISInventoryPage:onMouseMoveOutside(dx, dy)
	local wasPin = self.pin
    if self:isMouseOverEquipmentUi() then
        self.pin = true
    end
    local ret = og_onMouseMoveOutside(self, dx, dy)
    self.pin = wasPin
    return ret
end

function ISInventoryPage:uncollapse()
    self.collapseCounter = 0;
    self.isCollapsed = false;
    self:clearMaxDrawHeight();
end