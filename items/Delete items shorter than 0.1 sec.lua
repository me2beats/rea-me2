function nothing() end

init_sel_items = {}
local function SaveSelectedItems (table)
  for i = 0, reaper.CountSelectedMediaItems(0)-1 do table[i+1] = reaper.GetSelectedMediaItem(0, i) end
end

local function RestoreSelectedItems (table)
  reaper.Main_OnCommand(40289, 0) -- Unselect all items
  for _, item in ipairs(table) do
    reaper.SetMediaItemSelected(item, 1)
  end
end

items = reaper.CountMediaItems(0)
if items > 0 then
  reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(111)
  SaveSelectedItems (init_sel_items)
  t = {}
  for i = 0, items-1 do 
    item = reaper.GetMediaItem(0,i)
    if reaper.GetMediaItemInfo_Value(item, 'D_LENGTH') < 0.1 then t[#t+1] = item end
  end
  reaper.Main_OnCommand(40289, 0) -- unselect all items
  for i = 1, #t do
    reaper.SetMediaItemSelected(t[i], 1)
  end
  reaper.Main_OnCommand(40006, 0) -- remove items
  for i = #init_sel_items, 1, -1 do
    for j = 1, #t do if init_sel_items[i] == t[j] then init_sel_items[i] = nil break end end
  end

  RestoreSelectedItems (init_sel_items)
  reaper.UpdateArrange()
  reaper.PreventUIRefresh(-111); reaper.Undo_EndBlock('Delete items shorter then 0.1 sec', -1)

else reaper.defer(nothing) end
