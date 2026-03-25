extends Timer
var timer = Timer.new()
func _ready() -> void:
	add_child(timer)
	timer.wait_time = 5.0  # 2秒
	timer.one_shot = true  # 是否只执行一次
	timer.timeout.connect(_on_timeout)
	timer.start()

func _on_timeout():
	timer.queue_free()  # 如果不需要了记得释放
