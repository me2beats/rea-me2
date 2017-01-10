local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

local window, segment, details = r.BR_GetMouseCursorContext()
if segment ~= 'envelope' then bla() return end

r.Undo_BeginBlock()
r.Main_OnCommand(r.NamedCommandLookup('_BR_SEL_ENV_MOUSE'), 0)
r.Main_OnCommand(r.NamedCommandLookup('_BR_ENV_POINT_MOUSE_CURSOR'), 0)
r.Undo_EndBlock('Insert envelope point at mouse', -1)
