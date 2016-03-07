function nothing() end

---0.-----preparation---------------------------------------------------------------------

---0.1----get notes, create tables--------------------------------------------------------

act_editor = reaper.MIDIEditor_GetActive()
if act_editor ~= nil then
  take = reaper.MIDIEditor_GetTake(act_editor)
  if take ~= nil then
  
    script_title = 'Auto-arranger 0.1'
    reaper.Undo_BeginBlock()
  
    chords_tab_hard = {
    {{1,3,6,8,10,11}, {0,4,7},  'Cmaj'}, 
    {{0,2,4,7,9,11},  {1,5,8},  'C#maj'}, 
    {{0,1,3,5,8,10},  {2,6,9},  'Dmaj'}, 
    {{1,2,4,6,9,11},  {3,7,10}, 'D#maj'}, 
    {{0,2,3,5,7,10},  {4,8,11}, 'Emaj'}, 
    {{1,3,4,6,8,11},  {5,9,0},  'Fmaj'}, 
    {{0,2,4,5,7,9},   {6,10,1}, 'F#maj'}, 
    {{1,3,5,6,8,10},  {7,11,2}, 'Gmaj'}, 
    {{2,4,6,7,9,11},  {8,0,3},  'G#maj'}, 
    {{0,3,5,7,8,10},  {9,1,4},  'Amaj'}, 
    {{1,4,6,8,9,11},  {10,2,5}, 'A#maj'}, 
    {{0,2,5,7,9,10},  {11,3,6}, 'Bmaj'}, 
    {{1,2,4,6,9,10},  {0,3,7},  'C'}, 
    {{2,3,5,7,10,11}, {1,4,8},  'C#'}, 
    {{0,3,4,6,8,11},  {2,5,9},  'D'}, 
    {{0,1,4,5,7,9},   {3,6,10}, 'D#'}, 
    {{1,2,5,6,8,10},  {4,7,11}, 'E'}, 
    {{2,3,6,7,9,11},  {5,8,0},  'F'}, 
    {{0,3,4,7,8,10},  {6,9,1},  'F#'}, 
    {{1,4,5,8,9,11},  {7,10,2}, 'G'}, 
    {{0,2,5,6,9,10},  {8,11,3}, 'G#'}, 
    {{1,3,6,7,10,11}, {9,0,4},  'A'}, 
    {{0,2,4,7,8,11},  {10,1,5}, 'A#'}, 
    {{0,1,3,5,8,9},   {11,2,6}, 'B'}}


---0.2------get notes and insert them in notes_table--------------------------------------

    notes_tab = {}
    _, notes = reaper.MIDI_CountEvts(take)
    for n = 0, notes-1 do
      _, _, _, startpos, endpos, _, pitch = reaper.MIDI_GetNote(take, n)
      table.insert(notes_tab, {startpos, endpos, pitch})
    end


---0.3----create prefiltered pitch tab----------------------------------------------------

    pre_tab = {}
    for n = 1, #notes_tab do
      table.insert(pre_tab, notes_tab[n][3])
    end


---0.4----create equivalent prefiltered pitch tab-----------------------------------------

    eq_pre_tab = {}
    for e = 1, #pre_tab do
      ok = 0
      eq = pre_tab[e]
      while ok == 0 do
        if eq < 12 then
          table.insert(eq_pre_tab, eq)
          ok = 1
          break
        else
          eq = eq-12
        end
      end
    end
    pre_tab = nil


---0.5----create equivalent filtered pitch tab--------------------------------------------

    eq_tab = {}
    for n = 1, #eq_pre_tab do
      found = 0
      for p = 1, #eq_tab do
        if eq_pre_tab[n] == eq_tab[p] then
          found = 1
          break
        end
      end
      if found == 0 then
        table.insert(eq_tab, eq_pre_tab[n])
      end
    end


---1.------determine key------------------------------------------------------------------

---1.1.----looking for 'easy keys'--------------------------------------------------------

    if eq_pre_tab[1] == eq_pre_tab[#eq_pre_tab] then
      for c = 1, 12 do
        if chords_tab_hard[c][2][1] == eq_pre_tab[1] then
          easy_key_1 = chords_tab_hard[c][3]
        end
      end
      for c = 13, 24 do
        if chords_tab_hard[c][2][1] == eq_pre_tab[1] then
          easy_key_2 = chords_tab_hard[c][3]
        end
      end
    end


---1.2.----create key_eq_tab--------------------------------------------------------------

    key_eq_tab = {}
    if #eq_tab >= 3 then
      for i = 1, 3 do
        table.insert(key_eq_tab,eq_tab[i])
      end
    end


---1.3.----create cand_tab----------------------------------------------------------------

---1.3.1.--if everything will be ok-------------------------------------------------------

    cand_tab = {}
    matches_tab = {}
    level = 0
    for c = 1, #chords_tab_hard do
      if level == 3 then
        break
      else
        level = 0
      end
      for k = 1, #key_eq_tab do
        for i = 1, 3 do
          if level == 3 then
            break
          end
          if key_eq_tab[k] == chords_tab_hard[c][2][i] then
            level = level+1
            inserted = 0
            
            if level == 3 then
              cand_tab = {}
              table.insert(cand_tab, chords_tab_hard[c][3])
            break
            elseif level == 2 then
              y = key_eq_tab[k]
            elseif level == 1 then
              y = nil
              x = key_eq_tab[k]
            end
            if level == 2 then
              for b = 1, #key_eq_tab do
                if key_eq_tab[b] ~= x and key_eq_tab[b] ~= y then
                  z = key_eq_tab[b]
                end
              end
              found = 0
              for i = 1, #chords_tab_hard[c][1] do
                if z == chords_tab_hard[c][1][i] then
                  found = 1                  
                  break
                end
              end
              if found == 0 then
                table.insert(cand_tab, chords_tab_hard[c][3])
              end
            end
          end
        end
      end
    end

    if #cand_tab >= 2 then


---1.3.2--have we got easy_keys?----------------------------------------------------------

      if easy_key_1 ~= nil then
        for i = 1, #cand_tab do
          if cand_tab[i] == easy_key_1 then
            cand_tab = {}
            table.insert(cand_tab, easy_key_1)
          elseif cand_tab[i] == easy_key_2 then
            cand_tab = {}
            table.insert(cand_tab, easy_key_2)
          end
        end
      else


---1.3.3--else we can create key_eq_tab (4 notes) and new cand_tab------------------------

        if #eq_tab >= 4 then
          found = 0
          for i = #eq_pre_tab, 1, -1 do
            for e = 1, #key_eq_tab do
              if key_eq_tab[e] ~= eq_pre_tab[i] then
                found = 1
                table.insert(key_eq_tab,eq_pre_tab[i])
                break
              end
            end
            if found == 1 then
              break
            end
          end
        end

        cand_tab = {}
        matches_tab = {}
        level = 0
        for c = 1, #chords_tab_hard do
          if level == 3 then
            break
          else
            level = 0
          end
          for k = 1, #key_eq_tab do
            for i = 1, 3 do
              if level == 3 then
                break
              end
              if key_eq_tab[k] == chords_tab_hard[c][2][i] then
                level = level+1
                inserted = 0
              
                if level == 3 then
                  z = key_eq_tab[k]
                
                  for b = 1, #key_eq_tab do
                    if key_eq_tab[b] ~= x and key_eq_tab[b] ~= y and key_eq_tab[b] ~= z then
                      z = key_eq_tab[b]
                    end
                  end
                  found = 0
                  for i = 1, #chords_tab_hard[c][1] do
                    if z == chords_tab_hard[c][1][i] then
                      found = 1                  
                      break
                    end
                  end
                  if found == 0 then
                    cand_tab = {}
                    table.insert(cand_tab, chords_tab_hard[c][3])
                  end
                  break
                end
              end
            end
          end
        end
      end
    end

    if cand_tab[1] ~= nil then
      reaper.MB('The key is:  '..cand_tab[1]..'' ,'',0)
    end

    reaper.Undo_EndBlock(script_title, -1)

  else
    reaper.defer(nothing)
  end
else
  reaper.defer(nothing)
end
