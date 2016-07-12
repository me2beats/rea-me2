function nothing() end; function bla() reaper.defer(nothing) end

tracks = reaper.CountSelectedTracks(0)
if tracks then
  retval, move = reaper.GetUserInputs("Move tracks", 1, "Move selected track to index:", "")
  if retval == true then 
    move = tonumber(move)
    if move then
      tr_num = reaper.GetMediaTrackInfo_Value(reaper.GetSelectedTrack(0,0), 'IP_TRACKNUMBER')
      if tr_num > move then tr = reaper.GetTrack(0,move-2)
      elseif tr_num < move then tr = reaper.GetTrack(0,move+tracks-2) end
      if tr then
        reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(111)
        tr_tb = {}
        for i = 0, tracks-1 do tr_tb[#tr_tb+1] = reaper.GetSelectedTrack(0,i) end
        reaper.Main_OnCommand(reaper.NamedCommandLookup('_S&M_COPYSNDRCV1'), 0) -- copy tr with routing
        reaper.SetOnlyTrackSelected(tr)
        reaper.Main_OnCommand(40914, 0) -- set first selected track as last touched track
        reaper.Main_OnCommand(reaper.NamedCommandLookup('_S&M_PASTSNDRCV1'), 0) -- paste tr with routing
        tr_tb_2 = {}
        for k = 0, tracks-1 do tr_tb_2[#tr_tb_2+1] = reaper.GetSelectedTrack(0,k) end
        reaper.Main_OnCommand(40297, 0) -- unselect all tracks
        for j = 1, #tr_tb do reaper.DeleteTrack(tr_tb[j]) end
        for l = 1, #tr_tb_2 do reaper.SetTrackSelected(tr_tb_2[l], 1) end
        reaper.PreventUIRefresh(-111); reaper.Undo_EndBlock('Move selected track to index '..move, -1)
      else bla() end
    else bla() end
  else bla() end
else bla() end
