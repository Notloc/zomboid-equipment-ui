local c = require ("EquipmentUI/Settings")
local SidePanel = require("Notloc/UI/SidePanels/SidePanel")

EquipmentUIWindow = SidePanel:derive("EquipmentUIWindow");

function EquipmentUIWindow:createChildren()
    SidePanel.createChildren(self);

    local titleBarHeight = self.inventoryPane.parent:titleBarHeight()

    self.scrollView = NotlocScrollView:new(0, titleBarHeight, self.width, self.height - titleBarHeight - 9);
    self.scrollView:initialise();
    self.scrollView.scrollSensitivity = 24;
    self:addChild(self.scrollView);

    self.equipmentUi = EquipmentUI:new(0, 0, self.width, 5000, self.inventoryPane, self.playerNum);
    self.equipmentUi:initialise()
    self.scrollView:addScrollChild(self.equipmentUi);

    NotlocControllerNode
        :injectControllerNode(self, true)
        :setChildrenNodeProvider(self.equipmentUi.getControllerNodes, self.equipmentUi)
end

function EquipmentUIWindow:prerender()
    SidePanel.prerender(self);

    self.scrollView:setScrollHeight(self.equipmentUi:getHeightForScroll());

    local hasScrollBar = self.scrollView:isVScrollBarVisible()
    local xOffset = hasScrollBar and 0 or 5
    self.equipmentUi:setX(xOffset);
end

function EquipmentUIWindow:render()
    SidePanel.render(self)
    if self.joyfocus then
        self:drawRectBorder(0, 0, self:getWidth(), self:getHeight(), 0.4, 0.2, 1.0, 1.0);
        self:drawRectBorder(1, 1, self:getWidth()-2, self:getHeight()-2, 0.4, 0.2, 1.0, 1.0);
    end
end

function EquipmentUIWindow:updateTooltip()
    self.equipmentUi:updateTooltip();
end

-- Controller Window focus handling
function EquipmentUIWindow:onJoypadDirLeft(joypadData)
    setJoypadFocus(self.playerNum, getPlayerLoot(self.playerNum));
end

function EquipmentUIWindow:onJoypadDirRight(joypadData)
    setJoypadFocus(self.playerNum, getPlayerInventory(self.playerNum));
end

function EquipmentUIWindow:onJoypadDown(button)
    -- Makes the ui close
    if button == Joypad.YButton then
        setJoypadFocus(self.playerNum, nil);
        getPlayerInventory(self.playerNum):onLoseJoypadFocus(nil)
    end

    if button == c.TOGGLE_UI_CONTROLLER_BIND then
        local inv = getPlayerInventory(self.playerNum)
        inv:toggleEquipmentUIForController();
        setJoypadFocus(self.playerNum, inv);
    end

    if c.InventoryTetris then
        if button == Joypad.LBumper then
            setJoypadFocus(self.playerNum, getPlayerInventory(self.playerNum));
        end
        if button == Joypad.RBumper then
            setJoypadFocus(self.playerNum, getPlayerLoot(self.playerNum));
        end
    end
end
