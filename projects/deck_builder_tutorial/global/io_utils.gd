class_name IO_Utils
extends RefCounted

static var _last_print_time = 0
static var interval = 1.0
static var log_level = 0

static func set_print_interval(new_interval: float):
	interval = new_interval


static func interval_print(...args):
	var current_time = Time.get_unix_time_from_system()
	if current_time - _last_print_time < interval:
		return 
	print.callv(args)
	_last_print_time = current_time


static func set_log_level(level: int):
	log_level = level

static func print_log(level: int, ...args):
	if level >= log_level:
		var prefix := "[#%d %s] " % \
				[level, Time.get_time_string_from_system()]
		args.push_front(prefix)
		print.callv(args)
