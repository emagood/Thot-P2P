extends Node
class_name UDPManager

# UDPManager - 超简洁UDP网络通信类
# UDPManager - Super Simple UDP Network Communication Class
#
# 提供UDP协议基本功能：监听、发送、广播
# Provides basic UDP protocol features: listening, sending, broadcasting
#
# 作者： EBGame Studio - 摸摸鱼玩游戏 
# Author: EBGame Studio - 摸摸鱼玩游戏 
# https://space.bilibili.com/13651987

# 信号定义 | Signal Definition
signal received(msg, ip, port)  # 当接收到UDP数据包时触发此信号，传递消息内容、来源IP和端口
							   # Emitted when UDP packet is received, passing message content, source IP and port

# UDP成员变量 | UDP Member Variables
var udp = PacketPeerUDP.new()  # UDP通信对象
							   # UDP communication object

# 初始化示例，不建议自动开启，请在需要时手动开启，因为手动开启可以指定端口
# Initialization example, auto-start not recommended, please start manually when needed as it allows port specification
#func _ready():
	#start()                   # 自动启动UDP服务
							  # Auto-start UDP service

# 每帧处理 | Process Every Frame
func _process(_delta):
	# 检查是否有新的数据包到达
	# Check if new packets have arrived
	if udp.get_available_packet_count() > 0:
		# 读取数据包并转换为字符串
		# Read packet and convert to string
		var data = udp.get_packet().get_string_from_utf8()
		# 发射信号通知有新数据，附带发送者信息
		# Emit signal for new data with sender information
		received.emit(data, udp.get_packet_ip(), udp.get_packet_port())

# 启动UDP服务 | Start UDP Service
func start(listen_port):
	udp.close() if udp.is_bound() else null  # 如果已绑定则先关闭
											 # Close if already bound
	udp.bind(listen_port)                    # 绑定到指定端口
											 # Bind to specified port
	udp.set_broadcast_enabled(true)          # 启用广播功能
											 # Enable broadcast functionality
	set_process(true)  

# 发送UDP消息到指定IP和端口 | Send UDP Message to Specified IP and Port
func send(text, ip, port):
	udp.set_dest_address(ip, port)  # 设置目标地址和端口
									# Set destination address and port
	return udp.put_packet(text.to_utf8_buffer())  # 发送UTF-8编码的文本
												  # Send UTF-8 encoded text

# 广播UDP消息到指定端口 | Broadcast UDP Message to Specified Port
func broadcast(text, bcast_port):
	# 使用广播地址255.255.255.255向所有设备发送消息
	# Use broadcast address 255.255.255.255 to send message to all devices
	return send(text, "255.255.255.255", bcast_port) 

# 关闭UDP服务 | Close UDP Service
func close():
	udp.close()
	set_process(false)
