extends RefCounted

class_name HaruHandshack

const MAXPACKETS := 1024

var resendTime := 0.05

var sceneTree : SceneTree

var streamPeer : PacketPeerUDP

var sendPacketCallback : Callable
var readPacketCallback : Callable

var sentMessages :Dictionary
var receivedMessages : Dictionary

var sequenceMessages : int
var expectedSequence : int

var hasTimer0 := false
var hasTimer1 := false
var hasTimer2 := false

var discartedPackets : Array[int]
var expectedReceivedSequence : int = 0

class UserPacketCommit extends RefCounted:
	const MAXTRIALS := 340
	
	var Message : HaruMessageWriter
	var InTimeout : bool
	var InTrials : int
	var IsConfirmed : bool
	
	var _Wait : bool
	
	func _______Poll() -> void:
		pass

class ACKCommit extends RefCounted:
	func _init() -> void:
		return

func _init() -> void:
	return

func SendData(packet : PackedByteArray) -> void:
	if streamPeer:
		#if randi_range(0, 1) == 1:
		streamPeer.put_packet(packet)

func SendACK(message : HaruMessageWriter) -> void:
	var ACK = HaruMessageWriter.new()
	ACK.MessageID = message.MessageID
	ACK.MessageData = PackedByteArray([])
	
	SendData(ACK.Serialize())
	
	#print("Sending ACK....: %s" % message.MessageID)

func SendPacket(data : PackedByteArray) -> void:
	if sequenceMessages > 1024:
		sequenceMessages = 0
	
	var message = HaruMessageWriter.new()
	message.MessageID = sequenceMessages
	message.MessageData = data
	
	var UPacket := UserPacketCommit.new()
	UPacket.InTimeout = false
	UPacket.InTrials = 0
	UPacket.Message = message
	UPacket._Wait = false
	
	sentMessages[sequenceMessages] = UPacket
	sequenceMessages += 1

func _PollPackets() -> void:
	if not streamPeer:
		return
	
	while streamPeer.get_available_packet_count() > 0:
		var packet := streamPeer.get_packet()
		
		var message = HaruMessageWriter.new()
		message.Deserialize(packet)
		
		if message.MessageID > -1:
			if message.MessageData.size() < 1:
				if message.MessageID == expectedSequence:
					#print('ACK CONFIRMED FROM: %s' % sentMessages[expectedSequence].MessageData.get_string_from_utf8())
					(sentMessages[expectedSequence] as UserPacketCommit).IsConfirmed = true
					expectedSequence += 1
				else:
					#var resendSequence := 0
					#while resendSequence < sentMessages.size():
					#	SendData(sentMessages[sentMessages.keys()[resendSequence]].Serialize())
					#	resendSequence += 1
					pass
			else:
				if not message.MessageID in receivedMessages:
					if not message.MessageID in discartedPackets:
						readPacketCallback.call(message.MessageData)
					receivedMessages[message.MessageID] = message
				SendACK(message)
	
		else:
			if readPacketCallback:
				readPacketCallback.call(packet)

func _PollReceivedPackets() -> void:
	if not streamPeer:
		return
	
	if hasTimer1:
		return
	
	hasTimer1 = true
	
	var sequence := 0
	var size := receivedMessages.size()
	
	if size < 1:
		return
	
	print(receivedMessages)
	
	while sequence < size:
		var realSequence = receivedMessages.keys()[sequence]
		
		if realSequence == expectedReceivedSequence:
			var ACK = HaruMessageWriter.new()
			ACK.MessageID = realSequence
			ACK.MessageData = PackedByteArray([])
			
			SendData(ACK.Serialize())
			print('ACK SENT TO: %s' % receivedMessages[realSequence].MessageData.get_string_from_utf8())
			#receivedMessages.erase(realSequence)
			discartedPackets.append(realSequence)
			
			expectedReceivedSequence += 1
		
		sequence += 1
	
	"""
	while sequence < size:
		var realSequence = sortedSequence[sequence]
		
		var ACK = HaruMessageWriter.new()
		ACK.MessageID = realSequence
		ACK.MessageData = PackedByteArray([])
		
		SendData(ACK.Serialize())
		#print('ACK SENT TO: %s' % receivedMessages[realSequence].MessageData.get_string_from_utf8())
		#receivedMessages.erase(realSequence)
		discartedPackets.append(realSequence)
		
		sequence += 1
	"""
	
	receivedMessages.clear()
	
	await sceneTree.create_timer(0.01).timeout
	hasTimer1 = false

func _PollSentPackets() -> void:
	if not streamPeer:
		return
	
	#if hasTimer2:
	#	return
	
	#var sequence := sentMessages.size()
	#while sequence> 0:
	#	if sequence in sentMessages:
	#		SendData(sentMessages[sequence].Serialize())
		
	#	sequence -=1
	
	#WARNING: Sent Messages is are correct order!
	
	for upacket in sentMessages.values():
		if upacket is UserPacketCommit:
			if upacket.IsConfirmed:
				sentMessages.erase(upacket.Message.MessageID)
				#print("Confirmed....: %s" % upacket.Message.MessageID)
				continue
			
			if upacket.InTimeout:
				continue
			else:
				if upacket.InTrials < UserPacketCommit.MAXTRIALS:
					if not upacket._Wait:
						upacket._Wait = true
						
						SendData(upacket.Message.Serialize())
						
						await sceneTree.create_timer(resendTime).timeout
						upacket.InTrials += 1
						upacket._Wait = false
				else:
					upacket.InTimeout = true
				
				break
	
	#await sceneTree.create_timer(0.01).timeout
	#hasTimer2 = false

func Handle() -> void:
	_PollPackets()
	#_PollReceivedPackets()
	_PollSentPackets()
	
	if discartedPackets.size() > MAXPACKETS:
		receivedMessages.clear()
		discartedPackets.clear()
	
	#print(sentMessages)
	"""
	if hasTimer0:
		hasTimer0 = false
		var readSequence := 0
		while readSequence < receivedMessages.size():
			if readSequence in receivedMessages:
				var ACK = HaruMessageWriter.new()
				ACK.MessageID = readSequence
				ACK.MessageData = PackedByteArray([])
				
				SendData(ACK.Serialize())
				receivedMessages.erase(readSequence)
				print('ack sended')
			readSequence += 1
		sceneTree.create_timer(1.0).timeout.connect(func():
			hasTimer0 = true)
	
	if hasTimer1:
		hasTimer1 = false
		var sentSequence := 0
		while sentSequence < sentMessages.size():
			if sentSequence in sentMessages:
				SendData(sentMessages[sentSequence].Serialize())
			sentSequence += 1
		sceneTree.create_timer(1.0).timeout.connect(func():
			hasTimer1 = true)
	"""
