local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

item = r.BR_ItemAtMouseCursor()
if not item then bla() return end
take = r.GetActiveTake(item)
if not take then bla() return end

r.Undo_BeginBlock()
if r.TakeIsMIDI(take) == true then
  scr_name = 'Open MIDI'
  r.Main_OnCommand(40109, 0) -- open in primary external editor
else
  scr_name = 'Show item properties'
  r.Main_OnCommand(41589,0) -- toggle show media item/take properties
end
r.Undo_EndBlock(scr_name, -1)
