dialogueLines = {}

local dialoguePath = 'resources/dialogues/'
local dialoguePattern = '[%w%d%s%!%.%,%:%;%-]+'

function ReadFiles()
  for i=1,1 do
    dialogueLines[i] = {}
    io.input(dialoguePath..'dialogue_'..i..'.txt')

    local count = 1
    for line in io.lines() do
      local m = string.match(line, dialoguePattern)
      if line ~= m then
        print(m)
        dialogueLines[i][count] = m
        count = count + 1
      else
        print("Pattern doesn't match")
      end
    end
  end
end


ReadFiles()
