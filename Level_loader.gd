class_name Level_loader


# [<section>, "<goal> = <available birds>", <solution size for star>]
static var levels: Array[Array] = [
	# tutorial
	# new: C, P, T
	[1, "T=CP", 2],		# T = C P
	[1, "P=CT", 2],		# P = C T
	# new: R
	[2, "R=CPT", 2],	# R = C C
	[2, "C=R", 3],		# C = R R R
	[2, "T=PR", 3],		# T = R P R
	[2, "P=RT", 3],		# T = R T R
	# new: A, K
	[3, "P=A", 2],		# P = A _
	[3, "A=KP", 2],		# A = K P
	[3, "K=AC", 2],		# K = C A
	[3, "A=CK", 2],		# A = C K
	[3, "P=CK", 3],		# P = C K _
	[3, "P=KR", 3],		# P = R _ K
	# new: M, W
	[4, "M=PW", 2],		# M = W P
	[4, "M=TW", 2],		# M = W T
	[4, "P=AW", 2],		# P = W A
	[4, "P=KW", 2],		# P = W K
	[4, "M=KW", 3],		# M = W P {P = W K}
	[4, "A=KW", 3],		# A = K P {P = W K}
	# new: B
	[1, "P=BC", 3],		# P = B C C # TODO
	[5, "P=BR", 7],		# P = B C C {C = R R R}
	[5, "P=BKM", 3],	# P = B M K
	[5, "R=BT", 3],		# R = B B T
	[5, "P=BT", 6],		# P = B (T T) R {R = B B T}
	[5, "C=BT", 8],		# C = B (T R) R {R = B B T}
	# new: Q
	[6, "Q=BC", 2],		# Q = C B
	[6, "B=CQ", 2],		# B = C Q
	[6, "P=CQ", 3],		# P = Q C C
	[6, "C=QT", 4],		# C = Q Q (Q T)
	[6, "B=QT", 4],		# C = Q T (Q Q)
	# new: L
	[7, "M=LP", 2],		# M = L P
	[7, "L=QM", 2],		# L = Q M
	[7, "L=BW", 3],		# L = B W B
	[7, "L=BMR", 3],	# L = R M B
	[7, "P=KLQ", 4],	# P = Q L (Q K)
	# new: J
	[8, "M=J", 2],		# M = J _
	[8, "J=KM", 2],		# J = K M
	[8, "A=CJP", 3],	# A = C J P
	[8, "J=CKL", 3],	# J = C (L K)
	# new: O
	[9, "M=OP", 2],		# M = O P
	[9, "O=QW", 3],		# O = Q Q W
	[9, "T=BKO", 3],	# T = B O K
	[9, "T=KOQ", 3],	# T = Q K O
	[9, "T=KQW", 5],	# T = Q (Q K Q) W
	# new: D
	[10, "D=B", 3],		# D = B B B
	[10, "T=DKO", 5],	# T = D O (K K) _
	[10, "J=ADO", 5],	# J = D O P A {P = A _}
	[10, "P=CD", 7],	# P = D C C R {R = C C}
	[10, "B=CD", 7],	# B = C D P {P = D C C R, R = C C}
	# new: N
	[11, "N=BW", 2],	# N = W B
	[11, "N=QW", 2],	# N = W Q
	[11, "P=CN", 2],	# P = N C
	[11, "T=CN", 3],	# T = C P {P = N C}
	[11, "W=BCN", 6],	# W = C (B N T) {T = C P, P = N C}
	[11, "M=BNPT", 6],	# M = B (T P) (B N T)
	[11, "W=CN", 7],	# W = C (C (N T) N) {T = C P, P = N C}
	# new: S
	[12, "O=SP", 2],	# O = S P
	[12, "W=ST", 2],	# W = S T
	[12, "M=PS", 3],	# M = O P {O = S P}
	[12, "M=ST", 3],	# M = W T {W = S T}
	[12, "N=BPS", 3],	# N = S B P
	[12, "N=PQS", 3],	# N = S Q P
	[12, "S=BCW", 6],	# S = B (B W) (B B C)
	[12, "W=AS", 3],	# W = S S A
	[12, "W=SR", 5],	# W = R (S R R) R
	# new: F
	[13, "F=BC", 4],	# F = B C R {R = C C}
	[13, "P=DF", 7],	# P = D (F F F) (D D) F
	[13, "A=DFJP", 6],	# A = D (F P P) P J
	[13, "A=DFJ", 12],	# A = D (F P J) F J {P = D (F F F) (D D) F}
	[13, "F=CD", 15],	# F = D (C D T) C P {T = C P, P = D C C R, R = C C}
	[13, "F=CN", 7],	# F = C (C (N T) C) {T = C P, P = N C}
	[13, "T=DFQ", 7],	# T = D (F P P) (D Q F)
	
	# turing completeness section:
	[14, "P=KS", 3],	# P = A K {A = S K}
	[14, "A=KS", 2],	# A = S K
	[14, "O=KS", 4],	# O = S P = {P = A K, A = S K}
	[14, "M=KS", 7],	# M = O P {O = S P, P = A _, A = S K}
	[14, "B=KS", 4],	# B = S (K S) K
	[14, "W=KS", 4],	# W = S S A {A = S K}
	[14, "T=KS", 7],	# T = S (K O) K {O = S P, P = A _, A = S K}
	[14, "J=KS", 8],	# J = K M {M = O P, O = S P, P = A _, A = S K}
	[14, "N=KS", 8],	# N = S B P {B = S (K S) K, P = A _, A = S K}
	[14, "Q=KS", 8],	# Q = S (K (S O)) K {O = S P, P = A _, A = S K}
	[14, "R=KS", 8],	# R = S (K (S S)) (S (K K) K)
	[14, "C=KS", 10],	# C = S (S (K S) (S (K K) S)) (K K)
	[14, "D=KS", 10],	# D = S (K B) B {B = S (K S) K}
	[14, "L=KS", 13],	# L = S B (K M) {B = S (K S) K, M = S P P, P = A _, A = S K}
	[14, "F=KS", 17],	# F = S (K (S (S (K S) (S (K (O K)))) (S (K K) K) {O = S P, P = A _, A = S K}
	
	# hardest levels:
	[15, "W=BCM", 5],	# W = C (B M R) {R = C C}
	[15, "K=ADFS", 10],	# K = D (F A P) (D D (S F)) A {P = A _}
	[15, "T=KMQ", 11],	# T = Q (Q (Q (Q K Q) Q) (Q (K M))) M
	[15, "C=FKQ", 15],	# C = Q (Q (Q Q Q) (F K Q)) (Q (F Q) (Q (Q F Q)))
	[15, "P=FQ", 11],	# P = Q (Q F Q) (F Q (F (Q F) (Q F)))
	[15, "R=DT", 21],	# R = D (T (D (T T) (D (D (T T)) (D (T T) (D D))) T)) (D (T T) (D D)) T
	[15, "C=BF", 22],	# C = B (F (B (B B) (B F (B (B B) F))) F) (B (B B) (B F (B (B (B B)) F)))
	[15, "T=ADFM", 18],	# T = D (F F (D M P)) (D (F A A) (D M (D F (D D)))) F {P = A _}
	[15, "B=DFK", 18],	# B = D (F _ (K K)) (D (D (F _ _))) (D (D K) (D D (K D) _))
	[15, "P=CJS", 9],	# P = S (S (C J C) C) (C J C) = S (C S) (C S C) (C J C)
	[15, "L=CFKNOW", 11],# L = C (C (C (N (W F)) (K O)) T) {T = C P, P = N C}
	[15, "B=CFKNO", 38],# B = C (C (N (T (C (N (C (C (T K) (C (C (N F) N) P)))) (T (C O (R (C (K (C O T)))))))) P) C) {T = C P, P = N C, R = C C}
]


# the last bird in the list is the goal
static func get_level_birds(level: int) -> Array[Simple_bird]:
	var level_string: String = levels[level - 1][1] # 1-indexed
	var bird_list: Array[Simple_bird] = []
	
	# add available birds to the list
	for i in range(2, len(level_string)):
		var bird_symbol: String = level_string[i]
		var bird: Simple_bird = Bird_list.get_bird_from_symbol(bird_symbol)
		bird_list.append(bird)
	
	# add the goal
	var goal_symbol: String = level_string[0]
	var goal: Simple_bird = Bird_list.get_bird_from_symbol(goal_symbol)
	bird_list.append(goal)
	
	return bird_list


# the player needs to find a solution this short or shorter to get a star
static func get_level_star_size(level: int) -> int:
	return levels[level - 1][2]


static func get_level_name(level: int) -> String:
	var level_string: String = levels[level - 1][1]
	var name: String = ""
	
	for i in range(2, len(level_string)):
		name += level_string[i] + " "
	
	name += "\u2794 " + level_string[0]
	
	return name


static func get_level_section(level: int) -> int:
	return levels[level - 1][0]
