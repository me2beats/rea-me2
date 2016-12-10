d = 1000

local r = reaper

r.Undo_BeginBlock(); r.PreventUIRefresh(1)


items = r.CountSelectedMediaItems()

for i = 0, items-1 do
  old_item = r.GetSelectedMediaItem(0,i)
  item = r.GetSelectedMediaItem(0,i+1)
  if not item then break end

  old_it_start = r.GetMediaItemInfo_Value(old_item, 'D_POSITION')
  old_it_len = r.GetMediaItemInfo_Value(old_item, 'D_LENGTH')

  it_start = r.GetMediaItemInfo_Value(item, 'D_POSITION')
  it_len = r.GetMediaItemInfo_Value(item, 'D_LENGTH')

  r.SetMediaItemInfo_Value(item, 'D_POSITION', old_it_start+old_it_len+d/1000)
end

r.UpdateArrange()
r.PreventUIRefresh(-1); r.Undo_EndBlock('Set distance between items', -1)
