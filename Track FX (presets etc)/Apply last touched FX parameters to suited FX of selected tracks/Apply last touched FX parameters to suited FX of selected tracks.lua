function nothing() end
--------------------------------------------------------------------------------------------
function esc (str)
  str_esc = str:gsub('%(', '%%(')
  str_esc = str_esc:gsub('%)', '%%)')
  str_esc = str_esc:gsub('%.', '%%.')
  str_esc = str_esc:gsub('%+', '%%+')
  str_esc = str_esc:gsub('%-', '%%-')
  str_esc = str_esc:gsub('%$', '%%$')
  str_esc = str_esc:gsub('%[', '%%[')
  str_esc = str_esc:gsub('%]', '%%]')
  str_esc = str_esc:gsub('%*', '%%*')
  str_esc = str_esc:gsub('%?', '%%?')
  str_esc = str_esc:gsub('%^', '%%^')
  return str_esc
end
--------------------------------------------------------------------------------------------
_, tr_from_num, fx_from = reaper.GetLastTouchedFX()
tr_from = reaper.GetTrack(0, tr_from_num-1)
fx_from_guid_esc = esc(reaper.TrackFX_GetFXGUID(tr_from, fx_from))
_, tr_from_chunk = reaper.GetTrackStateChunk(tr_from, '', 0)

_, fx_from_name_to_print = reaper.TrackFX_GetFXName( tr_from, fx_from, '')

fx_from_name, fx_from_data = tr_from_chunk:match(".*\n<(.-)\n(.-)\n>.-"..'\nFXID '..fx_from_guid_esc..'\n')
fx_from_name_esc = esc(fx_from_name); fx_from_data_esc = esc(fx_from_data)

tracks = reaper.CountSelectedTracks(0)
if tracks > 0 then
  reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(111)
  x = 0
  for i = 0, tracks-1 do
    tr_to = reaper.GetSelectedTrack(0,i)
    _, tr_to_chunk = reaper.GetTrackStateChunk(tr_to, '', 0)
    t = {}
    for replace_this in tr_to_chunk:gmatch('BYPASS %d %d %d.-'..fx_from_name_esc..'\n(.-)\n>') do
      replace_this_esc = esc(replace_this)
      if replace_this ~= fx_from_data then t[#t+1] = replace_this_esc end
    end
    
    if #t > 0 then    
      for i = 1, #t do tr_to_chunk = tr_to_chunk:gsub(t[i], 'okallright') end
      x = x+#t
      t = {}
      for k in tr_to_chunk:gmatch(".-\nBYPASS %d %d %d\n<.-\n(.-)\n>") do
        k_esc = esc(k)
        if k_esc ~= 'okallright' then t[#t+1] = k_esc end
      end
      
      for i = 1, #t do tr_to_chunk = tr_to_chunk:gsub(t[i], '') end
      tr_to_chunk = tr_to_chunk:gsub('okallright', fx_from_data)
      reaper.SetTrackStateChunk(tr_to, tr_to_chunk, 0)
    end
  end
  reaper.MB('Applied to '..x..' FX ---> '..fx_from_name_to_print,'Success',0)
  reaper.PreventUIRefresh(-111)
  reaper.Undo_EndBlock("Apply last touched FX parameters to suited FX", -1)
else reaper.defer(nothing) end
