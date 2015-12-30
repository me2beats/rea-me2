sel_tr_count = reaper.CountSelectedTracks(0)
if sel_tr_count ~= nil then
  pan = reaper.GetExtState("me2beats_copy-paste", "pan")
  if pan ~= nil then
    for i = 1, sel_tr_count do
      tr = reaper.GetSelectedTrack(0, i-1)
      if tr ~= nil then
        reaper.SetMediaTrackInfo_Value(tr, "D_PAN", pan)
      end
    end
  end
end
