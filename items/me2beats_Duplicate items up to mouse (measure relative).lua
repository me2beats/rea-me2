local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

script_title = 'duplicate items up to mouse (measure relative)'

items = r.CountSelectedMediaItems()
      
if items == 0 then bla() return end

window, segment, details = r.BR_GetMouseCursorContext()
mouse = r.BR_GetMouseCursorContext_Position()
if mouse == -1 then bla() return end

r.Undo_BeginBlock(); r.PreventUIRefresh(1)

for j = 1,1000 do

  min_pos = 100000
  max_pos = 0
  for i = 1, items do
    item = r.GetSelectedMediaItem(0, i-1)
    item_pos = r.GetMediaItemInfo_Value(item, "D_POSITION")
    item_len = r.GetMediaItemInfo_Value(item, "D_LENGTH")
    min_pos = math.min(min_pos,item_pos)
    max_pos = math.max(max_pos,item_pos+item_len)
  end
  com_len = max_pos-min_pos
  
  for i = 0, 10000 do
    msr = r.TimeMap_GetMeasureInfo(0, i)
    if not min_pos_msr then if msr > min_pos then min_pos_msr = r.TimeMap_GetMeasureInfo(0, i-1) end end
    if not max_pos_msr then if msr > max_pos then max_pos_msr = msr end end
    if not mouse_msr then if msr > mouse then mouse_msr = r.TimeMap_GetMeasureInfo(0, i-1) end end
    if min_pos_msr and max_pos_msr and mouse_msr then break end
  end
  
--  nudge_diff = (max_pos_msr-min_pos_msr) + (min_pos-min_pos_msr)
  nudge_diff = (max_pos_msr-min_pos_msr)
  
  tr = r.GetMediaItem_Track(r.GetSelectedMediaItem(0, 0))
  tr_items = r.CountTrackMediaItems(tr)
  
--[[
  for i = 0, tr_items-1 do
    item = r.GetTrackMediaItem(tr, i)
    it_pos = r.GetMediaItemInfo_Value(item, "D_POSITION")
    it_len = r.GetMediaItemInfo_Value(item, "D_LENGTH")
    it_end = it_pos + it_len
    if (min_pos+nudge_diff <= it_end and max_pos+nudge_diff >= it_end) or
       (max_pos+nudge_diff >= it_pos and min_pos+nudge_diff <= it_pos) or
       (min_pos+nudge_diff >= it_pos and max_pos+nudge_diff <= it_end)
       then
      found = 1 break
    end
  end
  
  if found then break end
--]]
--  if max_pos_msr >= mouse then break end

--  if max_pos_msr >= mouse then return end
  if max_pos >= mouse then return end

  r.ApplyNudge(0, 0, 5, 1, nudge_diff , 0, 0)

end

r.PreventUIRefresh(-1); r.Undo_EndBlock(script_title, -1)
