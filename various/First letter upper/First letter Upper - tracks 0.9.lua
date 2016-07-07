function first_letter_upper_all_tracks()
  tracks = reaper.CountTracks(0)
  for i = 0, tracks-1 do
    tr = reaper.GetTrack(0,i)
    _, tr_name = reaper.GetSetMediaTrackInfo_String(tr, 'P_NAME', '', 0)
    if tr_name ~= '' then
      if #tr_name > 1 then
        tr_name = tr_name:sub(1,1):upper()..tr_name:sub(2,-1)
      else tr_name = tr_name:sub(1,1):upper() end
      reaper.GetSetMediaTrackInfo_String(tr, 'P_NAME', tr_name, 1)    
    end      
  end
  reaper.defer(first_letter_upper_all_tracks)
end

first_letter_upper_all_tracks()
