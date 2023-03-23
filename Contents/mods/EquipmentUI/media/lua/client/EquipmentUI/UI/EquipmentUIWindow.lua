require "ISUI/ISPanelJoypad"
local c = require "EquipmentUI/Settings"

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local POPOUT_TEX = getTexture("media/ui/equipmentui/popout.png")
local ATTACH_TEX = getTexture("media/ui/equipmentui/attach.png")
local CLOSE_TEX = getTexture("media/ui/equipmentui/close.png")

local function getLayoutModData(playerObj)
    local modData = playerObj:getModData()["EquipmentUILayout"];
    if not modData then
        modData = {
            isDocked = true,
            isClosed = false
        };
        playerObj:getModData()["EquipmentUILayout"] = modData;
    end
    return modData;
end

EquipmentUIWindow = ISPanelJoypad:derive("EquipmentUIWindow");

function EquipmentUIWindow:new(x, y, inventoryPane, playerNum)
	local o = {};
	o = ISPanelJoypad:new(x, y, c.EQUIPMENT_WIDTH + 12, inventoryPane.parent:getHeight());
	setmetatable(o, self);
    self.__index = self;

    o.inventoryPane = inventoryPane
    o.playerNum = playerNum

	o.char = getSpecificPlayer(playerNum);
	o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
	o.backgroundColor = {r=0, g=0, b=0, a=0.8};

    o.titlebarbkg = getTexture("media/ui/Panel_TitleBar.png");

    local modData = getLayoutModData(o.char);
    o.isDocked = modData.isDocked;
    o.isClosed = modData.isClosed;
    return o;
end

function EquipmentUIWindow:createChildren()
    ISPanelJoypad.createChildren(self);

    local titleBarHeight = self.inventoryPane.parent:titleBarHeight()

    self.scrollView = NotlocScrollView:new(0, titleBarHeight, self.width, self.height - titleBarHeight - 9);
    self.scrollView:initialise();
    self:addChild(self.scrollView);

    self.equipmentUi = EquipmentUI:new(0, 0, c.EQUIPMENT_WIDTH, 5000, self.inventoryPane, self.playerNum);
    self.equipmentUi:initialise()
    self.scrollView:addScrollChild(self.equipmentUi);

    self.popoutButton = ISButton:new(self:getWidth() - 24, 1, 20, titleBarHeight - 2, "", self, self.onPopoutOrAttach);
    self.popoutButton.internal = "POP";
    self.popoutButton.borderColor = {r=0, g=0, b=0, a=0};
    self.popoutButton.backgroundColor = {r=0, g=0, b=0, a=0};
    self.popoutButton:initialise();
    self.popoutButton:instantiate();
    self.popoutButton:setImage(self.isDocked and POPOUT_TEX or ATTACH_TEX);
    self.popoutButton:setAnchorRight(true);
    self.popoutButton:setAnchorTop(true);
    self.popoutButton:setAnchorLeft(false);
    self:addChild(self.popoutButton);

    self.closeButton = ISButton:new(2, 1, 20, titleBarHeight - 2, "", self, self.onClose);
    self.closeButton.internal = "CLOSE";
    self.closeButton.borderColor = {r=0, g=0, b=0, a=0};
    self.closeButton.backgroundColor = {r=0, g=0, b=0, a=0};
    self.closeButton:initialise();
    self.closeButton:instantiate();
    self.closeButton:setImage(CLOSE_TEX);
    self.closeButton:setAnchorRight(false);
    self.closeButton:setAnchorTop(true);
    self.closeButton:setAnchorLeft(true);
    self:addChild(self.closeButton);

    self.closeButton:setVisible(not self.isDocked);

    Events.OnKeyPressed.Add(function(key)
        if key == getCore():getKey("equipment_toggle_window") then
            self:toggleWindow();
        end
    end);

    if self.playerNum == 0 then
		ISLayoutManager.RegisterWindow('equipment_ui_mod', EquipmentUIWindow, self)
	end
end

function EquipmentUIWindow:prerender()
    if self.isDocked and not self.inventoryPane.parent:isVisible() then 
        self:setVisible(false);
        return;
    end

    local titleBarHeight = self.inventoryPane.parent:titleBarHeight()

    local invPage = self.inventoryPane.parent

    self:setWidth(c.EQUIPMENT_WIDTH + 12);
    self.scrollView:setScrollHeight(self.equipmentUi:getHeightForScroll());

    if self.isDocked then
        self:setHeight(invPage:getHeight());
        self:setX(invPage:getX() - self:getWidth() + 1);
        self:setY(invPage:getY());
    end

	ISPanelJoypad.prerender(self)
    
    self:drawTextureScaled(self.titlebarbkg, 2, 1, self:getWidth() - 4, titleBarHeight - 2, 1, 1, 1, 1);
    self:drawRectBorder(0, 0, self:getWidth(), titleBarHeight, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);

    self:drawTextureScaled(self.titlebarbkg, 2, self:getHeight() - 9, self:getWidth() - 4, 9, 1, 1, 1, 1);
    self:drawRectBorder(0, self:getHeight() - 9, self:getWidth(), 9, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);    
end

function EquipmentUIWindow:render()
    ISPanelJoypad.render(self)
end

function EquipmentUIWindow:onInventoryVisibilityChanged(isVisible)
    if not self.isDocked then return; end
    self:setVisible(isVisible and not self.isClosed);
end

function EquipmentUIWindow:onPopoutOrAttach()
    self.isDocked = not self.isDocked;
    self.popoutButton:setImage(self.isDocked and POPOUT_TEX or ATTACH_TEX);
    if not self.isDocked then
        self:setX(self:getX() - 8);
    else
        self:setVisible(self.inventoryPane.parent:isVisible());
    end

    self.closeButton:setVisible(not self.isDocked);

    local modData = getLayoutModData(self.char);
    modData.isDocked = self.isDocked;
end

function EquipmentUIWindow:onClose()
    self.isClosed = true;
    self:setVisible(false);

    local modData = getLayoutModData(self.char);
    modData.isClosed = true;

    self.inventoryPane.parent:bringToTop();
end

function EquipmentUIWindow:toggleWindow()
    if self.isClosed or not self:isVisible() then
        self.isClosed = false;
        if self.isDocked then
            self:setVisible(self.inventoryPane.parent:isVisible());
            if self.inventoryPane.parent:isVisible() then
                self.inventoryPane.parent:uncollapse();
            end
        else
            self:setVisible(true);
        end
    else
        self:onClose();
    end

    local modData = getLayoutModData(self.char);
    modData.isClosed = self.isClosed;
end

function EquipmentUIWindow:onMouseDown(x, y)
    if self.isDocked then return; end
    
    -- if over the title bar, then drag the window
    local titleBarHeight = self.inventoryPane.parent:titleBarHeight()
    if y < titleBarHeight then
        self.dragging = true;
        self.dragX = x;
        self.dragY = y;
        return true
    end

    -- if over the bottom bar, and not docked, then resize the window
    if y > self:getHeight() - 9 then
        self.resizing = true;
        self.dragX = x;
        self.dragY = y;
        return true
    end
end

function EquipmentUIWindow:onMouseUp(x, y)
    self.dragging = false;
    self.resizing = false;
end

function EquipmentUIWindow:onMouseUpOutside(x, y)
    self.dragging = false;
    self.resizing = false;
end

function EquipmentUIWindow:onMouseMove(dx, dy)
    self.toggleElement:bringToTop();
    
    if self.dragging then
        self:setX(self:getX() + dx);
        self:setY(self:getY() + dy);
        return true
    end
   
    if self.resizing then
        local newHeight = self:getHeight() + dy
        if newHeight < 100 then newHeight = 100; end
        self:setHeight(newHeight);
        return true
    end
end

function EquipmentUIWindow:onMouseMoveOutside(dx, dy)
    return self:onMouseMove(dx, dy);
end

function EquipmentUIWindow:RestoreLayout(name, layout)
    ISLayoutManager.DefaultRestoreWindow(self, layout)
end

function EquipmentUIWindow:SaveLayout(name, layout)
    ISLayoutManager.DefaultSaveWindow(self, layout)
end

function EquipmentUIWindow:updateTooltip()
    self.equipmentUi:updateTooltip();
end