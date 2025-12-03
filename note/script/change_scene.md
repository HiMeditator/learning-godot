在 Godot 中切换场景有多种方式，下面介绍最常用的几种方法：

## 1. **使用 SceneTree 切换场景（最常用）**

### 基本切换
```gdscript
# 加载新场景
var new_scene = preload("res://path_to_scene.tscn")

# 获取当前场景树并切换
get_tree().change_scene_to_packed(new_scene)
```

### 简化写法
```gdscript
# 直接通过路径切换
get_tree().change_scene_to_file("res://path_to_scene.tscn")
```

## 2. **使用 SceneManager 单例（推荐）**

创建全局场景管理器：

```gdscript
# SceneManager.gd (设为 AutoLoad)
extends Node

func change_scene(scene_path: String, transition_time: float = 0.5):
    # 可以在这里添加过渡效果
    var loader = ResourceLoader.load_threaded_request(scene_path)
    # 等待加载完成
    # ...
    get_tree().change_scene_to_file(scene_path)
```

## 3. **带过渡效果的场景切换**

```gdscript
# 使用 CanvasLayer 实现淡入淡出效果
func change_scene_with_fade(scene_path: String, fade_time: float = 0.5):
    # 创建淡出效果
    var fade_out = create_tween()
    $CanvasLayer/ColorRect.modulate.a = 0
    fade_out.tween_property($CanvasLayer/ColorRect, "modulate:a", 1, fade_time)
    
    await fade_out.finished
    
    # 切换场景
    get_tree().change_scene_to_file(scene_path)
    
    # 淡入效果
    var fade_in = create_tween()
    fade_in.tween_property($CanvasLayer/ColorRect, "modulate:a", 0, fade_time)
```

## 4. **异步加载场景（避免卡顿）**

```gdscript
func load_scene_async(scene_path: String):
    # 开始异步加载
    var loader = ResourceLoader.load_threaded_request(scene_path)
    
    # 检查加载进度
    while true:
        var progress = []
        var status = ResourceLoader.load_threaded_get_status(scene_path, progress)
        
        if status == ResourceLoader.THREAD_LOAD_LOADED:
            var scene = ResourceLoader.load_threaded_get(scene_path)
            get_tree().change_scene_to_packed(scene)
            break
        elif status == ResourceLoader.THREAD_LOAD_FAILED:
            print("加载失败")
            break
        
        # 更新加载进度条
        update_loading_bar(progress[0])
        await get_tree().create_timer(0.1).timeout
```

## 5. **保留数据传递**

### 方法1：使用全局变量
```gdscript
# 在 AutoLoad 脚本中定义
var player_score = 0
var player_name = ""
```

### 方法2：使用场景参数
```gdscript
# 切换时传递参数
func change_scene_with_data(scene_path: String, data: Dictionary):
    Globals.scene_data = data  # 存储到全局
    get_tree().change_scene_to_file(scene_path)

# 在新场景中获取
func _ready():
    if Globals.has("scene_data"):
        var data = Globals.scene_data
        # 使用数据...
```

## 6. **完整示例：场景切换管理器**

```gdscript
# SceneTransition.gd
extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func transition_to(scene_path: String):
    # 播放淡出动画
    animation_player.play("fade_out")
    await animation_player.animation_finished
    
    # 切换场景
    get_tree().change_scene_to_file(scene_path)
    
    # 播放淡入动画
    animation_player.play("fade_in")
```

## 7. **Godot 4.x 新特性**

在 Godot 4 中，推荐使用：
```gdscript
# Godot 4 推荐方式
await get_tree().process_frame  # 等待一帧
get_tree().change_scene_to_file("res://new_scene.tscn")
```

## 最佳实践建议：

1. **使用场景管理器**：创建统一的场景切换接口
2. **添加过渡效果**：避免生硬的场景切换
3. **异步加载**：大型场景使用异步加载避免卡顿
4. **错误处理**：检查场景文件是否存在
5. **资源管理**：切换场景时释放不需要的资源

```gdscript
# 带错误检查的切换
func safe_change_scene(path: String):
    if FileAccess.file_exists(path):
        get_tree().change_scene_to_file(path)
    else:
        push_error("场景文件不存在: " + path)
```

选择哪种方式取决于你的项目需求。对于简单游戏，直接使用 `change_scene_to_file` 即可；对于复杂项目，建议实现完整的场景管理系统。