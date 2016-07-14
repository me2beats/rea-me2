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

item = reaper.GetSelectedMediaItem(0,0)
if item then
  _, chunk = reaper.GetItemStateChunk(item, '', 0)
  
  take = reaper.GetActiveTake(item)
  take_guid = reaper.BR_GetMediaItemTakeGUID(take)
  
  part = chunk:match(esc(take_guid)..'\n<SOURCE.->\n(.->)\nTAKE') or
  chunk:match(esc(take_guid)..'\n<SOURCE.->\n(.->)\n>')
  
  if part then
    if part:match('^<.-ENV\n') then
      reaper.SetExtState("me2beats_copy-paste", "take_envelopes", part, 0)
    end
  end
end
