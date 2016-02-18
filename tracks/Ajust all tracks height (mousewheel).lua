num_of_tr = reaper.CountTracks(0)
if num_of_tr > 0 then
  function main()
    _,_,_,_,_,_,val = reaper.get_action_context()
    for t = 1, num_of_tr do
      tr = reaper.GetTrack(0,t-1)

      _, chunk = reaper.GetTrackStateChunk(tr, '', false)
      
      n = 0
      new_str = chunk
      for w in string.gmatch(chunk, "VIS 1") do
        i = string.find (new_str, 'VIS 1')
        new_str = string.sub(new_str, i+5)
        k = string.find (new_str, 'LANEHEIGHT')
        space = string.find (new_str, ' ', k+12)
        n_new = string.sub(new_str, k+10, space)
        n = n + n_new
      end
      
      tr_hei = reaper.GetMediaTrackInfo_Value(tr, 'I_WNDH')
      if val > 0 then 
        reaper.SetMediaTrackInfo_Value(tr, 'I_HEIGHTOVERRIDE', tr_hei+20-n)
      else
        reaper.SetMediaTrackInfo_Value(tr, 'I_HEIGHTOVERRIDE', tr_hei-20-n)
      end
    end
    reaper.TrackList_AdjustWindows(false)
    reaper.UpdateTimeline()
  end
  reaper.defer(main)
end
