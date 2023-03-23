require "ISUI/ISUIElement"

NotlocScrollView = ISUIElement:derive("NotlocScrollView");

function NotlocScrollView:new(x, y, w, h)
	local o = {};
	o = ISUIElement:new(x, y, w, h);
	setmetatable(o, self);
    self.__index = self;

    o:setAnchorLeft(true);
    o:setAnchorRight(true);
    o:setAnchorTop(true);
    o:setAnchorBottom(true);

    o.scrollChildren = {};
    o.lastY = 0;

    return o;
end

function NotlocScrollView:createChildren()
    ISUIElement.createChildren(self);
    self:addScrollBars();
end

function NotlocScrollView:addScrollChild(child)
    self:addChild(child);
    table.insert(self.scrollChildren, child);
end

function NotlocScrollView:prerender()
    self:setStencilRect(0, 0, self.width, self.height);
    self:updateScrollbars();

    local deltaY = self:getYScroll() - self.lastY
    for _, child in pairs(self.scrollChildren) do
        child:setY(child:getY() + deltaY)
    end
    self.lastY = self:getYScroll()

	ISUIElement.prerender(self)
end

function NotlocScrollView:render()
    ISUIElement.render(self);
    self:clearStencilRect();
end

function NotlocScrollView:onMouseWheel(del)
    --if self.inventoryPage.isCollapsed then return false; end
	self:setYScroll(self:getYScroll() - (del*12));
    return true;
end

