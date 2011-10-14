/**
 * Because of the limitations of Flash platform this library supports a subset of the features of ZMQ.
 */

package com.rimusdesign.flexzmq{


//	import air.net.SocketMonitor;

	import com.rimusdesign.flexzmq.core.Option;
	import com.rimusdesign.flexzmq.core.policy.PolicyContext;
	import com.rimusdesign.flexzmq.core.policy.RequestPolicy;
	import com.rimusdesign.flexzmq.core.policy.SubscribePolicy;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	
	/**
	 * Dispatched when a message is received.
	 * 
	 * @eventType
	 * com.rimusdesign.flexzmq.ZMQEvent.MESSAGE_RECEIVED
	 */
	[Event(name="messageReceived", type="com.rimusdesign.flexzmq.ZMQEvent")]
	
	/**
	 * Dispatched when connection is established.
	 * 
	 * @eventType
	 * flash.events.Event.CONNECT
	 */
	[Event(name="connect", type="flash.events.Event")]
	
	/**
	 * Dispatched when socket receives data. Please note that actual data payload is handled and
	 * dispatched as a parameter of 'com.rimusdesign.flexzmq.ZMQEvent.MESSAGE_RECEIVED' event
	 * before this event is dispathed.
	 * 
	 * @see com.rimusdesign.flexzmq.ZMQEvent
	 * 
	 * @eventType
	 * flash.events.ProgressEvent.SOCKET_DATA
	 */
	[Event(name="socketData", type="flash.events.ProgressEvent")]
	
	/**
	 * Dispatched when connection is closed.
	 * 
	 * @eventType
	 * flash.events.Event.CLOSE
	 */
	[Event(name="close", type="flash.events.Event")]
	
	/**
	 * Dispatched when a security error is encountered.
	 * 
	 * @eventType
	 * flash.events.SecurityErrorEvent.SECURITY_ERROR
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * Dispatched when I/O error is encountered.
	 * 
	 * @eventType
	 * flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	
	/**
	 * This is a main class of FlexZMQ library.
	 * 
	 * @author rimaskrivickas
	 * 
	 * @example The following code is a 'Request-Reply' connection example:
	 * <listing version="3.0">
	 * package {
	 * 
	 * 
	 * 	import com.rimusdesign.flexzmq.ZMQ;
	 * 	import com.rimusdesign.flexzmq.ZMQEvent;
	 * 	import com.rimusdesign.flexzmq.ZMQSocketType;
	 * 	import flash.events.Event;
	 * 
	 * 
	 * 	public class ExampleREQ {
	 * 
	 * 
	 * 		public var requestConnection	: ZMQ;
	 * 
	 * 
	 * 		public function ExampleREQ ( address : String, port : uint ) {
	 * 			requestConnection = new ZMQ ( ZMQSocketType.REQ );
	 * 			requestConnection.addEventListener ( Event.CONNECT, onConnect );
	 * 			requestConnection.addEventListener ( ZMQEvent.MESSAGE_RECEIVED, onMessageReceived );
	 * 			requestConnection.connect ( address, port );
	 * 		}
	 * 
	 * 
	 * 		private function onMessageReceived ( event : ZMQEvent ) : void {
	 * 			trace ( event.data );
	 * 		}
	 * 
	 * 
	 * 		private function onConnect ( event : Event ) : void {
	 * 			requestConnection.send ( ["Hello"] );
	 * 		}
	 * 	}
	 * }
	 * </listing> 
	 * 
	 * @example The following code is a 'Publish-Subscribe' connection example:
	 * <listing version="3.0">
	 * package {
	 * 
	 * 
	 * 	import com.rimusdesign.flexzmq.ZMQ;
	 * 	import com.rimusdesign.flexzmq.ZMQEvent;
	 * 	import com.rimusdesign.flexzmq.ZMQSocketType;
	 * 	import flash.events.Event;
	 * 
	 * 
	 * 	public class ExampleSUB {
	 * 
	 * 
	 * 		public var subscribeConnection	: ZMQ;
	 * 
	 * 
	 * 		public function ExampleREQ ( address : String, port : uint ) {
	 * 			subscribeConnection = new ZMQ ( ZMQSocketType.SUB );
	 * 			broadcastConnection.setSocketOption ( SocketOption.SUBSCRIBE, "Hello" );
	 * 			subscribeConnection.addEventListener ( Event.CONNECT, onConnect );
	 * 			subscribeConnection.addEventListener ( ZMQEvent.MESSAGE_RECEIVED, onMessageReceived );
	 * 			subscribeConnection.connect ( address, port );
	 * 		}
	 * 
	 * 
	 * 		private function onMessageReceived ( event : ZMQEvent ) : void {
	 * 			trace ( event.data );
	 * 		}
	 * 
	 * 
	 * 		private function onConnect ( event : Event ) : void {
	 * 			trace ( "Connected!" );
	 * 		}
	 * 	}
	 * }
	 * </listing> 
	 */
	public class ZMQ extends EventDispatcher {
		
		
		private var socket				: Socket;
//		private var socketMonitor		: SocketMonitor;
		private var policyContext		: PolicyContext;
		private var handshakeComplete	: Boolean;
		private var options				: Vector.<Option>;
		private var connectEvent		: Event;
		

		public function ZMQ ( socketType : String ) {
			
			socket	= new Socket ( );
			options	= new Vector.<Option> ( );
			
			addPolicies ( );
			
			policyContext.activatePolicy ( socketType );
		}
		
		
		private function getOption ( optionName : String ) : Vector.<Option> {
			
			var result : Vector.<Option> = options.filter (
				function ( item : Option, index : int, list : Vector.<Option> ) : Boolean {
					return item.optionName == optionName ? true : false;
				}
			);
			
			return result.length != 0 ? result : null;
		}
		
		
//		private function monitorSocket ( ) : void {
//			
//			socketMonitor.addEventListener ( StatusEvent.STATUS, onSocketStatus );
//			socketMonitor.pollInterval = 5000;
//			socketMonitor.start ( );
//		}


		private function addPolicies ( ) : void {
			
			policyContext = new PolicyContext ( socket, getOption )
				.addPolicy ( ZMQSocketType.REQ, RequestPolicy )
				.addPolicy ( ZMQSocketType.SUB, SubscribePolicy );
		}
		
		
		public function connect ( address : String, port : uint ) : void {
			
			if ( socket.connected ) close ( );
			
			addEventListeners ( );
//			TODO implement socket monitor so it works regardless of server being live
//			socketMonitor	= new SocketMonitor ( address, port );
//			monitorSocket ( );
			socket.connect ( address, port );
		}
		
		
		public function send ( message : Array, address : String = "" ) : void {
			
			policyContext.send ( message, address );
		}
		
		
		public function close ( ) : void {
			
			handshakeComplete = false;
			socket.close ( );
			removeEventListeners ( );
		}
		
//		TODO handle unsubscribe
		public function setSocketOption ( optionName : String, optionValue : Object ) : void {
			
			if ( policyContext.socketOptionSupported().indexOf(optionName) != -1 ) {
				
				if ( optionName == SocketOption.IDENTITY && getOption ( optionName ) != null ) {
					throw new Error ( "Socket identity has already been set.");
				} else {
					options.push ( new Option ( optionName, optionValue ) );
				}
			} else {
				
				throw new Error ( "This socket type does not support specified option." );
			}
		}
		
		
		private function onSocketStatus ( event : StatusEvent ) : void {
			
		}
		
		
		private function connectHandler ( event : Event ) : void {
			
			handshake ( );
			connectEvent = event.clone ( );
		}
		
		
		private function socketDataHandler ( event : ProgressEvent ) : void {
			
			var byteArray : ByteArray = new ByteArray ( );
			
			socket.readBytes ( byteArray );
			
			if ( !handshakeComplete ) {
				
				handshakeComplete = true;
				dispatchEvent ( connectEvent );
			} else {
				
				var response : Array = policyContext.receive ( byteArray );
				if ( response != null ) {
					dispatchEvent ( new ZMQEvent ( ZMQEvent.MESSAGE_RECEIVED, response ) );
					dispatchEvent ( event.clone ( ) );
				}
			}
		}
		
		
		private function closeHandler ( event : Event ) : void {
			
			handshakeComplete = false;
			dispatchEvent ( event.clone ( ) );
		}
		
		
		private function securityErrorHandler ( event : SecurityErrorEvent ) : void {
			
			dispatchEvent ( event.clone ( ) );
		}
		
		
		private function errorHandler ( event : IOErrorEvent ) : void {
			
			dispatchEvent ( event.clone ( ) );
		}
		
		
		private function addEventListeners ( ) : void {
			
			socket.addEventListener ( Event.CONNECT, connectHandler );
			socket.addEventListener ( ProgressEvent.SOCKET_DATA, socketDataHandler );
			socket.addEventListener ( Event.CLOSE, closeHandler );
			socket.addEventListener ( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
			socket.addEventListener ( IOErrorEvent.IO_ERROR, errorHandler );
		}
		
		
		private function removeEventListeners ( ) : void {
			
			socket.removeEventListener ( Event.CONNECT, connectHandler );
			socket.removeEventListener ( ProgressEvent.SOCKET_DATA, socketDataHandler );
			socket.removeEventListener ( Event.CLOSE, closeHandler );
			socket.removeEventListener ( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
			socket.removeEventListener ( IOErrorEvent.IO_ERROR, errorHandler );
		}


		private function handshake ( ) : void {
			
			var identity : String = ( getOption ( SocketOption.IDENTITY ) != null ) ? getOption ( SocketOption.IDENTITY ) [ 0 ].optionValue as String : "";
			
			var byteArray : ByteArray = new ByteArray();
			byteArray.writeUTFBytes ( identity );
			
			socket.writeByte ( byteArray.length + 1 );
			socket.writeByte ( 0 );
			socket.writeBytes ( byteArray );
		}

		
	}
}
