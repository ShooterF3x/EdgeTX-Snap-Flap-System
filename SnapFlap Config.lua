local gv_list = {"--", "GV1", "GV2", "GV3", "GV4", "GV5", "GV6", "GV7", "GV8", "GV9"}

local cfg = {
    dz_gv = 0, dz_val = 5,
    ex_gv = 0, ex_val = 25,
    rt_gv = 0, rt_val = 60,
    sat_gv = 0, sat_val = 60
}

local current_field = 1
local max_fields = 8
local is_editing = false

local function loadConfig()
    local ok, loaded = pcall(dofile, "/SCRIPTS/CONFIG/snap_cfg.lua")
    if ok and loaded then
        cfg.dz_gv  = tonumber(loaded.dz_gv)  or 0
        cfg.dz_val = tonumber(loaded.dz_val) or 5
        cfg.ex_gv  = tonumber(loaded.ex_gv)  or 0
        cfg.ex_val = tonumber(loaded.ex_val) or 25
        cfg.rt_gv  = tonumber(loaded.rt_gv)  or 0
        cfg.rt_val = tonumber(loaded.rt_val) or 60
        cfg.sat_gv = tonumber(loaded.sat_gv)  or 0
        cfg.sat_val = tonumber(loaded.sat_val) or 60
    end
end

local function saveConfig()
    local f = io.open("/SCRIPTS/CONFIG/snap_cfg.lua", "w")
    if f then
        io.write(f, "return {\n")
        io.write(f, "  dz_gv = " .. cfg.dz_gv .. ", dz_val = " .. cfg.dz_val .. ",\n")
        io.write(f, "  ex_gv = " .. cfg.ex_gv .. ", ex_val = " .. cfg.ex_val .. ",\n")
        io.write(f, "  rt_gv = " .. cfg.rt_gv .. ", rt_val = " .. cfg.rt_val .. ",\n")
        io.write(f, "  sat_gv = " .. cfg.sat_gv .. ", sat_val = " .. cfg.sat_val .. ",\n")
        io.write(f, "}\n")
        io.close(f)
        return true
    else
        return false
    end
end

local function init()
    loadConfig()
end

local function run(event)
    if event == EVT_EXIT_BREAK then
        saveConfig()
        return 1
    end

    local fm_num, fm_txt = getFlightMode()
    local fm = fm_num or 0

    if event == EVT_ENTER_BREAK then
        is_editing = not is_editing
        if not is_editing then
            saveConfig()
        end
    end

    local function getVal(gv_idx, val_fixe)
        if gv_idx > 0 then
            local val = model.getGlobalVariable(gv_idx - 1, fm)
            if not val then val = model.getGlobalVariable(gv_idx - 1, 0) end
            return tonumber(val) or val_fixe
        else
            return val_fixe
        end
    end

    local function setVal(gv_idx, new_val)
        if gv_idx > 0 then
            model.setGlobalVariable(gv_idx - 1, fm, new_val)
        else
            if current_field == 1 then cfg.dz_val = new_val
            elseif current_field == 3 then cfg.ex_val = new_val
            elseif current_field == 5 then cfg.rt_val = new_val
            elseif current_field == 7 then cfg.sat_val = new_val
            end
        end
        saveConfig()
    end

    local dz_val  = getVal(cfg.dz_gv, cfg.dz_val)
    local ex_val  = getVal(cfg.ex_gv, cfg.ex_val)
    local rt_val  = getVal(cfg.rt_gv, cfg.rt_val)
    local sat_val = getVal(cfg.sat_gv, cfg.sat_val)

    if event == EVT_ROT_RIGHT or event == EVT_PLUS_FIRST then
        if not is_editing then
            current_field = current_field + 1
            if current_field > max_fields then current_field = 1 end
        else
            if current_field == 1 then 
                setVal(cfg.dz_gv, math.min(30, dz_val + 1))
            elseif current_field == 2 then 
                cfg.dz_gv = math.min(9, cfg.dz_gv + 1) -- Limite max GV9 (index 9)
                saveConfig()
            elseif current_field == 3 then 
                setVal(cfg.ex_gv, math.min(100, ex_val + 5))
            elseif current_field == 4 then 
                cfg.ex_gv = math.min(9, cfg.ex_gv + 1)
                saveConfig()
            elseif current_field == 5 then 
                setVal(cfg.rt_gv, math.min(100, rt_val + 5))
            elseif current_field == 6 then 
                cfg.rt_gv = math.min(9, cfg.rt_gv + 1)
                saveConfig()
            elseif current_field == 7 then 
                setVal(cfg.sat_gv, math.min(100, sat_val + 5))
            elseif current_field == 8 then 
                cfg.sat_gv = math.min(9, cfg.sat_gv + 1)
                saveConfig()
            end
        end
    elseif event == EVT_ROT_LEFT or event == EVT_MINUS_FIRST then
        if not is_editing then
            current_field = current_field - 1
            if current_field < 1 then current_field = max_fields end
        else
            if current_field == 1 then 
                setVal(cfg.dz_gv, math.max(0, dz_val - 1))
            elseif current_field == 2 then 
                cfg.dz_gv = math.max(0, cfg.dz_gv - 1)
                saveConfig()
            elseif current_field == 3 then 
                setVal(cfg.ex_gv, math.max(-100, ex_val - 5))
            elseif current_field == 4 then 
                cfg.ex_gv = math.max(0, cfg.ex_gv - 1)
                saveConfig()
            elseif current_field == 5 then 
                setVal(cfg.rt_gv, math.max(0, rt_val - 5))
            elseif current_field == 6 then 
                cfg.rt_gv = math.max(0, cfg.rt_gv - 1)
                saveConfig()
            elseif current_field == 7 then 
                setVal(cfg.sat_gv, math.max(0, sat_val - 5))
            elseif current_field == 8 then 
                cfg.sat_gv = math.max(0, cfg.sat_gv - 1)
                saveConfig()
            end
        end
    end

    lcd.clear()

    -- En-tête coloré
    lcd.drawFilledRectangle(0, 0, 480, 36, lcd.RGB(41, 128, 185))
    local phase_label = (fm_txt and fm_txt ~= "") and fm_txt or ("FM" .. fm)
    lcd.drawText(10, 8, "=== CONFIG SNAP-FLAP ===", WHITE)
    lcd.drawText(330, 8, "Phase: " .. phase_label, YELLOW)

    local function getFieldStyle(field_idx)
        if current_field == field_idx then
            if is_editing then
                return (math.floor(getTime() / 30) % 2 == 0) and ORANGE or 0
            else
                return BLUE
            end
        end
        return 0
    end

    -- Rafraîchissement des valeurs
    dz_val  = getVal(cfg.dz_gv, cfg.dz_val)
    ex_val  = getVal(cfg.ex_gv, cfg.ex_val)
    rt_val  = getVal(cfg.rt_gv, cfg.rt_val)
    sat_val = getVal(cfg.sat_gv, cfg.sat_val)

    local function drawParamLine(y, label, val_str, gv_str, val_idx, gv_idx)
        local is_selected = (current_field == val_idx or current_field == gv_idx)
        if is_selected then
            lcd.drawFilledRectangle(5, y - 4, 280, 28, lcd.RGB(170, 185, 200))
        end

        lcd.drawText(10, y, label, 0)
        lcd.drawText(150, y, val_str, getFieldStyle(val_idx))
        lcd.drawText(230, y, "[" .. gv_str .. "]", getFieldStyle(gv_idx))
    end

    drawParamLine(50,  "Zone Morte:", dz_val .. "%",  gv_list[cfg.dz_gv + 1],  1, 2)
    drawParamLine(90,  "Expo:",       ex_val .. "%",  gv_list[cfg.ex_gv + 1],  3, 4)
    drawParamLine(130, "Ratio Base:", rt_val .. "%",  gv_list[cfg.rt_gv + 1],  5, 6)
    drawParamLine(170, "Saturation:", sat_val .. "%", gv_list[cfg.sat_gv + 1], 7, 8)

    -- --- TRACÉ DU GRAPHIQUE (Côté droit uniquement : 0 à 100%)
    local gx, gy, gw, gh = 310, 50, 150, 140
    lcd.drawRectangle(gx, gy, gw, gh, GREY)
    lcd.drawFilledRectangle(gx + 1, gy + 1, gw - 1, gh - 1, lcd.RGB(240, 243, 246))
    lcd.drawText(gx + 5, gy + 3, "Courbe Reponse", SMLSIZE)

    local prev_px, prev_py = nil, nil
    local effective_sat = (sat_val <= dz_val) and (dz_val + 1) or sat_val

    for in_x = 0, 100, 5 do
        local val = 0
        if in_x <= dz_val then
            val = 0
        elseif in_x >= effective_sat then
            val = 100
        else
            val = ((in_x - dz_val) / (effective_sat - dz_val)) * 100
        end

        local norm = val / 100
        local shaped = norm
        if ex_val > 0 then
            local k = 9 * (ex_val / 100)
            shaped = (math.log(1 + k * norm) / math.log(1 + k)) * 100
        elseif ex_val < 0 then
            local e = math.abs(ex_val) / 100
            shaped = (norm ^ (1 + e * 2)) * 100
        else
            shaped = norm * 100
        end

        local final_val = shaped * (rt_val / 100)

        local px = gx + math.floor((in_x / 100) * gw)
        local py = (gy + gh) - math.floor((math.min(100, math.max(0, final_val)) / 100) * gh)

        if prev_px then
            lcd.drawLine(prev_px, prev_py, px, py, SOLID, BLUE)
        end
        prev_px, prev_py = px, py
    end

    -- Pied de page
    lcd.drawFilledRectangle(0, 230, 480, 42, lcd.RGB(41, 128, 185))
    if is_editing then
        lcd.drawText(280, 242, "[ENT] Valider", SMLSIZE + YELLOW)
    else
        lcd.drawText(260, 242, "[ENT] Modifier | [EXIT] Quitter", SMLSIZE + WHITE)
    end

    return 0
end

return { init = init, run = run }