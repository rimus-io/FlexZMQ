package com.rimusdesign.flexzmq.core.policy {


	import com.rimusdesign.flexzmq.SocketOption;
	import com.rimusdesign.flexzmq.core.Option;
	import com.rimusdesign.flexzmq.core.Encoding;

	import flash.net.Socket;
	import flash.utils.ByteArray;



	/**
	 * @author rimaskrivickas
	 */
	public class SubscribePolicy implements Policy {


		private var socket		: Socket;
		private var getOption	: Function;


		public function SubscribePolicy ( socket : Socket, getOption : Function ) {
			
			this.socket		= socket;
			this.getOption	= getOption;
		}
		
		
		public function socketOptionSupported ( ) : Array {
			
			return [
				SocketOption.IDENTITY,
				SocketOption.SUBSCRIBE,
				SocketOption.UNSUBSCRIBE
			];
		}


		public function send ( message : Array, address : String = "" ) : void {
			
			throw new Error ( "'SUB' type sockets cannot send messages." );
		}
		
		
		public function receive ( data : ByteArray ) : Array {
			
			var options : Vector.<Option> = getOption ( SocketOption.SUBSCRIBE );
			
			if ( options == null ) {
				
				return null;
			} else {
				
				var message				: Vector.<ByteArray> = new Vector.<ByteArray> ( );
				var response			: Array = new Array ( );
				var subscriptions		: Array = new Array ( );
				var matchesSubscription : Boolean = false;
				
				for each ( var option : Option in options ) {
					subscriptions.push ( option.optionValue );
				}
				
				while ( data.bytesAvailable > 0 ) {
					message.push ( Encoding.readFrame ( data ) );
				}
				
				for each ( var byteArray : ByteArray in message ) {
					response.push ( byteArray.readUTFBytes ( byteArray.bytesAvailable ) );
				}
				
				for each ( var subscription : String in  subscriptions ) {
					if ( ( response [ 0 ] as String ).indexOf ( subscription ) != -1 ) {
						matchesSubscription = true;
						break;
					}
				}
				
				return matchesSubscription ? response : null;
			}
		}
		
		
	}
	
	
}
