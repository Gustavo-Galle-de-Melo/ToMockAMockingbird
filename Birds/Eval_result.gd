# class for the result of Bird.eval()
class_name Eval_result

var new_bird: Bird
var rule: Bird
var string_before: String
var string_after: String


func _init(new_bird: Bird, rule: Bird, string_before: String, string_after: String) -> void:
	self.new_bird = new_bird
	self.rule = rule
	self.string_before = string_before
	self.string_after = string_after
