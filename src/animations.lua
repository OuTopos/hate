local list = {}

-- Humanoid
list.humanoid_stand_left   = {delay = 0.08, first = 118, last = 118, loop = true, finish = false, reverse = false}
list.humanoid_stand_right  = {delay = 0.08, first = 144, last = 144, loop = true, finish = false, reverse = false}
list.humanoid_stand_up     = {delay = 0.08, first = 105, last = 105, loop = true, finish = false, reverse = false}
list.humanoid_stand_down   = {delay = 0.08, first = 131, last = 131, loop = true, finish = false, reverse = false}

list.humanoid_walk_left    = {delay = 0.08, first = 119, last = 126, loop = true, finish = false, reverse = false}
list.humanoid_walk_right   = {delay = 0.08, first = 145, last = 152, loop = true, finish = false, reverse = false}
list.humanoid_walk_up      = {delay = 0.08, first = 106, last = 113, loop = true, finish = false, reverse = false}
list.humanoid_walk_down    = {delay = 0.08, first = 132, last = 139, loop = true, finish = false, reverse = false}

list.humanoid_sword_left    = {delay = 0.04, first = 171, last = 175, loop = false, finish = true, reverse = false}
list.humanoid_sword_right   = {delay = 0.04, first = 197, last = 201, loop = false, finish = true, reverse = false}
list.humanoid_sword_up      = {delay = 0.04, first = 158, last = 162, loop = false, finish = true, reverse = false}
list.humanoid_sword_down    = {delay = 0.04, first = 184, last = 188, loop = false, finish = true, reverse = false}


list.humanoid_die          = {delay = 0.08, first = 261, last = 266, loop = false, finish = true, reverse = false}

-- Eyeball
list.eyeball_walk_left   = {delay = 0.2, first = 4, last = 6, loop = true, finish = false, reverse = false}
list.eyeball_walk_right  = {delay = 0.2, first = 10, last = 12, loop = true, finish = false, reverse = false}
list.eyeball_walk_up     = {delay = 0.2, first = 1, last = 3, loop = true, finish = false, reverse = false}
list.eyeball_walk_down   = {delay = 0.2, first = 7, last = 9, loop = true, finish = false, reverse = false}

list.elisa_walk         = {delay = 0.08, first = 17, last = 24, loop = true, finish = false, reverse = false}
list.elisa_jump         = {delay = 0.08, first = 106, last = 113, loop = true, finish = false, reverse = false}
list.elisa_idle         = {delay = 0.20, first = 1, last = 3, loop = true, finish = false, reverse = false}



list.coin              = {delay = 0.10, first = 1, last = 8, loop = true, finish = false, reverse = false}

return list