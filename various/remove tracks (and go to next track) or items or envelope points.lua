function nothing() end

cur_context = reaper.GetCursorContext2(true)

if cur_context == 0 then
  tracks = reaper.CountSelectedTracks(0)
  if tracks ~= 0 then
    if tracks > 1 then
      scr_title = 'Remove '..tracks..' tracks'; q = reaper.MB('Remove '..tracks..' selected tracks?', 'Remove tracks', 1)
    else scr_title = 'Remove track'; q = reaper.MB('Remove selected track?', 'Remove tracks', 1) end
    
    if q == 1 then
      reaper.PreventUIRefresh(111); reaper.Undo_BeginBlock()
  
      reaper.Main_OnCommand(40005,0) -- remove tracks
      reaper.Main_OnCommand(40285,0) -- go to next track
      reaper.Main_OnCommand(40286,0) -- go to prev track
      reaper.PreventUIRefresh(-111);  reaper.Undo_EndBlock(scr_title, -1)
    else reaper.defer(nothing) end
  end
elseif cur_context == 1 or cur_context == 2 then
  if cur_context == 1 then
    items = reaper.CountSelectedMediaItems(0)
    if items > 1 then
      reaper.PreventUIRefresh(111); reaper.Undo_BeginBlock()
      reaper.Main_OnCommand(40697,0) -- remove items/tracks/envelope points
      reaper.PreventUIRefresh(-111);  reaper.Undo_EndBlock('Remove '..items..' items', -1)
    elseif items == 1 then
      reaper.PreventUIRefresh(111); reaper.Undo_BeginBlock()
      reaper.Main_OnCommand(40697,0) -- remove items/tracks/envelope points
      reaper.PreventUIRefresh(-111);  reaper.Undo_EndBlock('Remove item', -1)
    else reaper.defer(nothing) end
  else
    reaper.PreventUIRefresh(111); reaper.Undo_BeginBlock()
    reaper.Main_OnCommand(40697,0) -- remove items/tracks/envelope points
    reaper.PreventUIRefresh(-111);  reaper.Undo_EndBlock('Remove envelope points', -1)
  end
else reaper.defer(nothing) end
