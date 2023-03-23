-- Order is important here, the first slot appears on top of the others in the ui
-- It looks nicer to have the outermost layer of clothing on top
return {
    {
        name = "Head",
        position = { x = 44, y = 4 },
        bodyLocations = { "FullTop", "FullHat", "Hat", "FullHelmet", "Head", "Wig", "Scarf", "Neck"}
    },
    {
        name = "Face",
        position = { x = 100, y = 16 },
        bodyLocations = { "SpecialMask", "MaskFull", "MaskEyes", "Mask", "Pupils", "Eyes", "RightEye", "LeftEye"}
    },
    {
        name = "Torso",
        position = { x = 44, y = 58 },
        bodyLocations = { "FullSuit", "FullSuitHead", "JacketSuit", "Jacket_Down", "JacketHat_Bulky", "Jacket_Bulky", "JacketHat", "Jacket", "BathRobe", "Boilersuit", "SweaterHat", "Sweater", "Dress", "Shirt", "ShortSleeveShirt", "Tshirt", "TankTop", "UnderwearTop", "Underwear"}
    },
    {
        name = "Vest",
        position = { x = 106, y = 72 },
        bodyLocations = { "SMUIJumpsuitPlus", "SMUITorsoRigPlus", "SMUIWebbingPlus", "TorsoRigPlus2", "TorsoRig", "TorsoRig2", "TorsoExtraVest", "TorsoExtraPlus1", "RifleSling", "AmmoStrap", "TorsoExtra"}
    },
    {
        name = "Back",
        position = { x = -14, y = 16 },
        bodyLocations = {"Back"},
        --scale = 1
    },
    {
        name = "Waist",
        position = { x = 44, y = 128 },
        bodyLocations = { "waistbagsComplete", "waistbags", "waistbagsf", "FannyPackBack", "FannyPackFront", "SpecialBelt", "BeltExtraHL", "BeltExtra", "Belt420", "Belt419", "Belt", "Tail"}
    },
    {
        name = "Left Hand",
        position = { x = 100, y = 206 },
        bodyLocations = { "Hands", "SMUIGlovesPlus", "LeftWrist", "Left_RingFinger", "Left_MiddleFinger" }
    },
    {
        name = "Right Hand",
        position = { x = -14, y = 206 },
        bodyLocations = { "Hands", "SMUIGlovesPlus", "RightWrist", "Right_RingFinger", "Right_MiddleFinger" }
    },
    {
        name = "Jewelry",
        position = { x = -20, y = 72 },
        bodyLocations = { "Necklace", "Necklace_Long", "BellyButton", "Nose", "Ears", "EarTop" }
    },
    {
        name = "Legs",
        position = { x = 44, y = 202 },
        bodyLocations = { "Kneepads", "ShinPlateRight", "ShinPlateLeft", "ThighRight" ,"ThighLeft", "Pants", "Skirt", "Legs1", "LowerBody", "UnderwearExtra2", "UnderwearExtra1", "UnderwearBottom"}
    },
    {
        name = "Feet",
        position = { x = 44, y = 272 },
        bodyLocations = { "Shoes", "SMUIBootsPlus", "Socks"}
    }
}
