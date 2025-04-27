extends Control

# UDP网络服务演示
# UDP Network Service Demo
#
# 展示如何使用UDPManager类进行UDP通信
# Demonstrates how to use UDPManager class for UDP communication

# 成员变量 | Member Variables
var udp = UDPManager.new()  # 创建UDP通信实例
						   # Create UDP communication instance

# 节点引用 | Node References
@onready var input = $VBox/Input  # 消息输入框
								 # Message input field
@onready var ip_input = $VBox/HBox/IP  # 目标IP输入框
									   # Target IP input field
@onready var port_input = $VBox/HBox/Port  # 目标端口输入框
										  # Target port input field
@onready var broadcast_port_input = $VBox/HBox2/BroadcastPort  # 广播端口输入框
															  # Broadcast port input field
@onready var output = $VBox/Output  # 消息输出框
								   # Message output field

# 初始化 | Initialization
func _ready():
	# 设置UDP端口，启动UDP服务
	# Set UDP port and start UDP service
	var port = 9000
	# 启动UDP服务
	# Start UDP service
	udp.start(port)
	# 将UDP实例添加到场景树中
	# Add UDP instance to scene tree
	add_child(udp)
	
	# 连接UDP信号
	# Connect UDP signals
	udp.received.connect(_on_received)
	
	# 连接UI按钮信号
	# Connect UI button signals
	$VBox/HBox/Send.pressed.connect(_on_send_pressed)
	$VBox/HBox2/Broadcast.pressed.connect(_on_broadcast_pressed)
	
	# 显示初始状态信息
	# Display initial status information
	output.text = "本地IP | Local IP: " + _get_local_ip() + "\n监听端口 | Listening Port: " + str(port)

# 当接收到UDP消息时调用 | Called when UDP message is received
func _on_received(msg, ip, port):
	# 在输出框中添加接收到的消息
	# Add received message to output field
	output.text += "\n收到来自 | Received from " + ip + ":" + str(port) + ": " + msg
	output.scroll_vertical = output.get_line_count()  # 自动滚动到底部
													 # Auto-scroll to bottom

# 发送按钮点击处理 | Send Button Click Handler
func _on_send_pressed():
	# 获取目标IP和端口
	# Get target IP and port
	var target_ip = ip_input.text.strip_edges()
	var target_port = int(port_input.text)
	
	# 验证输入
	# Validate input
	if target_ip.is_empty() or input.text.is_empty():
		return  # 如果IP或消息为空，不执行发送
				# If IP or message is empty, don't send
		
	# 验证端口范围
	# Validate port range
	if target_port <= 0 or target_port > 65535:
		output.text += "\n错误 | Error: 端口必须在 | Port must be in 1-65535"
		return
	
	# 发送消息
	# Send message	
	udp.send(input.text, target_ip, target_port)
	
	# 更新UI
	# Update UI
	output.text += "\n已发送到 | Sent to " + target_ip + ":" + str(target_port) + ": " + input.text
	output.scroll_vertical = output.get_line_count()  # 自动滚动到底部
													 # Auto-scroll to bottom

# 广播按钮点击处理 | Broadcast Button Click Handler
func _on_broadcast_pressed():
	# 获取广播端口
	# Get broadcast port
	var bcast_port = int(broadcast_port_input.text)
	
	# 验证输入
	# Validate input
	if input.text.is_empty():
		return  # 如果消息为空，不执行广播
				# If message is empty, don't broadcast
		
	# 验证端口范围
	# Validate port range
	if bcast_port <= 0 or bcast_port > 65535:
		output.text += "\n错误 | Error: 端口必须在 | Port must be in 1-65535"
		return
	
	# 执行广播
	# Execute broadcast	
	udp.broadcast(input.text, bcast_port)
	
	# 更新UI
	# Update UI
	output.text += "\n已广播 | Broadcasted to port " + str(bcast_port) + ": " + input.text
	output.scroll_vertical = output.get_line_count()  # 自动滚动到底部
													 # Auto-scroll to bottom

# 获取本地非环回IP地址 | Get Local Non-loopback IP Address
func _get_local_ip():
	# 遍历所有本地IP地址
	# Iterate through all local IP addresses
	for ip in IP.get_local_addresses():
		# 过滤掉环回地址和IPv6地址
		# Filter out loopback and IPv6 addresses
		if ip != "127.0.0.1" and ip != "::1" and not ":" in ip:
			return ip
	# 如果没有找到合适的地址，返回本地回环地址
	# If no suitable address found, return local loopback address
	return "127.0.0.1" 


func _on_salir_pressed() -> void:
	queue_free()
	pass # Replace with function body.
