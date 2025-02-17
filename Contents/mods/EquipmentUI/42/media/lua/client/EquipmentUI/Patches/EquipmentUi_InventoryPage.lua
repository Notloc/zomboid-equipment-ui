local c = require("EquipmentUI/Settings")
require("InventoryAndLoot") -- I do not remember what this is

local EQUIPMENT_UI_TOGGLE_TEX = nil --getTexture("media/ui/EquipmentUI/equipment_min.png")

local og_createChildren = ISInventoryPage.createChildren
---@diagnostic disable-next-line: duplicate-set-field
function ISInventoryPage:createChildren()
    og_createChildren(self)

    if self.onCharacter then
        self.equipmentUi = EquipmentUIWindow:new(getText("UI_equipment_equipment"), "EquipmentUILayout", 220, self.inventoryPane, EQUIPMENT_UI_TOGGLE_TEX, c, self.player);
        self.equipmentUi:addToInventoryPage(self)

        local playerObj = getSpecificPlayer(self.player)
        local isController = playerObj:getJoypadBind() ~= -1
        self.equipmentUi.isClosed = isController

        local dragRenderer = nil
        if not c.InventoryTetris then
            dragRenderer = EquipmentDragItemRenderer:new(self.equipmentUi, self.inventoryPane, self.player)
            dragRenderer:initialise()
            dragRenderer:addToUIManager()
        end

        self.destroyEquipmentUi = function()
            self.equipmentUi:removeFromUIManager()
            self.equipmentUi.toggleElement:removeFromUIManager()
            if dragRenderer then
                dragRenderer:removeFromUIManager()
            end
        end

        Events.OnPlayerDeath.Add(function(player)
            if not player:isLocalPlayer() or player:getPlayerNum() ~= self.player then
                return
            end
            self.destroyEquipmentUi()
        end);

    end
end

local og_render = ISInventoryPage.prerender
---@diagnostic disable-next-line: duplicate-set-field
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