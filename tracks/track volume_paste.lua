sel_tr_count = reaper.CountSelectedTracks(0)
if sel_tr_count ~= nil then
  vol = reaper.GetExtState("me2beats_copy-paste", "vol")
  if vol ~= nil then
    for i = 1, sel_tr_count do
      tr = reaper.GetSelectedTrack(0, i-1)
      if tr ~= nil then
        reaper.SetMediaTrackInfo_Value(tr, "D_VOL", vol)
      end
    end
  end
end  
