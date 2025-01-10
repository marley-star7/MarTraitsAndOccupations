MarTraits = MarTraits or {}

-- These are deactivated by setting nil.
MarTraits.moodleallergiesGood4 = nil
MarTraits.moodleAllergiesGood3 = nil
MarTraits.moodleAllergiesGood2 = nil
MarTraits.moodleAllergiesGood1 = 1.2
MarTraits.moodleAllergiesBad1 = 0.8
MarTraits.moodleAllergiesBad2 = 0.6
MarTraits.moodleAllergiesBad3 = 0.4
MarTraits.moodleAllergiesBad4 = 0.2

-- How much moodle goes up by a tier.
MarTraits.moodleStepAmount = 0.2

-- TODO: add watery eyes.

if getActivatedMods():contains("\\MoodleFramework") == true then
    require ("MF_ISMoodle") -- Moodle Framework requirement
    MF.createMoodle("Allergies") -- Create moodle through framework
    MarTraits.moodleFrameworkActive = true
    print("TraitAllergic: Moodles Initialized!")

    MarTraits.moodleAllergiesB41StyleModList = 
    {
        "\\MOLDIM",
        "\\WHSK_Moodle",
        "\\redrawnmoodles",
    }

    require("MarLibrary")
    local function allergiesMoodleOnCreatePlayer(playerIndex, createdPlayer) --Load data on player creation
        -- Delay it to ensure it runs after Moodle Framework Setup.
        MarLibrary.delayFunc( 
            function(playerIndex, createdPlayer)
                --Set thresholds for the moodle levels - Bad lvls 4, 3, 2, 1 | Good lvls 1, 2, 3, 4
                MF.getMoodle("Allergies", playerIndex):setThresholds(MarTraits.moodleAllergiesBad4,MarTraits.moodleAllergiesBad3,MarTraits.moodleAllergiesBad2,MarTraits.moodleAllergiesBad1,MarTraits.moodleAllergiesGood1,MarTraits.moodleAllergiesGood2,MarTraits.moodleAllergiesGood3,MarTraits.moodleAllergiesGood4)
                local moodle = MF.getMoodle("Allergies", playerIndex)

                -- Make sure allergic moodle doesn't start at full during creation
                if moodle:getValue() == nil or moodle:getValue() > 1 then
                    moodle:setValue(1)
                end

                local good = 1
                local bad = 2
                -- Look for mods with in the list that we will use the old style of traits for.
                for _, modName in pairs(MarTraits.moodleAllergiesB41StyleModList) do
                    if getActivatedMods():contains(modName) then
                        local b41Texture = getTexture("media/ui/Allergies_B41.png")
                        moodle:setPicture(good, 4, b41Texture)
                        moodle:setPicture(good, 3, b41Texture)
                        moodle:setPicture(good, 2, b41Texture)
                        moodle:setPicture(good, 1, b41Texture)
                        moodle:setPicture(bad, 1, b41Texture)
                        moodle:setPicture(bad, 2, b41Texture)
                        moodle:setPicture(bad, 3, b41Texture)
                        moodle:setPicture(bad, 4, b41Texture)
                        break
                    end
                end

            end, 
            0.03
        )
    end

    Events.OnCreatePlayer.Add(allergiesMoodleOnCreatePlayer)
end