class_name IO_Utils  # 全局类名，其他脚本可直接调用
extends RefCounted  # 基类（无节点依赖，推荐）

static var _last_print_time = 0
static var interval = 1.0


static func set_interval(new_interval: float):
	interval = new_interval


static func interval_print(...args):
	pass
	var current_time = Time.get_unix_time_from_system()
	if current_time - _last_print_time < interval:
		return 
	print.callv(args)
	_last_print_time = current_time
