num_of_tr = reaper.CountTracks(0)
if num_of_tr > 0 then
  function main()
    _,_,_,_,_,_,val = reaper.get_action_context()
    for t = 1, num_of_tr do
      tr = reaper.GetTrack(0,t-1)

      _, chunk = reaper.GetTrackStateChunk(tr, '', false)
      
      buf_chunk = chunk
      
      if string.find (chunk, "VIS 1 1") ~= '' then
        chunk_new = string.gsub(chunk, "VIS 1 1", "VIS 0 1")
        reaper.SetTrackStateChunk(tr, chunk_new, false)
        tr_hei = reaper.GetMediaTrackInfo_Value(tr, 'I_WNDH')
        reaper.SetTrackStateChunk(tr, buf_chunk, false)
      else
        tr_hei = string.match (chunk, 'TRACKHEIGHT (%d*)')
      end
            
      if val > 0 then 
        chunk_new = string.gsub(chunk, "TRACKHEIGHT %d*", "TRACKHEIGHT "..tr_hei+20, 1)
      else
        chunk_new = string.gsub(chunk, "TRACKHEIGHT %d*", "TRACKHEIGHT "..tr_hei-20, 1)
      end
      reaper.SetTrackStateChunk(tr, chunk_new, false)
    end
    reaper.TrackList_AdjustWindows(false)
    reaper.UpdateTimeline()
  end
  reaper.defer(main)
end
