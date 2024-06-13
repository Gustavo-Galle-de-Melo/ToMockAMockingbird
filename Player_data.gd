class_name Player_data

var known_birds: Dictionary # dictionary of {symbol: is known}: [String, bool]
var level_stars: Array[bool]
var level_beaten: Array[bool]
var section: int # latest unlocked section

# the level the player is playing
# this is used by the level scene to know what level to load
var playing_level: int

static var instance: Player_data


static func get_instance() -> Player_data:
	if not instance:
		instance = new()
	return instance


# TODO: read some file
func _init() -> void:
	for bird in Bird_list.all_birds:
		known_birds[bird.symbol] = false
	level_stars = []
	level_stars.resize(len(Level_loader.levels))
	level_stars.fill(false)
	level_beaten = []
	level_beaten.resize(len(Level_loader.levels))
	level_beaten.fill(false)
	set_section(1)


func is_known(bird: Simple_bird) -> bool:
	return known_birds[bird.symbol]


func set_known(bird: String) -> void:
	known_birds[bird] = true


func has_star(level: int) -> bool:
	return level_stars[level - 1]


func set_star(level: int) -> void:
	level_stars[level - 1] = true


func has_beaten_level(level: int) -> bool:
	return level_beaten[level - 1]


func set_level_beaten(level: int) -> void:
	level_beaten[level - 1] = true
	
	# test whether a new section should be unlocked
	var first_unbeaten_level: int = -1
	for i in len(level_beaten):
		if not level_beaten[i]:
			first_unbeaten_level = i + 1
			break
	
	if first_unbeaten_level == -1:
		return
	
	set_section(Level_loader.get_level_section(first_unbeaten_level))


func set_section(section: int) -> void:
	self.section = max(self.section, section)
	for s in section:
		for bird in Level_loader.section_birds[s]:
			set_known(bird)
