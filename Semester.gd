class_name Semester
extends MarginContainer

const COURSE = preload("res://Course.tscn")
const UTIL = preload("res://Utility.gd")


var ID = ("S" + str(get_instance_id()))


onready var title = $Layout/Header/TitleLayout/LineEdit
onready var course_container = $Layout/Courses
onready var active_button = $Layout/Header/TitleLayout/ActiveButton


#------------------------------------FUNCS-------------------------------------
func set_ID(new_value:String):
	ID = new_value
func get_ID()->String:
	return ID

func set_name(new_value):
	if title.text != new_value:
		title.text = new_value
func get_name()-> String:
	return title.text


func set_active(new_value:bool):
	active_button.pressed = new_value
func get_active()->bool:
	return active_button.pressed


func init_course()-> Course:
	var course = COURSE.instance()
	course_container.add_child(course)
	return course


func add_blank_course(amt: int):
	for i in amt:
		var course = init_course()
		course.semester_ID = self.ID


func toggle_courses_active(button_pressed:bool):
	for course in course_container.get_children():
		course.set_active(button_pressed)


func delete_course(course):
	SignalBus.emit_signal("update")
	course.queue_free()


func clear_courses():
	for course in course_container.get_children():
		course.queue_free()
	SignalBus.emit_signal("update")


func delete():
	SignalBus.emit_signal("update")
	queue_free()


func save_data(data_file:ConfigFile):
	data_file.set_value(ID, UTIL.SEMESTER_SAVE_KEYS[0], "SEMESTER")
	data_file.set_value(ID, UTIL.SEMESTER_SAVE_KEYS[1], get_name())
	data_file.set_value(ID, UTIL.SEMESTER_SAVE_KEYS[2], get_active())


func load_data(config:ConfigFile, c_ID:String):
	set_ID(c_ID)
	set_name(config.get_value(c_ID, "NAME"))
	set_active(config.get_value(c_ID, "ACTIVE"))


#------------------------------------SIGNALS------------------------------------
func _on_AddButton_button_down():
	add_blank_course(1)
	SignalBus.emit_signal("update")


func _on_DeleteButton_button_down():
	delete()


func _on_LineEdit_text_changed(new_text):
	set_name(new_text)
	SignalBus.emit_signal("update")


func _on_ActiveButton_toggled(button_pressed):
	toggle_courses_active(button_pressed)
	SignalBus.emit_signal("update")
