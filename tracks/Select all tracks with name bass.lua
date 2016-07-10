tracks = reaper.CountTracks(0)
reaper.Main_OnCommand(40297,0) -- unselect all tracks

for i = 0, tracks-1 do
  tr = reaper.GetTrack(0, i)
  _, tr_name = reaper.GetSetMediaTrackInfo_String(tr, 'P_NAME', '', 0)
  if tr_name  == 'bass' then reaper.SetTrackSelected(tr, 1) end
end
