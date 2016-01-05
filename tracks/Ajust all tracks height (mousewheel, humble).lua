num_of_tr = reaper.CountTracks(0)
if num_of_tr > 0 then
  function main()
    _,_,_,_,_,_,val = reaper.get_action_context()
    for t = 1, num_of_tr do
      tr = reaper.GetTrack(0,t-1)
      tr_hei = reaper.GetMediaTrackInfo_Value(tr, 'I_WNDH')
      if val > 0 then 
        reaper.SetMediaTrackInfo_Value(tr, 'I_HEIGHTOVERRIDE', tr_hei+20)
      else
        reaper.SetMediaTrackInfo_Value(tr, 'I_HEIGHTOVERRIDE', tr_hei-20)
      end
    end
    reaper.TrackList_AdjustWindows(false)
    reaper.UpdateTimeline()
  end
  reaper.defer(main)
end
