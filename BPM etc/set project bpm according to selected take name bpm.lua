local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end;

it = r.GetSelectedMediaItem(0,0)
if it then
  tk = r.GetActiveTake(it)
  if tk then
    _, it_name =  r.GetSetMediaItemTakeInfo_String(tk, 'P_NAME', 0, 0)
    for bpm in it_name:gmatch'%d+' do
      bpm = tonumber(bpm)
      if bpm <= 200 and bpm >= 50 then found = bpm break end
    end
    if found then
      r.Undo_BeginBlock()
      r.SetCurrentBPM(0, found, 1)
      r.Undo_EndBlock('Set bpm', -1)
    else bla() end
  else bla() end
else bla() end
