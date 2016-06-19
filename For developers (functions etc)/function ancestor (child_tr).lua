function ancestor (child_tr)
  cand = nil
  num = reaper.GetMediaTrackInfo_Value(child_tr, 'IP_TRACKNUMBER')
  for i = num-1, 0, -1 do
    cand = reaper.GetTrack(0,i) if reaper.GetTrackDepth(cand) == 0 then break end
  end return cand
end
