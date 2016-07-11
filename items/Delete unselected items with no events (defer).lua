function main()
  local ch_count = reaper.GetProjectStateChangeCount(0)

  if not last_ch_count or last_ch_count ~= ch_count then
    deleted = nil
    local items = reaper.CountMediaItems(0)
    for i = items-1, 0, -1 do
      local item = reaper.GetMediaItem(0,i)
      if not reaper.IsMediaItemSelected(item) then
        local x = 0
        local takes = reaper.CountTakes(item)
        for j = 0, takes-1 do
          local take = reaper.GetTake(item, j)
          if reaper.TakeIsMIDI(take) then
            local _, notes, ccs, textsyxs = reaper.MIDI_CountEvts(take)
            if notes == 0 and ccs == 0 and textsyxs == 0 then x = x+1 end
            if x == takes then
              local tr = reaper.GetMediaItem_Track(item)
              reaper.DeleteTrackMediaItem(tr, item)
              if not deleted then deleted = 1 end
            end
          end
        end
      end
    end
    if deleted then reaper.UpdateArrange() end
  end

  last_ch_count = ch_count
  reaper.defer(main)
end

-----------------------------------------------

function SetButtonON()
  reaper.SetToggleCommandState( sec, cmd, 1 ) -- Set ON
  reaper.RefreshToolbar2( sec, cmd )
  main()
end

-----------------------------------------------

function SetButtonOFF()
  reaper.SetToggleCommandState( sec, cmd, 0 ) -- Set OFF
  reaper.RefreshToolbar2( sec, cmd ) 
end

-----------------------------------------------

  _, _, sec, cmd = reaper.get_action_context()
  SetButtonON()
  reaper.atexit(SetButtonOFF)
