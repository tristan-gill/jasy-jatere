class_name ActionQueue
extends Resource

@export var queue: Array[Action]
@export var index_of_next: int = 0

func is_empty() -> bool:
	return queue.is_empty()

func append(action: Action) -> void:
	queue.append(action)

func pop_front() -> Action:
	return queue.pop_front()

func get_next() -> Action:
	var action = queue[index_of_next]
	index_of_next = wrapi(index_of_next + 1, 0, queue.size())
	return action
