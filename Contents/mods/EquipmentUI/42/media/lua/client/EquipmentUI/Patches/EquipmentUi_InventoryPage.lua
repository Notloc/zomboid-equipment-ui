require("InventoryAndLoot") -- I do not remember what this is
local c = require("EquipmentUI/Settings")
local SidePanelManager = require("Notloc/UI/SidePanels/SidePanelManager")

local EQUIPMENT_UI_TOGGLE_TEX = getTexture("media/ui/EquipmentUI/equipment_icon.png")

local og_createChildren = ISInventoryPage.createChildren
---@diagnostic disable-next-line: duplicate-set-field
function ISInventoryPage:createChildren()
    og_createChildren(self)

    if self.onCharacter then
        local sidePanelManager = SidePanelManager.getOrCreate(self)

        self.equipmentUi = EquipmentUIWindow:new(getText("UI_equipment_equipment"), "EquipmentUILayout", 220, self.inventoryPane, c, self.player);
        sidePanelManager:addSidePanel(self.equipmentUi, EQUIPMENT_UI_TOGGLE_TEX, {r=1, g=0.8, b=0.5, a=1}, "equipment_toggle_window")

        if not c.InventoryTetris then
            local dragRenderer = EquipmentDragItemRenderer:new(self.equipmentUi, self.inventoryPane, self.player)
            dragRenderer:initialise()
            dragRenderer:addToUIManager()

            local og_removeFromUIManager = self.removeFromUIManager
            self.removeFromUIManager = function(self)
                og_removeFromUIManager(self)
                dragRenderer:removeFromUIManager()
            end
        end
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
---@diagnostic disable-next-line: duplicate-set-field
function ISInventoryPage:onMouseDownOutside(x, y)
    local wasPin = self.pin
    if self.equipmentUi and self.equipmentUi.isDocked and self:isMouseOverEquipmentUi() then
        self.pin = true
    end 
    local ret =  og_onMouseDownOutside(self, x, y)
    self.pin = wasPin
    return ret
end

local og_onRightMouseDownOutside = ISInventoryPage.onRightMouseDownOutside
---@diagnostic disable-next-line: duplicate-set-field
function ISInventoryPage:onRightMouseDownOutside(x, y)
    local wasPin = self.pin
    if self.equipmentUi and self.equipmentUi.isDocked and self:isMouseOverEquipmentUi() then
        self.pin = true
    end 
    local ret =  og_onRightMouseDownOutside(self, x, y)
    self.pin = wasPin
    return ret
end

local og_onMouseMoveOutside = ISInventoryPage.onMouseMoveOutside
---@diagnostic disable-next-line: duplicate-set-field
function ISInventoryPage:onMouseMoveOutside(dx, dy)
    if DragAndDrop.isDragging() and self.isCollapsed then
        self.isCollapsed = false;
        if isClient() and not self.onCharacter then
            self.inventoryPane.inventory:requestSync();
        end
        self:clearMaxDrawHeight();
        self.collapseCounter = 0;
    end

	local wasPin = self.pin
    if self.equipmentUi and self.equipmentUi.isDocked and self:isMouseOverEquipmentUi() then
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

local og_setVisible = ISInventoryPage.setVisible
function ISInventoryPage:setVisible(visible)
    og_setVisible(self, visible)
    if self.equipmentUi then
        self.equipmentUi:setVisible(visible and not self.equipmentUi.isClosed)
    end
end