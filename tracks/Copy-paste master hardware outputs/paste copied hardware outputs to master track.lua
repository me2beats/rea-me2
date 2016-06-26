function nothing() end

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
  str_esc = str_esc:gsub('/', '%%/')
  return str_esc
end

hwout = reaper.GetExtState("me2beats_copy-paste", "master_hwout")
if hwout and hwout ~= '' then
  reaper.Undo_BeginBlock()
  if hwout == 'empty' then hwout = '' end
  t = {}
  master = reaper.GetMasterTrack(0)
  _, chunk = reaper.GetTrackStateChunk(master, '', 0)
  for k in chunk:gmatch('BYPASS.-\n<.-\n(.-)>\nFLOAT ') do t[#t+1] = k end
  for i = 1, #t do chunk = chunk:gsub(esc(t[i]),'') end
  if chunk:find('\nHWOUT ') then
    hwout_old = chunk:match('\nMAINSEND .-\n(.-)\n<FXCHAIN')
    if not hwout_old then hwout_old = chunk:match('\nMAINSEND .-\n(.-)\n>') end
  else hwout_old = '' end
  if hwout_old == '' then
    second_way = chunk:match('(\nMAINSEND.-)\n')
    chunk = chunk:gsub(second_way, second_way..'\n'..hwout)
  else chunk = chunk:gsub(esc(hwout_old), hwout) end
  reaper.SetTrackStateChunk(master, chunk, 0)
  reaper.Undo_EndBlock('Paste copied hardware outputs to master', -1)
else reaper.defer(nothing) end
