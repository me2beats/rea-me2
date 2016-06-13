function last_track_in_folder (folder_tr)
  last = nil
  local dep = reaper.GetTrackDepth(folder_tr)
  local num = reaper.GetMediaTrackInfo_Value(folder_tr, 'IP_TRACKNUMBER')
  local tracks = reaper.CountTracks(0)
  for i = num+1, tracks, 1 do
    if reaper.GetTrackDepth(reaper.GetTrack(0,i-1)) <= dep then last = reaper.GetTrack(0,i-2) break end
  end
  if last == nil then last = reaper.GetTrack(0, tracks-1) end
  return last
end
