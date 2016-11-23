r = reaper

local function SaveItems ()
  sel_items = {}
  for i = 0, r.CountSelectedMediaItems(0)-1 do sel_items[i+1] = r.GetSelectedMediaItem(0, i) end
end

local function RestoreItems ()
  r.Main_OnCommand(40289, 0) -- unselect all items
  for _, item in ipairs(sel_items) do r.SetMediaItemSelected(item, 1) end
end

function disable()

  active_editor = r.MIDIEditor_GetActive()
  if not active_editor then return end
  take = r.MIDIEditor_GetTake(active_editor)
  item = r.GetMediaItemTake_Item(take)

  if not last_active_editor or last_active_editor ~= active_editor then
    last_active_editor = active_editor
    wanted_it_len = r.GetMediaItemInfo_Value(item, 'D_LENGTH')
    last_pos = r.GetMediaItemInfo_Value(item, 'D_POSITION')
    last_end = wanted_it_len + last_pos
    return
  end

  it_len = r.GetMediaItemInfo_Value(item, 'D_LENGTH')
  it_pos = r.GetMediaItemInfo_Value(item, 'D_POSITION')
  it_end = it_len + it_pos
  if wanted_it_len ~= it_len then
    
    r.Undo_BeginBlock()
    
    if it_pos == last_pos and it_end ~= last_end then
      r.SetMediaItemInfo_Value(item, 'D_LENGTH', wanted_it_len)
    elseif it_pos ~= last_pos and it_end == last_end then
--      r.SetMediaItemInfo_Value(item, 'D_POSITION', last_pos)

      SaveItems ()
      r.Main_OnCommand(40289, 0) -- unselect all items
      r.SetMediaItemSelected(item,1)
      r.ApplyNudge(0, 1, 1, 1, last_pos, 0, 0)
      RestoreItems ()

    end
    r.MIDIEditor_LastFocused_OnCommand(40049, 0) -- pitch cursor up
    r.MIDIEditor_LastFocused_OnCommand(40050, 0) -- pitch cursor down
    
    r.Undo_EndBlock('Disable midi edge extending', 2)
    
  end
end


function main()
  local ch_count = r.GetProjectStateChangeCount()

  if not last_ch_count or last_ch_count ~= ch_count then  
    disable()
  end

  last_ch_count = ch_count
  r.defer(main)
end

-----------------------------------------------

function SetButtonON()
  r.SetToggleCommandState( sec, cmd, 1 ) -- Set ON
  r.RefreshToolbar2( sec, cmd )
  main()
end

-----------------------------------------------

function SetButtonOFF()
  r.SetToggleCommandState( sec, cmd, 0 ) -- Set OFF
  r.RefreshToolbar2( sec, cmd ) 
end

-----------------------------------------------

init = os.time()
last_update = os.time()-init
_, _, sec, cmd = r.get_action_context()
SetButtonON()
r.atexit(SetButtonOFF)

