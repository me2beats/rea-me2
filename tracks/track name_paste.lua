sel_tr_count = reaper.CountSelectedTracks(0)
if sel_tr_count ~= nil then
  tr_name = reaper.GetExtState("me2beats_copy-paste", "track_name")
  if tr_name ~= nil then
    for i = 1, sel_tr_count do
      tr = reaper.GetSelectedTrack(0, i-1)
      if tr ~= nil then
	    reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", tr_name, true)
      end
    end
  end
end
