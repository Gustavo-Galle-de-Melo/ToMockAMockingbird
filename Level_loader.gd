class_name Level_loader

# levels are numbered at runtime
# this way they can be reordered more easily
static var are_levels_numbered: bool = false
static var numbered_levels: Array[Level_data] = []


# array of Level_data and Tutorial_data
static var levels_and_tutorials: Array = [
# sandbox
	Level_data.new(2, "", "", 0, ""),

# tutorial
# new: C, P, T
	Tutorial_data.new(1, "Introduction to birds", "res://Tutorials/introduction1.tscn"),
	Tutorial_data.new(1, "How to play", "res://Tutorials/how_to_play1.tscn"),
	Level_data.new(1, "CT", "P", 2, ""),
	# P = C T
	Level_data.new(1, "CP", "T", 2, ""),
	# T = C P

# new: R
	Tutorial_data.new(2, "Robin", "res://Tutorials/tutorial_robin.tscn"),
	Level_data.new(2, "CPT", "R", 2, ""),
	# R = C C
	Level_data.new(2, "R", "C", 3, ""),
	# C = R R R
	Level_data.new(2, "PR", "T", 3, ""),
	# T = R P R
	Level_data.new(2, "RT", "P", 3, ""),
	# P = R T R

# new: A, K
	Tutorial_data.new(3, "Albatross and Kestrel", "res://Tutorials/tutorial_albatross_kestrel.tscn"),
	Level_data.new(3, "A", "P", 2, ""),
	# P = A _
	Level_data.new(3, "KP", "A", 2, ""),
	# A = K P
	Level_data.new(3, "AC", "K", 2, ""),
	# K = C A
	Level_data.new(3, "CK", "A", 2, ""),
	# A = C K
	Level_data.new(3, "CK", "P", 3, ""),
	# P = C K _
	Level_data.new(3, "KR", "P", 3, ""),
	# P = R _ K

# new: M, W
	Tutorial_data.new(4, "Mockingbird and Warbler", "res://Tutorials/tutorial_mockingbird_warbler.tscn"),
	Level_data.new(4, "PW", "M", 2, ""),
	# M = W P
	Level_data.new(4, "TW", "M", 2, ""),
	# M = W T
	Level_data.new(4, "KW", "P", 2, ""),
	# P = W K
	Level_data.new(4, "KW", "M", 3, ""),
	# M = W P {P = W K}
	Level_data.new(4, "KW", "A", 3, ""),
	# A = K P {P = W K}

# new: B
	Tutorial_data.new(5, "Bluebird", "res://Tutorials/tutorial_bluebird.tscn"),
	Level_data.new(5, "BC", "P", 3, ""),
	# P = B C C
	Level_data.new(5, "BR", "P", 7, ""),
	# P = B C C {C = R R R}
	Level_data.new(5, "BKM", "P", 3, ""),
	# P = B M K
	Level_data.new(5, "BT", "R", 3, ""),
	# R = B B T
	Level_data.new(5, "BT", "P", 6, ""),
	# P = B (T T) R {R = B B T}
	Level_data.new(5, "BT", "C", 8, ""),
	# C = B (T R) R {R = B B T}

# new: Q
	Tutorial_data.new(6, "Quail", "res://Tutorials/tutorial_quail.tscn"),
	Level_data.new(6, "BC", "Q", 2, ""),
	# Q = C B
	Level_data.new(6, "CQ", "B", 2, ""),
	# B = C Q
	Level_data.new(6, "CQ", "P", 3, ""),
	# P = Q C C
	Level_data.new(6, "QT", "C", 4, ""),
	# C = Q Q (Q T)
	Level_data.new(6, "QT", "B", 4, ""),
	# C = Q T (Q Q)

# new: L
	Tutorial_data.new(7, "Lark", "res://Tutorials/tutorial_lark.tscn"),
	Level_data.new(7, "LP", "M", 2, ""),
	# M = L P
	Level_data.new(7, "QM", "L", 2, ""),
	# L = Q M
	Level_data.new(7, "BW", "L", 3, ""),
	# L = B W B
	Level_data.new(7, "BMR", "L", 3, ""),
	# L = R M B
	Level_data.new(7, "KLQ", "P", 4, ""),
	# P = Q L (Q K)

# new: J
	Tutorial_data.new(8, "Jay", "res://Tutorials/tutorial_jay.tscn"),
	Level_data.new(8, "J", "M", 2, ""),
	# M = J _
	Level_data.new(8, "KM", "J", 2, ""),
	# J = K M
	Level_data.new(8, "CJP", "A", 3, ""),
	# A = C J P
	Level_data.new(8, "CKL", "J", 3, ""),
	# J = C (L K)

# new: O
	Tutorial_data.new(9, "Owl", "res://Tutorials/tutorial_owl1.tscn"),
	Level_data.new(9, "OP", "M", 2, ""),
	# M = O P
	Level_data.new(9, "QW", "O", 3, ""),
	# O = Q Q W
	Level_data.new(9, "BKO", "T", 3, ""),
	# T = B O K
	Level_data.new(9, "KOQ", "T", 3, ""),
	# T = Q K O
	Level_data.new(9, "KQW", "T", 5, ""),
	# T = Q (Q K Q) W = Q K (Q Q W)

# new: D
	Tutorial_data.new(10, "Dove", "res://Tutorials/tutorial_dove.tscn"),
	Level_data.new(10, "B", "D", 3, ""),
	# D = B B B
	Level_data.new(10, "DKO", "T", 5, ""),
	# T = D O (K K) _
	Level_data.new(10, "ADO", "J", 5, ""),
	# J = D O P A {P = A _}
	Level_data.new(10, "CD", "P", 5, ""),
	# P = D C C R {R = C C}
	Level_data.new(10, "CD", "B", 7, ""),
	# B = C D P {P = D C C R, R = C C}

# new: N
	Tutorial_data.new(11, "Nightingale", "res://Tutorials/tutorial_nightingale.tscn"),
	Level_data.new(11, "BW", "N", 2, ""),
	# N = W B
	Level_data.new(11, "QW", "N", 2, ""),
	# N = W Q
	Level_data.new(11, "CN", "P", 2, ""),
	# P = N C
	Level_data.new(11, "CN", "T", 3, ""),
	# T = C P {P = N C}
	Level_data.new(11, "BCN", "W", 6, ""),
	# W = C (B N T) {T = C P, P = N C}
	Level_data.new(11, "BNT", "M", 6, ""),
	# M = B (T T) (B N T)
	Level_data.new(11, "CN", "W", 7, ""),
	# W = C (C (N T) N) {T = C P, P = N C}

# new: S
	Tutorial_data.new(12, "Starling", "res://Tutorials/tutorial_starling.tscn"),
	Level_data.new(12, "SP", "O", 2, ""),
	# O = S P
	Level_data.new(12, "ST", "W", 2, ""),
	# W = S T
	Level_data.new(12, "PS", "M", 3, ""),
	# M = O P {O = S P}
	Level_data.new(12, "ST", "M", 3, ""),
	# M = W T {W = S T}
	Level_data.new(12, "BPS", "N", 3, ""),
	# N = S B P
	Level_data.new(12, "PQS", "N", 3, ""),
	# N = S Q P
	Level_data.new(12, "BJS", "L", 3, ""),
	# L = S B J
	Level_data.new(12, "BCW", "S", 6, ""),
	# S = B (B W) (B B C)
	Level_data.new(12, "DQW", "S", 6, ""),
	# S = D W (Q Q (Q Q))
	Level_data.new(12, "AS", "W", 3, ""),
	# W = S S A
	Level_data.new(12, "SR", "W", 5, ""),
	# W = R (S R R) R

# new: F
	Tutorial_data.new(13, "Finch", "res://Tutorials/tutorial_finch.tscn"),
	Level_data.new(13, "BC", "F", 4, ""),
	# F = B C R {R = C C}
	Level_data.new(13, "CD", "F", 4, ""),
	# F = D C C C				# bad 15: # F = D (C D T) C P {T = C P, P = D C C R, R = C C}
	Level_data.new(13, "DF", "P", 7, ""),
	# P = D (F F F) (D D) F
	Level_data.new(13, "DFJP", "A", 6, ""),
	# A = D (F P P) P J
	Level_data.new(13, "DFJ", "A", 12, ""),
	# A = D (F P J) F J {P = D (F F F) (D D) F}
	Level_data.new(13, "FPQ", "T", 8, ""),
	# T = Q (Q F Q) (F P (Q Q))
	Level_data.new(13, "CN", "F", 6, ""),
	# F = C (N R) R {R = C C}	# 7: F = C (C (N T) C) {T = C P, P = N C}
	
# turing completeness section:
	Tutorial_data.new(14, "All birds (TODO)", "res://Tutorials/tutorial_starling.tscn"),
	Level_data.new(14, "KS", "P", 3, ""),
	# P = A _ {A = S K}
	Level_data.new(14, "KS", "A", 2, ""),
	# A = S K
	Level_data.new(14, "KS", "O", 4, ""),
	# O = S P = {P = A K, A = S K}
	Level_data.new(14, "KS", "B", 4, ""),
	# B = S (K S) K
	Level_data.new(14, "KS", "W", 4, ""),
	# W = S S A {A = S K}
	Level_data.new(14, "KS", "T", 7, ""),
	# T = S (K O) K {O = S P, P = A _, A = S K}
	Level_data.new(14, "KS", "Q", 8, ""),
	# Q = S (K (S B)) K {B = S (K S) K}
	Level_data.new(14, "KS", "R", 8, ""),
	# R = S (K (S S)) (S (K K) K)
	Level_data.new(14, "KS", "C", 10, ""),
	# C = S (S (K S) (S (K K) S)) (K K)
	Level_data.new(14, "KS", "D", 10, ""),
	# D = S (K B) B {B = S (K S) K}
	Level_data.new(14, "KS", "F", 17, ""),
	# F = S (K (S (S (K S) (S (K O) K)))) (S (K K) K) {O = S P, P = A _, A = S K}
	
	Level_data.new(14, "KS", "L", 10, ""),
	# S (K W) B {W = S S A, A = S K, B = S (K S) K}		# 13: L = S B J {B = S (K S) K, J = K M, M = S P P, P = A _, A = S K}
	Level_data.new(14, "KS", "N", 7, ""),
	# N = S (S (K (S S)) K) K		# 8: N = S B P {B = S (K S) K, P = A _, A = S K}
	Level_data.new(14, "KS", "M", 6, ""),
	# M = S (S S) S A {A = S K}		# 7: S P P {P = A _, A = S K}
	Level_data.new(14, "KS", "J", 7, ""),
	# J = K M {M = S (S S) S A, A = S L} = S (S B K)	# 8: J = K M {M = O P, O = S P, P = A _, A = S K}
	
# hardest levels:
	Tutorial_data.new(15, "Final challenges (TODO)", "res://Tutorials/tutorial_starling.tscn"),
	Level_data.new(15, "BCM", "W", 5, ""),
	# W = C (B M R) {R = C C}
	Level_data.new(15, "KMQ", "T", 11, ""),
	# T = Q (Q (Q (Q K Q) Q) (Q J)) M {J = K M}
	Level_data.new(15, "FKQ", "C", 15, ""),
	# C = Q (Q (Q Q Q) (F K Q)) (Q (F Q) (Q (Q F Q)))
	Level_data.new(15, "BF", "C", 15, ""),
	# C = B (B (F (B (B (B B) F) F) F) (B (B B B))) F	# 16: C = B (F (B (B B) F) F) (B (B B) (B F (B (B B) F)))
	Level_data.new(15, "DT", "R", 21, ""),
	# R = D (T (D (T T) (D (D (T T)) (D (T T) (D D))) T)) (D (T T) (D D)) T
	Level_data.new(15, "ADFM", "T", 18, ""),
	# T = D (F F (D M P)) (D (F A A) (D M (D F (D D)))) F {P = A _}
	Level_data.new(15, "DFK", "B", 18, ""),
	# B = D (F _ (K K)) (D (D (F _ _))) (D (D K) (D D (K D) _))
	Level_data.new(15, "CJS", "P", 8, ""),
	# P = C (S (C J C) C) R {R = C C}		# bad 8: P = S (S (C J C) C) (C J C) = S (C S) (C S C) (C J C)
	Level_data.new(15, "CFKNOW", "L", 11, ""),
	# L = C (C (C (N (W F)) (K O)) T) {T = C P, P = N C}
	Level_data.new(15, "CFKNO", "B", 38, ""),
	# B = C (C (N (T (C (N (C (C (T K) (C (C (N F) N) P)))) (T (C O (R (C (K (C O T)))))))) P) C) {T = C P, P = N C, R = C C}
	
	Level_data.new(15, "ADS", "K", 5, ""),
	# K = S D (D A _)				# F10: K = D (F A P) (D D (S F)) A {P = A _}
	Level_data.new(15, "FQ", "P", 10, ""),
	# !!! P = Q (F (Q F)) (Q (Q F (Q Q Q)))		# 11: P = Q (Q F Q) (F Q (F (Q F) (Q F)))
	Tutorial_data.new(15, "The end (TODO)", "res://Tutorials/tutorial_starling.tscn"),
]

# 1-indexed
static var section_birds: Array[String] = [
	"CPT",	# 1
	"R",	# 2
	"AK",	# 3
	"MW",	# 4
	"B",	# 5
	"Q",	# 6
	"L",	# 7
	"J",	# 8
	"O",	# 9
	"D",	# 10
	"N",	# 11
	"S",	# 12
	"F",	# 13
	"",		# 14
	"",		# 15
]


static func number_levels() -> void:
	if are_levels_numbered:
		return
	
	var number: int = 0
	
	for level in levels_and_tutorials:
		if level is Level_data:
			level.number = number
			numbered_levels.append(level)
			number += 1
	
	are_levels_numbered = true


# the last bird in the list is the goal
static func get_level_birds(level: int) -> Array[Simple_bird]:
	number_levels()
	var level_data: Level_data = numbered_levels[level]
	var available_birds: String = level_data.birds
	var bird_list: Array[Simple_bird] = []
	
	# add available birds to the list
	for bird_symbol in available_birds:
		var bird: Simple_bird = Bird_list.get_bird_from_symbol(bird_symbol)
		bird_list.append(bird)
	
	# add the goal
	var goal_symbol: String = level_data.goal
	var goal: Simple_bird = Bird_list.get_bird_from_symbol(goal_symbol)
	bird_list.append(goal)
	
	return bird_list


# the player needs to find a solution this short or shorter to get a star
static func get_level_star_size(level: int) -> int:
	number_levels()
	return numbered_levels[level].star


static func get_level_name(level: int) -> String:
	number_levels()
	var available_birds: String = numbered_levels[level].birds
	var name: String = ""
	
	for bird in available_birds:
		name += bird + " "
	
	name += "\u2794 " + numbered_levels[level].goal
	
	return name


static func get_level_section(level: int) -> int:
	number_levels()
	return numbered_levels[level].section
