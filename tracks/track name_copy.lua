tr = reaper.GetSelectedTrack(0, 0)
if tr ~= nil then
  retval, tr_name = reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", "", false)
  reaper.SetExtState("me2beats_copy-paste", "track_name", tr_name, false)
end
