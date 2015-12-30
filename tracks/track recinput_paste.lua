sel_tr_count = reaper.CountSelectedTracks(0)
if sel_tr_count ~= nil then
  tr_recin = reaper.GetExtState("me2beats_copy-paste", "recin")
  if tr_recin ~= nil then
    for i = 1, sel_tr_count do
      tr = reaper.GetSelectedTrack(0, i-1)
      if tr ~= nil then
        reaper.SetMediaTrackInfo_Value(tr, "I_RECINPUT", tr_recin)
      end
    end
  end
end
