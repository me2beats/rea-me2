local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

function act(id) r.Main_OnCommand(id, 0) end

local window, segment, details = r.BR_GetMouseCursorContext()
if window ~= 'ruler' then bla() return end

_,_,_,_,_,_,val = r.get_action_context()

r.Undo_BeginBlock()
if val > 0 then act(1012) else act(1011) end
r.Undo_EndBlock('zoom horizontally', 2)
