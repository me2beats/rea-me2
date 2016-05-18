function nothing() end

function SaveLoopTimesel()
  init_start_timesel, init_end_timesel = reaper.GetSet_LoopTimeRange(0, 0, 0, 0, 0)
  init_start_loop, init_end_loop = reaper.GetSet_LoopTimeRange(0, 1, 0, 0, 0)
end

function RestoreLoopTimesel()
  reaper.GetSet_LoopTimeRange(1, 0, init_start_timesel, init_end_timesel, 0)
  reaper.GetSet_LoopTimeRange(1, 1, init_start_loop, init_end_loop, 0)
end

function SaveCursorPos()
  init_cursor_pos = reaper.GetCursorPosition()
end

function RestoreCursorPos()
  reaper.SetEditCurPos(init_cursor_pos, false, false)
end

-- SAVE INITIAL SELECTED ITEMS
init_sel_items = {}
local function SaveSelectedItems (table)
  for i = 0, reaper.CountSelectedMediaItems(0)-1 do
    table[i+1] = reaper.GetSelectedMediaItem(0, i)
  end
end


-- RESTORE INITIAL SELECTED ITEMS
local function RestoreSelectedItems (table)
  reaper.Main_OnCommand(40289, 0) -- Unselect all items
  for _, item in ipairs(table) do
    reaper.SetMediaItemSelected(item, true)
  end
end

tr = reaper.GetSelectedTrack(0,0)
if tr ~= nil then

  reaper.Undo_BeginBlock()
  reaper.PreventUIRefresh(111)
  SaveLoopTimesel()
  SaveCursorPos()
  SaveSelectedItems(init_sel_items)
  reaper.Main_OnCommand(40289, 0) -- unselect all items
  reaper.Main_OnCommand(40718, 0) -- select all items on selected track in current time selection
  reaper.Main_OnCommand(40290, 0) -- set time selection to items
  reaper.Main_OnCommand(41716, 0) -- render sel area of tracks to stereo stem tracks (postfader) and mute originals  RestoreSelectedItems(init_sel_items)
  RestoreLoopTimesel()
  RestoreCursorPos()
  reaper.PreventUIRefresh(-111)
  reaper.Undo_EndBlock('render selected track items', -1)
else
  reaper.defer(nothing)
end
