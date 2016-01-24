function get_last_tr_in_folder()
-- if sel tr is folder(sel_tr_dep == 1)
-- function needs: sel_tr, sel_tr_dep
  
  tracks = reaper.CountTracks(0)
  tr_num = reaper.GetMediaTrackInfo_Value(reaper.GetSelectedTrack(0, 0), 'IP_TRACKNUMBER')
  cand_dep = sel_tr_dep
  for t = tr_num, tracks-1 do
    cand_last_tr = reaper.GetTrack(0,t)
    add_dep = reaper.GetMediaTrackInfo_Value(cand_last_tr, 'I_FOLDERDEPTH')
    cand_dep = cand_dep + add_dep
    if cand_dep <= 0 then
      last_tr = cand_last_tr
      break
    end
  end
end

function nothing()
end

sel_tr = reaper.GetSelectedTrack(0, 0)
start_ts, end_ts = reaper.GetSet_LoopTimeRange(0, 0, 0, 0, 0)
if sel_tr ~= nil and (end_ts - start_ts) > 0 then
  sel_tr_dep = reaper.GetMediaTrackInfo_Value(sel_tr, 'I_FOLDERDEPTH')
  if sel_tr_dep == 1 then -- selected track is folder
  
    script_title = 'copy items of track of sel folder (obey time selection) and paste at cursor'
    reaper.Undo_BeginBlock()
    
    get_last_tr_in_folder()

    reaper.Main_OnCommand(40297, 0) -- unselect all tracks (malo li)

    last_tr_number = reaper.GetMediaTrackInfo_Value(last_tr, 'IP_TRACKNUMBER')

    for x = tr_num-1, last_tr_number-1 do
      iter_tr = reaper.GetTrack(0, x)
      reaper.SetTrackSelected(iter_tr, true)
    end
    
    reaper.Main_OnCommand(40718, 0) -- select all items on selected track in time selection
    
    cur_pos = reaper.GetCursorPosition()
    
    reaper.ApplyNudge(0, 0, 5, 1, cur_pos, false, 0)
    
    reaper.SetOnlyTrackSelected(sel_tr)
    
    reaper.Main_OnCommand(40289, 0) -- -- unselect all items
    
    reaper.Undo_EndBlock(script_title, -1)
    
  else
    reaper.defer(nothing)
  end
else
  reaper.defer(nothing)
end

