function nothing() end

function SaveCursorPos() init_cursor_pos = reaper.GetCursorPosition() end
function RestoreCursorPos() reaper.SetEditCurPos(init_cursor_pos, 0, 0) end

function get_measure ()
  reaper.ApplyNudge(0, 0, 6, 1, 0.001, 0, 0) -- move cursor right to 1 sample
  reaper.Main_OnCommand(40838, 0) -- move cursor to start of current measure
  return reaper.GetCursorPosition()
end

items = reaper.CountSelectedMediaItems(0)
if items>0 then
  reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(111)
  SaveCursorPos()
  reaper.Main_OnCommand(40513, 0) -- move cursor to mouse
  cursor = reaper.GetCursorPosition()
  first = reaper.GetSelectedMediaItem(0,0)
  first_start = reaper.GetMediaItemInfo_Value(first, 'D_POSITION')
  first_len = reaper.GetMediaItemInfo_Value(first, 'D_LENGTH')
  cur_measure = get_measure ()
  reaper.Main_OnCommand(41173, 0) -- move cursor to start of items
  first_measure = get_measure ()
  reaper.ApplyNudge(0, 0, 5, 1, cur_measure-first_measure, 0, 0) -- move items
  RestoreCursorPos()
  reaper.Undo_EndBlock('copy selected items at current measure', -1); reaper.PreventUIRefresh(-111)
else reaper.defer(nothing) end
