function nothing() end

tr = reaper.GetSelectedTrack(0, 0)
if tr ~= nil then
  items = reaper.CountSelectedMediaItems(0)
  if items > 0 then
    tr_num = reaper.GetMediaTrackInfo_Value(tr, 'IP_TRACKNUMBER')
    more = 0
    less = 0
    for i_0 = 0, items-1 do
      it_0 = reaper.GetSelectedMediaItem(0, i_0)
      tr_0 = reaper.GetMediaItemTrack(it_0)
      tr_0_num = reaper.GetMediaTrackInfo_Value(tr_0, 'IP_TRACKNUMBER')
      if tr_num > tr_0_num then more = 1 end
      if tr_num < tr_0_num then less = 1 end
    end
    if more == 1 and less == 1 then
      reaper.MB("Can't do this. My coder will fix this later.", '', 0)
    elseif more+less == 1 then
      reaper.PreventUIRefresh(1)
      if reaper.GetToggleCommandState(41117) == 1 then  -- check 'trim behind items'
        trim = 1
        reaper.Main_OnCommand(41117, 0)
      end
      reaper.ApplyNudge(0, 0, 5, 0, 1, false, 0)
      for i = 0, items-1 do
        if more == 0 then x = i else x = 0 end
        it = reaper.GetSelectedMediaItem(0, x)
        reaper.MoveMediaItemToTrack(it, tr)
      end
      reaper.ApplyNudge(0, 0, 0, 0, -1, false, 0)
      if trim == 1 then reaper.Main_OnCommand(41117, 0) end
      reaper.PreventUIRefresh(-1)
      reaper.UpdateArrange()
      u = 1
      
    end
    if u == 1 then
      script_title = 'Duplicate selected items to selected track'
      reaper.Undo_BeginBlock()
      reaper.Undo_EndBlock(script_title, -1)
    else
      reaper.defer(nothing)
    end
  else
    reaper.defer(nothing)
  end
else
  reaper.defer(nothing)
end
