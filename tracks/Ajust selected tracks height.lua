num_of_sel_tr = reaper.CountSelectedTracks(0)
if num_of_sel_tr > 0 then
  _,_,_,_,_,_,val = reaper.get_action_context()
  for t = 1, num_of_sel_tr do
    tr = reaper.GetSelectedTrack(0,t-1)
    tr_hei = reaper.GetMediaTrackInfo_Value(tr, 'I_WNDH')
    if val > 0 then 
      reaper.SetMediaTrackInfo_Value(tr, 'I_HEIGHTOVERRIDE', tr_hei+10)
    else
      reaper.SetMediaTrackInfo_Value(tr, 'I_HEIGHTOVERRIDE', tr_hei-10)
    end
    reaper.TrackList_AdjustWindows(false)
  end
end
