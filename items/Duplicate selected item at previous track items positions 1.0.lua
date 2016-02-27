function nothing() end

sel_it = reaper.GetSelectedMediaItem(0, 0)
if sel_it ~= nil then
  it_id = reaper.BR_GetMediaItemGUID(sel_it)
  tr = reaper.GetMediaItem_Track(sel_it)
  reaper.SetOnlyTrackSelected(tr)
  tr_num = reaper.GetMediaTrackInfo_Value(tr, 'IP_TRACKNUMBER')
  prev_tr = reaper.GetTrack(0, tr_num-2)
  items = reaper.CountTrackMediaItems(prev_tr)
  if items > 0 then
    reaper.PreventUIRefresh(1)
    reaper.ApplyNudge(0, 1, 0, 0, 0, false, 0) -- move item to start of project
    for i = 0, items-1 do
      it = reaper.GetTrackMediaItem(prev_tr, i)
      it_pos = reaper.GetMediaItemInfo_Value(it, 'D_POSITION')
      reaper.ApplyNudge(0, 1, 5, 1, it_pos, false, 0)
    end
    reaper.Main_OnCommand(40289,0) -- unselect all items
    reaper.Main_OnCommand(40421,0) -- select all items in track
    prev_tr_first_it = reaper.GetTrackMediaItem(prev_tr, 0)
    it_pos = reaper.GetMediaItemInfo_Value(prev_tr_first_it, 'D_POSITION')
    if it_pos ~= 0 then
      item = reaper.GetSelectedMediaItem(0, 0)
      reaper.DeleteTrackMediaItem(tr, item)
    end
    reaper.PreventUIRefresh(1)
    reaper.UpdateArrange()
    
    script_title = 'Duplicate selected item at previous track items positions'
    reaper.Undo_BeginBlock()
    reaper.Undo_EndBlock(script_title, -1)
  else
    reaper.defer(nothing)
  end
  reaper.defer(nothing)
end
