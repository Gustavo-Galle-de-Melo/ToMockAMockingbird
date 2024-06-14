class_name Level_data

var section: int
var birds: String
var goal: String
var star: int
var hint: String

# this is set at runtime
var number: int

func _init(section: int, birds: String, goal: String, star: int, hint: String) -> void:
	self.section = section
	self.birds = birds
	self.goal = goal
	self.star = star
	self.hint = hint
