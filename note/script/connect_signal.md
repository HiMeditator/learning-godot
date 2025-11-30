在 GDScript 中，信号连接是实现节点间通信的重要机制。以下是多种使用脚本完成信号连接的方法。

## 基本信号连接语法

### 1. 使用 `connect()` 方法

```gdscript
# 在某个节点中连接信号
func _ready():
    # 连接按钮的 pressed 信号
    $Button.connect("pressed", self, "_on_button_pressed")
    
    # 连接定时器的 timeout 信号
    $Timer.connect("timeout", self, "_on_timer_timeout")

# 信号处理函数
func _on_button_pressed():
    print("按钮被按下!")

func _on_timer_timeout():
    print("定时器超时!")
```

### 2. 使用 `%` 语法（Godot 4.0+）

```gdscript
func _ready():
    # 使用 % 获取唯一命名的节点
    %PlayButton.connect("pressed", _on_play_button_pressed)

func _on_play_button_pressed():
    print("播放按钮被按下")
```

## 不同类型的信号连接

### 1. 连接内置信号

```gdscript
extends Node2D

func _ready():
    # 连接 Area2D 的信号
    $Area2D.connect("body_entered", self, "_on_body_entered")
    $Area2D.connect("body_exited", self, "_on_body_exited")
    
    # 连接 AnimationPlayer 的信号
    $AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")

func _on_body_entered(body):
    print("物体进入区域: ", body.name)

func _on_body_exited(body):
    print("物体离开区域: ", body.name)

func _on_animation_finished(anim_name):
    print("动画播放完成: ", anim_name)
```

### 2. 连接自定义信号

首先定义自定义信号：

```gdscript
# Player.gd
extends CharacterBody2D

# 定义自定义信号
signal health_changed(old_health, new_health)
signal player_died
signal item_collected(item_type, amount)

var health: int = 100

func take_damage(amount: int):
    var old_health = health
    health -= amount
    emit_signal("health_changed", old_health, health)
    
    if health <= 0:
        emit_signal("player_died")

func collect_item(item_type: String, amount: int = 1):
    emit_signal("item_collected", item_type, amount)
```

然后在其他脚本中连接：

```gdscript
# UI.gd
extends CanvasLayer

func _ready():
    # 获取玩家节点并连接信号
    var player = get_node("../Player")
    player.connect("health_changed", self, "_on_player_health_changed")
    player.connect("player_died", self, "_on_player_died")
    player.connect("item_collected", self, "_on_item_collected")

func _on_player_health_changed(old_health, new_health):
    $HealthBar.value = new_health
    print($"生命值从 {old_health} 变为 {new_health}")

func _on_player_died():
    show_game_over_screen()

func _on_item_collected(item_type, amount):
    print($"收集了 {amount} 个 {item_type}")
```

## 现代连接方法（Godot 4.0+）

### 1. 使用 Callable（推荐）

```gdscript
func _ready():
    # 使用 Callable 连接信号
    $Button.pressed.connect(_on_button_pressed)
    $Timer.timeout.connect(_on_timer_timeout)
    
    # 带参数的信号
    $Area2D.body_entered.connect(_on_body_entered)

func _on_button_pressed():
    print("按钮按下")

func _on_timer_timeout():
    print("定时器")

func _on_body_entered(body: Node):
    print("物体进入: ", body.name)
```

### 2. 使用 lambda 表达式

```gdscript
func _ready():
    # 使用 lambda 表达式连接简单信号
    $Button.pressed.connect(func(): print("按钮按下!"))
    
    # 带参数的 lambda
    $Area2D.body_entered.connect(func(body): print("进入: ", body.name))
    
    # 多行 lambda
    $Timer.timeout.connect(func():
        print("定时器超时")
        do_something()
    )
```

## 高级信号连接技巧

### 1. 一次性连接

```gdscript
func _ready():
    # 一次性连接（只触发一次）
    $AnimationPlayer.animation_finished.connect(
        _on_animation_finished_once, 
        CONNECT_ONE_SHOT
    )

func _on_animation_finished_once(anim_name):
    print("这个信号只会触发一次: ", anim_name)
```

### 2. 连接多个信号到同一个处理函数

```gdscript
func _ready():
    # 多个按钮连接到同一个处理函数
    $Button1.pressed.connect(_on_any_button_pressed.bind("Button1"))
    $Button2.pressed.connect(_on_any_button_pressed.bind("Button2"))
    $Button3.pressed.connect(_on_any_button_pressed.bind("Button3"))

func _on_any_button_pressed(button_name):
    print("按钮被按下: ", button_name)
```

### 3. 动态连接和断开

```gdscript
var is_connected: bool = false

func _ready():
    connect_signals()

func connect_signals():
    if not is_connected:
        $Button.pressed.connect(_on_button_pressed)
        is_connected = true

func disconnect_signals():
    if is_connected:
        $Button.pressed.disconnect(_on_button_pressed)
        is_connected = false

func toggle_connection():
    if is_connected:
        disconnect_signals()
    else:
        connect_signals()
```

## 实际应用示例

### 游戏事件系统

```gdscript
# GameEvents.gd (自动加载单例)
extends Node

# 全局事件信号
signal player_spawned(player)
signal enemy_killed(enemy_type, points)
signal level_completed(level_number)
signal game_paused
signal game_resumed

# 静态函数用于触发事件
static func emit_player_spawned(player):
    instance.emit_signal("player_spawned", player)

static func emit_enemy_killed(enemy_type, points):
    instance.emit_signal("enemy_killed", enemy_type, points)

static var instance: GameEvents

func _ready():
    instance = self
```

在其他脚本中使用：

```gdscript
# Player.gd
extends CharacterBody2D

func _ready():
    GameEvents.emit_player_spawned(self)

func die():
    GameEvents.emit_signal("enemy_killed", "player", 0)
    queue_free()

# UI.gd
extends CanvasLayer

func _ready():
    GameEvents.player_spawned.connect(_on_player_spawned)
    GameEvents.enemy_killed.connect(_on_enemy_killed)
    GameEvents.game_paused.connect(_on_game_paused)

func _on_player_spawned(player):
    print("玩家生成: ", player.name)

func _on_enemy_killed(enemy_type, points):
    update_score(points)

func _on_game_paused():
    show_pause_menu()
```

### UI 系统信号连接

```gdscript
# SettingsMenu.gd
extends Control

func _ready():
    # 连接所有设置控件的信号
    %VolumeSlider.value_changed.connect(_on_volume_changed)
    %FullscreenToggle.toggled.connect(_on_fullscreen_toggled)
    %BackButton.pressed.connect(_on_back_pressed)
    
    # 连接分辨率下拉菜单
    %ResolutionOptionButton.item_selected.connect(_on_resolution_selected)

func _on_volume_changed(value: float):
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_fullscreen_toggled(enable: bool):
    if enable:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_resolution_selected(index: int):
    var resolution = %ResolutionOptionButton.get_item_text(index)
    set_resolution(resolution)

func _on_back_pressed():
    hide()
```

## 最佳实践

1. **在 `_ready()` 中连接信号**，确保节点已存在
2. **使用有意义的处理函数名**，如 `_on_node_name_signal_name`
3. **及时断开不需要的信号**，避免内存泄漏
4. **使用 Callable 语法**（Godot 4.0+），更现代和安全
5. **考虑使用事件总线** 对于全局事件

## 常见错误和解决方法

```gdscript
# 错误：在节点准备就绪前连接信号
func _init():
    # 这里 $Node 可能还不存在！
    $Button.connect("pressed", self, "_on_pressed")  # 可能出错

# 正确：在 _ready() 中连接
func _ready():
    $Button.connect("pressed", self, "_on_pressed")

# 错误：重复连接信号
func some_function():
    $Button.connect("pressed", self, "_on_pressed")  # 可能重复连接

# 正确：检查是否已连接或使用一次性连接
func safe_connect():
    if not $Button.pressed.is_connected(_on_pressed):
        $Button.pressed.connect(_on_pressed)
```

掌握这些信号连接技巧可以让你创建更加模块化和响应式的 Godot 应用程序。