-- Cleanup when switching inputs
Events.OnGameBoot.Add(function()
    local og_removeInventoryUI = removeInventoryUI
    function removeInventoryUI(id)
        local data = getPlayerData(id);
        if data then
            data.playerInventory:destroyEquipmentUi()
        end
        og_removeInventoryUI(id)
    end
end)

-- Toggle the UI when pressing the select button on the controller
local og_ISInventoryPage_onJoypadDown = ISInventoryPage.onJoypadDown
function ISInventoryPage:onJoypadDown(button)
    og_ISInventoryPage_onJoypadDown(self, button)

    local playerObj = getSpecificPlayer(self.player) 
    if button == Joypad.Back and self.equipmentUi then
        self:toggleEquipmentUIForController()
    end
end

-- Resize UIs when toggling the equipment UI
function ISInventoryPage:toggleEquipmentUIForController()
    self.equipmentUi.isClosed = not self.equipmentUi.isClosed
    self.equipmentUi:setVisible(not self.equipmentUi.isClosed)

    local inventoryPage = getPlayerInventory(self.player)
    local lootPage = getPlayerLoot(self.player)

    local x = getPlayerScreenLeft(self.player)
    local w = getPlayerScreenWidth(self.player)

    if not self.equipmentUi.isClosed then
        x = x + self.equipmentUi:getWidth()
        w = w - self.equipmentUi:getWidth()
    end

    inventoryPage:setWidth(w/2)
    inventoryPage:setX(x)
    lootPage:setWidth(w/2)
    lootPage:setX(x + w/2)
end

--  Handle switching focus between the inventories and equipment UIs
local og_ISInventoryPage_onJoypadDirLeft = ISInventoryPage.onJoypadDirLeft
function ISInventoryPage:onJoypadDirLeft()
    og_ISInventoryPage_onJoypadDirLeft(self)
    if self == getPlayerInventory(self.player) then
        if self.equipmentUi:isVisible() then
            setJoypadFocus(self.player, self.equipmentUi);
        end
    end
end

local og_ISInventoryPage_onJoypadDirRight = ISInventoryPage.onJoypadDirRight
function ISInventoryPage:onJoypadDirRight()
    og_ISInventoryPage_onJoypadDirRight(self)
    if self == getPlayerLoot(self.player) then
        local equipmentUi = getPlayerInventory(self.player).equipmentUi
        if equipmentUi:isVisible() then
            setJoypadFocus(self.player, equipmentUi);
        end
    end
end

