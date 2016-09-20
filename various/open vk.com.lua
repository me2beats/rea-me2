function open_URL(url)
  OS = reaper.GetOS()
  if OS == 'OSX32' or OS == 'OSX64' then os.execute('open '.. url)
  else os.execute('start '.. url) end
end

open_URL('http://vk.com')
