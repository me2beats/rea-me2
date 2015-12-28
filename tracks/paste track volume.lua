sel_tr_count = reaper.CountSelectedTracks(0)
if reaper.CountSelectedMediaItems(0) > 0 then
  vol = reaper.GetExtState("Buffer", "vol")
  for i = 0, sel_tr_count-1 do
    tr = reaper.GetSelectedTrack(0, i)
    ok_1, vol_1, pan_1 = reaper.GetTrackUIVolPan(tr, 0, 0)
    reaper.SetMediaTrackInfo_Value(tr, "D_VOL", vol)
    i = i+1
  end
end