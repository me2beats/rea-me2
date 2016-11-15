tp = 'test'

local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

function os_file_data (path, addstr)
--needs OS == r.GetOS()

  if path then
    if addstr then
      if OS == 'Win32' or 'Win64' then file = path:gsub([==[\]==], [==[\\]==])..[[\\]]..addstr
      else file = path..[[/]]..addstr end
    else
      if OS == 'Win32' or 'Win64' then file = path:gsub([==[\]==], [==[\\]==])
      else file = path end
    end
  end
  path, addstr = nil, nil
  if r.file_exists(file) then
    file_open = io.open(file, 'r'); data = file_open:read('*a'); file_open:close()
  return file, data
  else return file end
end


res_path = r.GetResourcePath()

OS = r.GetOS()


if OS == 'Win32' or 'Win64' then
  tp_path = res_path..[[\TrackTemplates]]
else tp_path = res_path..[[/TrackTemplates]] end


for i = 0, 1000 do
  fn = r.EnumerateFiles(tp_path, i)
  if not fn or fn == '' then break
  elseif fn == tp..[[.RTrackTemplate]] then
    _, tp_data = os_file_data(tp_path,fn)
    if tp_data then
      r.Undo_BeginBlock()

      for chunk in tp_data:gmatch'(<TRACK.->)' do
        tracks = r.CountTracks(0)
        r.InsertTrackAtIndex(tracks, 0)
        tr = r.GetTrack(0,tracks)
        r.SetTrackStateChunk(tr, chunk, 0)
      end
      
      r.TrackList_AdjustWindows(0)

      r.Undo_EndBlock('import tracks from track template', -1)

    end
  break end
end


