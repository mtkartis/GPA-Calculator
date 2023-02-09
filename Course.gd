class_name Course
extends MarginContainer


const UTIL = preload("res://Utility.gd")


export var weight: float = 3.0 #CREDIT_TO_WT
export var active: bool = true

var ID:String = ("C" + str(get_instance_id()))
var semester_ID:String = ""

onready var credit_children = $Layout/CreditBoxes.get_children()
onready var name_label = $Layout/CourseName
onready var grade_button = $Layout/Grade
onready var active_button = $Layout/Buttons/ActiveButton


signal delete
signal duplicate


#----------------------------------FUNCS----------------------------------------
func _ready():
	for key in UTIL.get_gpa_scale_keys():
		grade_button.add_item(key)


func set_ID(new_value:String):
	ID = new_value
func get_ID()->String:
	return ID


func set_name(new_text:String):
	if name_label.text != new_text:
		name_label.text = new_text
func get_name()-> String:
	return name_label.text


func set_grade_by_index(index):
	if grade_button.selected != index:
		grade_button.select(index)
func get_grade_as_index()-> int:
	return grade_button.selected
func get_grade_as_string()-> String:
	var grades = UTIL.GRADE_TO_POINTS.keys()
	return grades[grade_button.selected]


func set_credit(new_credit:int): #CREDIT_TYPES
	single_toggle_credit(new_credit)
	weight = UTIL.CREDIT_TYPE_TO_WEIGHT[new_credit]
func get_credit_as_type()-> int:
	for child in credit_children:
		if child.is_pressed():
			return credit_children.find(child)
	return -1
func get_weight()-> float:
	return weight


func set_active(new_value:bool):
	active = new_value
	active_button.pressed = new_value
func is_active()-> bool:
	return active


func duplicate_course():
	emit_signal("duplicate", 1, get_name(), get_grade_as_index(), get_credit_as_type(), is_active())


func single_toggle_credit(credit_child_index):
	for child in credit_children:
		if child != credit_children[credit_child_index]:
			child.pressed = false
		else:
			child.pressed = true

func save_data(config_file:ConfigFile):
	config_file.set_value(ID, UTIL.COURSE_SAVE_KEYS[0], "COURSE")
	config_file.set_value(ID, UTIL.COURSE_SAVE_KEYS[1], semester_ID)
	config_file.set_value(ID, UTIL.COURSE_SAVE_KEYS[2], get_name())
	config_file.set_value(ID, UTIL.COURSE_SAVE_KEYS[3], get_grade_as_index())
	config_file.set_value(ID, UTIL.COURSE_SAVE_KEYS[4], get_credit_as_type())
	config_file.set_value(ID, UTIL.COURSE_SAVE_KEYS[5], is_active())


func load_data(config:ConfigFile, c_ID:String):
	set_ID(c_ID)
	set_name(config.get_value(c_ID, "NAME"))
	semester_ID = config.get_value(c_ID, "SEMESTER_ID")
	set_grade_by_index(config.get_value(c_ID, "GRADE_INDEX"))
	set_credit(config.get_value(c_ID, "CREDIT_TYPE"))
	set_active(config.get_value(c_ID, "ACTIVE"))


#-----------------------------SIGNALS-------------------------------------------
func _on_3Credit_pressed():
	set_credit(UTIL.CREDIT_TYPES.THREE)
	SignalBus.emit_signal("update")
func _on_6Credit_pressed():
	set_credit(UTIL.CREDIT_TYPES.SIX)
	SignalBus.emit_signal("update")
func _on_HalfCredit_pressed():
	set_credit(UTIL.CREDIT_TYPES.HALF)
	SignalBus.emit_signal("update")


func _on_Grade_item_selected(index):
	set_grade_by_index(index)
	SignalBus.emit_signal("update")


func _on_DeleteButton_button_down():
	SignalBus.emit_signal("update")
	emit_signal("delete", self)
	queue_free()


func _on_CourseName_text_changed(new_text):
	set_name(new_text)
	SignalBus.emit_signal("update")


func _on_ActiveButton_button_down():
	active = !active
	SignalBus.emit_signal("update")


func _on_DuplicateButton_button_down():
	duplicate_course()
	SignalBus.emit_signal("update")
