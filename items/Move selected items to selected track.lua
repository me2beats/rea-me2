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
    elseif more == 0 and less == 1 then
      for i = 0, items-1 do
        it = reaper.GetSelectedMediaItem(0, i)
        reaper.MoveMediaItemToTrack(it, tr)
      end
      reaper.UpdateArrange()
      u = 1
    elseif more == 1 and less == 0 then
      for i = 0, items-1 do
        it = reaper.GetSelectedMediaItem(0, 0)
        reaper.MoveMediaItemToTrack(it, tr)
      end
      reaper.UpdateArrange()
      u = 1
    end
    if u == 1 then
      script_title = 'Move selected items to selected track'
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
