# class that defines all important birds
class_name Bird_list


# these are here to make the bird definitions cleaner
static var x = Var.new(0)
static var y = Var.new(1)
static var z = Var.new(2)
static var w = Var.new(3)
static var v = Var.new(4)

static func app(left: Bird, right: Bird) -> Bird:
	return Apply.new(left, right)



# definition of all birds
static var albatross	: Simple_bird = Simple_bird.new("Albatross"		, "A", 2, y) # this doesn't have a name in the book
static var bluebird		: Simple_bird = Simple_bird.new("Bluebird"		, "B", 3, app(x, app(y, z)))
static var cardinal		: Simple_bird = Simple_bird.new("Cardinal"		, "C", 3, app(app(x, z), y))
static var dove			: Simple_bird = Simple_bird.new("Dove"			, "D", 4, app(x, app(app(y, z), w))) # this is a Blackbird (B_1) in the book, the actual Dove is D x y z w = x y (z w)
# E
static var finch		: Simple_bird = Simple_bird.new("Finch"			, "F", 3, app(app(z, y), x))
# G
# H
# I
static var jay			: Simple_bird = Simple_bird.new("Jay"			, "J", 2, app(y, y)) # the actual Jay is another bird in the book
static var kestrel		: Simple_bird = Simple_bird.new("Kestrel"		, "K", 2, x)
static var lark			: Simple_bird = Simple_bird.new("Lark"			, "L", 2, app(x, app(y, y)))
static var mockingbird	: Simple_bird = Simple_bird.new("Mockingbird"	, "M", 1, app(x, x))
static var nightingale	: Simple_bird = Simple_bird.new("Nightingale"	, "N", 2, app(x, app(x, y))) # this doesn't appear in the book
static var owl			: Simple_bird = Simple_bird.new("Owl"			, "O", 2, app(y, app(x, y)))
static var parrot		: Simple_bird = Simple_bird.new("Parrot"		, "P", 1, x) # this is called Idiot Bird in the book
static var quail		: Simple_bird = Simple_bird.new("Quail"			, "Q", 3, app(y, app(x, z))) # this is called Queer Bird in the book
static var robin		: Simple_bird = Simple_bird.new("Robin"			, "R", 3, app(app(y, z), x))
static var starling		: Simple_bird = Simple_bird.new("Starling"		, "S", 3, app(app(x, z), app(y, z)))
static var thrush		: Simple_bird = Simple_bird.new("Thrush"		, "T", 2, app(y, x))
# U
# V
static var warbler		: Simple_bird = Simple_bird.new("Warbler"		, "W", 2, app(app(x, y), y))
# X
# Y
# Z

static var all_birds: Array[Simple_bird] = [
	albatross,
	bluebird,
	cardinal,
	dove,
	finch,
	jay,
	kestrel,
	lark,
	mockingbird,
	nightingale,
	owl,
	parrot,
	quail,
	robin,
	starling,
	thrush,
	warbler,
]


static func get_image(bird: Bird) -> Texture:
	if bird is Simple_bird:
		return load("res://assets/" + bird.full_name + ".png")
	else:
		return preload("res://assets/Null.png")


static func get_bird_instance(bird: Simple_bird) -> Bird_instance:
	var image: Texture = get_image(bird)
	if not image:
		image = preload("res://assets/Null.png")
	var bird_instance: Bird_instance = preload("res://Birds/bird_instance.tscn").instantiate()
	bird_instance.set_params(image, bird, bird)
	return bird_instance


static func get_bird_from_symbol(symbol: String) -> Simple_bird:
	for bird in all_birds:
		if bird.symbol == symbol:
			return bird
	return null


static func get_bird_from_expression(expression: Bird, next_var: int) -> Simple_bird:
	for bird in all_birds:
		# find out what this bird does
		var expr: Bird = bird
		for i in next_var:
			expr = Apply.new(expr, Var.new(i))
		var result: Bird = expr.eval().new_bird
		# compare to the expected expression
		if result.equals(expression):
			return bird
	return null
