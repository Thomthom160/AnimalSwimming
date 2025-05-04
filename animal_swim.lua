local isPlayerAnimal = false

local function HandleAnimalSwim()
    print("^6Debug^7: ^3Animal Swim ^2module ^4loaded")

    CreateThread(function()
        while isPlayerAnimal do
            Wait(200)

            SetPedDiesInWater(cache.ped, false)
            SetPedDiesInstantlyInWater(cache.ped, false)

            if IsEntityInWater(cache.ped) and not IsPedInAnyVehicle(cache.ped, false) then
                SetPedCanRagdoll(cache.ped, false)

                local maxHealth = GetEntityMaxHealth(cache.ped)
                if GetEntityHealth(cache.ped) < maxHealth then
                    SetEntityHealth(cache.ped, maxHealth)
                end

                local submergedLevel = GetEntitySubmergedLevel(cache.ped)
                local _, waterHeight = GetWaterHeight(cache.coords.x, cache.coords.y, cache.coords.z)
                local waterDepth = waterHeight - cache.coords.z

                if submergedLevel > 0.25 then
                    if waterDepth <= 0.5 then
                        ApplyForceToEntity(cache.ped, 1, 0.0, 0.0, 0.6, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                    else
                        local force = math.min(0.4 * (submergedLevel - 0.25), 0.2)
                        ApplyForceToEntity(cache.ped, 1, 0.0, 0.0, force, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                    end

                    if cache.coords.z > waterHeight + 0.1 then
                        ApplyForceToEntity(cache.ped, 1, 0.0, 0.0, -0.1, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                    end

                    if cache.coords.z < waterHeight - 0.1 then
                        ApplyForceToEntity(cache.ped, 1, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
                    end

                    local currentRotation = GetEntityRotation(cache.ped, 2)
                    SetEntityRotation(cache.ped, currentRotation.x + 0.2, currentRotation.y, currentRotation.z, 2, true)
                end
            else
                SetPedCanRagdoll(cache.ped, true)
            end
        end
    end)
end


lib.onCache('ped', function(val, oldVal)
    Wait(3000)
    if GetPedType(val) == 28 then
        isPlayerAnimal = true
        HandleAnimalSwim()
    else
        isPlayerAnimal = false
    end
end)