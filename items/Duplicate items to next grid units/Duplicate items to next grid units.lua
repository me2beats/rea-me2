function nothing() end
sel_items = reaper.CountSelectedMediaItems(0)
if sel_items > 0 then
  reaper.Undo_BeginBlock()
  grid = reaper.BR_GetNextGridDivision(0)
  frst_item = reaper.GetSelectedMediaItem(0, 0)
  lst_item = reaper.GetSelectedMediaItem(0, sel_items-1)
  frst_it_pos = reaper.GetMediaItemInfo_Value(frst_item, 'D_POSITION')
  lst_it_pos = reaper.GetMediaItemInfo_Value(lst_item, 'D_POSITION')
  lst_it_len = reaper.GetMediaItemInfo_Value(lst_item, 'D_LENGTH')
  lst_it_end = lst_it_pos+lst_it_len
  next_grid = reaper.BR_GetNextGridDivision(lst_it_end)
  grids = (next_grid-frst_it_pos)/grid
  reaper.ApplyNudge(0, 0, 5, 2, grids, false, 0)
  reaper.Undo_EndBlock('Duplicate items to next grid units', -1)
else reaper.defer(nothing) end

