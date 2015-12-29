sel_tr_count = reaper.CountSelectedTracks(0)
if sel_tr_count ~= nil then
  tr_recmode = reaper.GetExtState("Buffer", "recmode")
  if tr_recmode ~= nil then
    for i = 1, sel_tr_count do
      tr = reaper.GetSelectedTrack(0, i-1)
      if tr ~= nil then
        reaper.SetMediaTrackInfo_Value(tr, "I_RECMODE", tr_recmode)
      end
    end
  end
end
