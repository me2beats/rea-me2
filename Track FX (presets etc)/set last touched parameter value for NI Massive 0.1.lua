local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

local retval, trnum, fxnum, p = r.GetLastTouchedFX()
if retval == true and trnum ~= -1 then
  local tr = r.GetTrack(0,trnum-1)
  local _, param_name = r.TrackFX_GetParamName(tr, fxnum, p, 0)
  local old_val, minval, maxval = r.TrackFX_GetParam(tr, fxnum, p)

  if param_name:match'OSC%d%-PITCH' or param_name:match'MOD.OSC%-PITCH' then

    local retval, retvals_csv = r.GetUserInputs("Set last touched parameter value", 2, param_name..',Nudge by', ",")

    if retval == true then
      local set, nudge = retvals_csv:match('(.*),(.*)')

      set = tonumber(set)
      nudge = tonumber(nudge)

      r.Undo_BeginBlock()

      if set then
        r.TrackFX_SetParam(tr, fxnum, p, (set+64)/128)
      else

        if nudge then
          r.TrackFX_SetParam(tr, fxnum, p, ((128*old_val-64)+nudge+64)/128)
        end
      end

      r.Undo_EndBlock('Set last touched param value Massive 0.1', -1)

    else bla() end
  else bla() end
else bla() end

-- works only with pitch now
