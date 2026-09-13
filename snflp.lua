local input = {
    { "Ele", SOURCE }
}

local output = { "SnapOut" }

local cfg = {
    dz_gv = 0, dz_val = 5,
    ex_gv = 0, ex_val = 25,
    rt_gv = 0, rt_val = 60,
    sat_gv = 0, sat_val = 60
}

local ok, data = pcall(dofile, "/SCRIPTS/CONFIG/snap_cfg.lua")
if ok and data then
    cfg.dz_gv  = tonumber(data.dz_gv)  or 0
    cfg.dz_val = tonumber(data.dz_val) or 5
    cfg.ex_gv  = tonumber(data.ex_gv)  or 0
    cfg.ex_val = tonumber(data.ex_val) or 25
    cfg.rt_gv  = tonumber(data.rt_gv)  or 0
    cfg.rt_val = tonumber(data.rt_val) or 60
    cfg.sat_gv = tonumber(data.sat_gv) or 0
    cfg.sat_val = tonumber(data.sat_val) or 60
end

local function run(ele_val)
    local fm = getFlightMode() or 0

    local function getVal(gv_idx, val_fixe)
        if gv_idx > 0 then
            local val = model.getGlobalVariable(gv_idx - 1, fm)
            if not val then val = model.getGlobalVariable(gv_idx - 1, 0) end
            return tonumber(val) or val_fixe
        else
            return val_fixe
        end
    end

    local deadzone = getVal(cfg.dz_gv, cfg.dz_val)
    local expo = getVal(cfg.ex_gv, cfg.ex_val)
    local ratio = getVal(cfg.rt_gv, cfg.rt_val)
    local saturation = getVal(cfg.sat_gv, cfg.sat_val)

    if not ele_val then return 0 end

    -- 1. Entrée brute de la profondeur convertie en pourcentage de manche brut [0, 100]
    local x_raw = (ele_val * 100) / 1024
    local sign = (x_raw >= 0) and 1 or -1
    local x = math.abs(x_raw)

    if saturation <= deadzone then saturation = deadzone + 1 end

    -- 2. Mappage de la course utile
    local val = 0
    if x <= deadzone then
        val = 0
    elseif x >= saturation then
        val = 100
    else
        val = ((x - deadzone) / (saturation - deadzone)) * 100
    end

    -- 3. Application de l'expo inverse (fonction logarithmique : agressif en bas, doux en haut)
    local norm = val / 100
    local shaped = norm
    if expo > 0 then
        local k = 9 * (expo / 100)
        shaped = (math.log(1 + k * norm) / math.log(1 + k)) * 100
    elseif expo < 0 then
        local e = math.abs(expo) / 100
        shaped = (norm ^ (1 + e * 2)) * 100
    else
        shaped = norm * 100
    end

    -- 4. Application du ratio global d'amplitude de la gouverne
    local final_val = shaped * (ratio / 100)

    -- Réapplication du signe de la profondeur
    final_val = final_val * sign

    -- 5. Retour de la valeur finale convertie pour EdgeTX (-1024 à 1024)
    return math.floor((final_val * 1024) / 100)
end

return { input = input, output = output, run = run }
