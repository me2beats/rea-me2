function main()
  local ch_count = reaper.GetProjectStateChangeCount(0)

  if not last_ch_count or last_ch_count ~= ch_count then
    local _, trnum, fxnum, parnum = reaper.GetLastTouchedFX()
    tr = reaper.GetTrack(0,trnum-1)
    if tr then
      val = reaper.TrackFX_GetParam(tr, fxnum, parnum)
      _, tr_fxname = reaper.TrackFX_GetFXName(tr, fxnum, '')
      _, parname = reaper.TrackFX_GetParamName(tr, fxnum, parnum, '')
      x = nil
      
      if last_parname ~= parname then x = 1 elseif last_val ~= val then x = 1 end
      if x then
        reaper.PreventUIRefresh(1)
        for i = 0, reaper.CountTracks(0)-1 do
          other_tr = reaper.GetTrack(0,i)
          fx_count = reaper.TrackFX_GetCount(other_tr)
          for j = 0, fx_count-1 do
            _, other_tr_fxname = reaper.TrackFX_GetFXName(other_tr, j, '')
            if other_tr_fxname == tr_fxname then
              reaper.TrackFX_SetParam(other_tr, j, parnum, val)
            end
          end
        end
        last_parname, last_val = parname, val
        reaper.PreventUIRefresh(-1)
      end
      last_ch_count = ch_count
    end
  end
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
