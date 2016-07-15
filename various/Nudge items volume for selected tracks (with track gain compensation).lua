local r = reaper; function nothing() end; function bla() r.defer(nothing) end;

local tracks = r.CountSelectedTracks(0)
if tracks > 0 then
  local retval, delta_db = r.GetUserInputs("Nudge volume", 1, "Nudge volume, dB:", "")
  if retval == true then
    if tonumber(delta_db) then
      r.Undo_BeginBlock(); r.PreventUIRefresh(111)
      for i = 0, tracks-1 do
        local tr = r.GetSelectedTrack(0, i)
        local items = r.CountTrackMediaItems(tr)
        if items > 0 then
          local tr_vol = r.GetMediaTrackInfo_Value(tr, 'D_VOL')
          r.SetMediaTrackInfo_Value(tr, 'D_VOL', tr_vol*10^(0.05*(-delta_db)))
          for j = 0, items-1 do
            local it = r.GetTrackMediaItem(tr, j)
            it_vol = r.GetMediaItemInfo_Value(it, 'D_VOL')
            r.SetMediaItemInfo_Value(it, 'D_VOL', it_vol*10^(0.05*delta_db))
          end
        end        
      end
      r.PreventUIRefresh(-111); r.UpdateArrange()
      r.Undo_EndBlock('Nudge items volume for sel tracks (with compensation)', -1)
    else bla() end
  else bla() end
else bla() end
