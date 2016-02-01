function nothing()
end

items = reaper.CountSelectedMediaItems(0)
cur_pos = reaper.GetCursorPosition()
if items > 0 then

  first_it = reaper.GetSelectedMediaItem(0,0)
  min_it_pos = reaper.GetMediaItemInfo_Value(first_it, 'D_POSITION')
  for i = 1, items-1 do
    item = reaper.GetSelectedMediaItem(0,i)
    item_pos = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
    if item_pos < min_it_pos then
      min_it_pos = item_pos
    end
  end

  if cur_pos > min_it_pos then

    script_title = 'Stretch items like one item (goodbye Vegas)'
    reaper.Undo_BeginBlock()

    last_it = reaper.GetSelectedMediaItem(0,items-1)
    max_it_end = reaper.GetMediaItemInfo_Value(last_it, 'D_POSITION') + reaper.GetMediaItemInfo_Value(last_it, 'D_LENGTH')
    for i = 0, items-2 do
      item = reaper.GetSelectedMediaItem(0,i)
      item_end = reaper.GetMediaItemInfo_Value(item, 'D_POSITION') + reaper.GetMediaItemInfo_Value(item, 'D_LENGTH')
      if item_end > max_it_end then
        max_it_end = item_end
      end
    end
    
    old_len = max_it_end - min_it_pos
    new_len = cur_pos - min_it_pos
    k = old_len/new_len

    for i = 0, items-1 do

      it = reaper.GetSelectedMediaItem(0,i)

      old_it_pos = reaper.GetMediaItemInfo_Value(it, 'D_POSITION')
      old_it_rel_pos = old_it_pos - min_it_pos
      new_it_rel_pos = old_it_rel_pos / k
      new_it_pos = min_it_pos + new_it_rel_pos
      
      old_it_len = reaper.GetMediaItemInfo_Value(it, 'D_LENGTH')
      new_it_len = old_it_len / k
      
      takes = reaper.CountTakes(it)
      for t = 0, takes - 1 do
        take = reaper.GetTake(it, t)
        old_take_rate = reaper.GetMediaItemTakeInfo_Value(take, 'D_PLAYRATE')
        new_take_rate = old_take_rate * k
        reaper.SetMediaItemTakeInfo_Value(take, 'D_PLAYRATE', new_take_rate)
      end
      reaper.SetMediaItemInfo_Value(it, 'D_LENGTH', new_it_len)
      reaper.SetMediaItemInfo_Value(it, 'D_POSITION', new_it_pos)
      reaper.UpdateItemInProject(it)
    end

    reaper.Undo_EndBlock(script_title, -1) 

  else
    reaper.defer(nothing)
  end
else
  reaper.defer(nothing)
end
