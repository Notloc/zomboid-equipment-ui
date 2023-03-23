require "EquipmentUI/Settings"

if not EQUIPMENT_UI_MOD_OPTIONS then
    EQUIPMENT_UI_MOD_OPTIONS = {
        options = {
            EQUIPMENT_UI_SCALE_INDEX = 2,
        },
        names = {
            EQUIPMENT_UI_SCALE_INDEX = "UI_equipment_options_scale",
        },
        mod_id = "EQUIPMENT_UI",
        mod_shortname = "Equipment UI",
    }
end

if ModOptions and ModOptions.getInstance then
    local settings = ModOptions:getInstance(EQUIPMENT_UI_MOD_OPTIONS)
    ModOptions:loadFile() -- Load the mod options file right away
    
    local uiScale = settings:getData("EQUIPMENT_UI_SCALE_INDEX")
    uiScale[1] = getText("0.5x")
    uiScale[2] = getText("1x")
    uiScale[3] = getText("1.5x")
    uiScale[4] = getText("2x")
    uiScale[5] = getText("2.5x")
    uiScale[6] = getText("3x")
    uiScale[7] = getText("3.5x")
    uiScale[8] = getText("4x")

    function uiScale:OnApplyInGame(val)
        EQUIPMENT_UI_MOD_OPTIONS.options.EQUIPMENT_UI_SCALE_INDEX = val
        EQUIPMENT_UI_SETTINGS:applyScale(val * 0.5)
    end

    EQUIPMENT_UI_SETTINGS:applyScale(EQUIPMENT_UI_MOD_OPTIONS.options.EQUIPMENT_UI_SCALE_INDEX * 0.5)

end