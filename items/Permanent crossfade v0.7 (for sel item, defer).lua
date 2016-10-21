crfade = 0.01
----------------------------------------------------------------------------------------------------
r = reaper
----------------------------------------------------------------------------------------------------
function cur_proj() return r.EnumProjects(-1, 0) end

----------------------------------------------------------------------------------------------------
function perm_crossfade()
-- N: p == cur_proj

  local item = r.GetSelectedMediaItem(p,0)
  if item then
    local _, chunk = r.GetItemStateChunk(item, 0, 0)


    local tr = r.GetMediaItem_Track(item)
    local tr_items = r.CountTrackMediaItems(tr)

    local it_start = r.GetMediaItemInfo_Value(item, 'D_POSITION')
    local it_len = r.GetMediaItemInfo_Value(item, 'D_LENGTH')
    local it_end = it_start+it_len



    for i = 0, tr_items-1 do

      local tr_item =  reaper.GetTrackMediaItem(tr, i)

      if tr_item ~= item then

        local tr_it_start = r.GetMediaItemInfo_Value(tr_item, 'D_POSITION')
        local tr_it_len = r.GetMediaItemInfo_Value(tr_item, 'D_LENGTH')
        local tr_it_end = tr_it_start+tr_it_len

        if tr_it_start < it_end and tr_it_end > it_end and it_end - tr_it_start >= crfade then

          local before, val, after = chunk:match'(FADEOUT %S+ %S+ )(%S+)( .-\n)'

          if val ~= crfade then

            local chunk = chunk:gsub(before..val..after, before..crfade..after)
            r.SetItemStateChunk(item, chunk, 0)

            local _, chunk_2 = r.GetItemStateChunk(tr_item, 0, 0)
            local before, val, after = chunk_2:match'(FADEIN %S+ %S+ )(%S+)( .-\n)'
            local chunk_2 = chunk_2:gsub(before..val..after, before..crfade..after)

            r.SetItemStateChunk(tr_item, chunk_2, 0)

            r.SetMediaItemInfo_Value(item, 'D_LENGTH', tr_it_start-it_start+crfade)

            r.UpdateItemInProject(item)

            fadeout_ok = 1

            break
          end
        end
      end
    end


    if fadeout_ok then
      fadeout_ok = nil
      local it_len = r.GetMediaItemInfo_Value(item, 'D_LENGTH')
      local it_end = it_start+it_len
      local _, chunk = r.GetItemStateChunk(item, 0, 0)
    end

    for i = 0, tr_items-1 do
      local tr_item =  reaper.GetTrackMediaItem(tr, i)

      if tr_item ~= item then

        local tr_it_start = r.GetMediaItemInfo_Value(tr_item, 'D_POSITION')
        local tr_it_len = r.GetMediaItemInfo_Value(tr_item, 'D_LENGTH')
        local tr_it_end = tr_it_start+tr_it_len

        if it_start < tr_it_end and it_end > tr_it_end and tr_it_end - it_start >= crfade then


          local before, val, after = chunk:match'(FADEIN %S+ %S+ )(%S+)( .-\n)'

          if val ~= crfade then

            local chunk = chunk:gsub(before..val..after, before..crfade..after)
            r.SetItemStateChunk(item, chunk, 0)

            local _, chunk_2 = r.GetItemStateChunk(tr_item, 0, 0)
            local before, val, after = chunk_2:match'(FADEOUT %S+ %S+ )(%S+)( .-\n)'
            local chunk_2 = chunk_2:gsub(before..val..after, before..crfade..after)

            r.SetItemStateChunk(tr_item, chunk_2, 0)

            r.SetMediaItemInfo_Value(tr_item, 'D_LENGTH', it_start-tr_it_start+crfade)

            r.UpdateItemInProject(item)

            break
          end
        end
      end
    end
  end

end

----------------------------------------------------------------------------------------------------




function main()
  local ch_count = r.GetProjectStateChangeCount(p)

  if not last_ch_count or last_ch_count ~= ch_count then

    perm_crossfade()

  end

  last_ch_count = ch_count
  r.defer(main)
end

----------------------------------------------------------------------------------------------------
function SetButtonON()
  r.SetToggleCommandState( sec, cmd, 1 ) -- Set ON
  r.RefreshToolbar2( sec, cmd )
  main()
end

----------------------------------------------------------------------------------------------------
function SetButtonOFF()
  r.SetToggleCommandState( sec, cmd, 0 ) -- Set OFF
  r.RefreshToolbar2( sec, cmd ) 
end
----------------------------------------------------------------------------------------------------

p = cur_proj()

_, _, sec, cmd = r.get_action_context()
SetButtonON()
r.atexit(SetButtonOFF)

