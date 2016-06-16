tb = {'drums', 'synth', 'xz'}

function nothing() end

function last_track_in_folder (folder_tr)
  last = nil
  local dep = reaper.GetTrackDepth(folder_tr)
  local num = reaper.GetMediaTrackInfo_Value(folder_tr, 'IP_TRACKNUMBER')
  local tracks = reaper.CountTracks(0)
  for i = num+1, tracks, 1 do
    if reaper.GetTrackDepth(reaper.GetTrack(0,i-1)) <= dep then last = reaper.GetTrack(0,i-2) break end
  end
  if last == nil then last = reaper.GetTrack(0, tracks-1) end return last
end

function ancestor (child_tr)
  cand = nil
  num = reaper.GetMediaTrackInfo_Value(child_tr, 'IP_TRACKNUMBER')
  for i = num-1, 0, -1 do
    cand = reaper.GetTrack(0,i) if reaper.GetTrackDepth(cand) == 0 then break end
  end return cand
end

function compare_str_case_insens (str_1, str_2)
  capture = ''
  if str_1 and str_2 then
    for w in str_1:gmatch('.') do capture = capture..'['..w:lower()..','..w:upper()..']' end
    if str_2:match(capture) then return true end
  end
end

tracks = reaper.CountTracks(0)
if tracks > 0 then
  reaper.Undo_BeginBlock()
  reaper.PreventUIRefresh(111)
  
  for a = 1, #tb do
    folder_name = tb[a]
  
    reaper.Main_OnCommand(40297, 0) -- unselect all tracks
    sel = 0
    for j = 0, tracks-1 do
      track = reaper.GetTrack(0,j)
      _, track_name = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', '', 0)
      if compare_str_case_insens (track_name:match('(.*)_.*'), folder_name) then
        _, ancestor_name = reaper.GetSetMediaTrackInfo_String(ancestor(track), 'P_NAME', '', 0)
        if not compare_str_case_insens (ancestor_name, folder_name) then reaper.SetTrackSelected(track, 1) sel = 1 end
      end
    end
  
    if sel == 1 then
      for k = 0, tracks-1 do
        tr = reaper.GetTrack(0,k)
        _, tr_name = reaper.GetSetMediaTrackInfo_String(tr, 'P_NAME', '', 0)
        if compare_str_case_insens (tr_name, folder_name) then
          _, escape_absurd_name = reaper.GetSetMediaTrackInfo_String(ancestor(tr), 'P_NAME', '', 0)
          if not compare_str_case_insens (escape_absurd_name:match('(.*)_.*'), folder_name) then
            reaper.Main_OnCommand(reaper.NamedCommandLookup('_S&M_CUTSNDRCV1'), 0) -- cut tr with routing
  --        reaper.Main_OnCommand(40337, 0) -- cut tracks
            tr_last = last_track_in_folder (tr)
            reaper.SetOnlyTrackSelected(tr_last)
            reaper.Main_OnCommand(40914, 0) -- set first selected track as last touched track
            reaper.Main_OnCommand(1041, 0) -- cycle track folder state
  --        reaper.Main_OnCommand(40058, 0) -- paste tracks
            reaper.Main_OnCommand(reaper.NamedCommandLookup('_S&M_PASTSNDRCV1'), 0) -- paste tr with routing
            pasted_tracks = reaper.CountSelectedTracks(0)
            last_pasted = reaper.GetSelectedTrack(0,pasted_tracks-1)
            reaper.SetOnlyTrackSelected(last_pasted)
            reaper.Main_OnCommand(40914, 0) -- set first selected track as last touched track
            last_pasted_num = reaper.GetMediaTrackInfo_Value(last_pasted, 'IP_TRACKNUMBER')
            if last_pasted_num ~= tracks then
              if reaper.GetTrackDepth(reaper.GetTrack(0,last_pasted_num)) == reaper.GetTrackDepth(last_pasted) then
                reaper.Main_OnCommand(1041, 0) -- cycle track folder state
                reaper.Main_OnCommand(1041, 0) -- cycle track folder state
              else reaper.Main_OnCommand(1041, 0) end -- -- cycle track folder state
            else
              reaper.Main_OnCommand(1041, 0) -- cycle track folder state
              reaper.Main_OnCommand(1041, 0) -- cycle track folder state
            end
          end
        break end
      end
    end
  end
  
  reaper.Undo_EndBlock('Organize tracks', -1)
  reaper.PreventUIRefresh(-111)
else reaper.defer(nothing) end

