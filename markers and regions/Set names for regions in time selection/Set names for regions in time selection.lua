local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

x_ts, y_ts = r.GetSet_LoopTimeRange(0, 0, 0, 0, 0)
if x_ts ~= y_ts then
  retval, retvals_csv = r.GetUserInputs("Regions name", 3, "Name:,Auto increment names,Separator", ",1,_")
  
  if retval == true then
    new_name, auto_incr, separator = retvals_csv:match('(.*),(.*),(.*)')
    if auto_incr == '1' then cntr = 0 end
    _, _, regions = r.CountProjectMarkers(0)
    r.Undo_BeginBlock()
    for i = 0, regions-1 do
      _, _, x_r, y_r, name, idx, color = r.EnumProjectMarkers3(0,i)

      if (x_r < y_ts and x_r > x_ts) or (y_r > x_ts and y_r < y_ts) or (x_r <= x_ts and y_r >= y_ts) then
        if cntr then
          cntr = cntr + 1
          r.SetProjectMarker4(0, idx, 1, x_r, y_r, new_name..separator..cntr, color, 0)
        else r.SetProjectMarker4(0, idx, 1, x_r, y_r, new_name, color, 0) end
      end
    end
    r.Undo_EndBlock("Set names for regions in time selection", -1)
  else bla() end
else bla() end
