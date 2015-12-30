count_sel_items = reaper.CountSelectedMediaItems(0)
if count_sel_items ~= nil  then
  items_to_select = {}
  for n = 1, count_sel_items do
    item = reaper.GetSelectedMediaItem(0, n-1)
    if item ~= nil then
      guid = reaper.BR_GetMediaItemGUID(item)
      table.insert(items_to_select, {guid, (n-1) % 2})
    end
  end
  for i = 1, #items_to_select do
    item = reaper.BR_GetMediaItemByGUID(0, items_to_select[i][1])
    if items_to_select[i][2] == 1 then selected = true else selected = false end
    if item ~= nil then reaper.SetMediaItemSelected(item, not selected) end
  end
  reaper.UpdateArrange()
end