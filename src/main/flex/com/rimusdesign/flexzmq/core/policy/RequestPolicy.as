package com.rimusdesign.flexzmq.core.policy {


	import com.rimusdesign.flexzmq.SocketOption;
	import com.rimusdesign.flexzmq.core.Encoding;

	import flash.net.Socket;
	import flash.utils.ByteArray;



	/**
	 * @author rimaskrivickas
	 */
	public class RequestPolicy implements Policy {


		private var socket		: Socket;
		private var getOption	: Function;


		public function RequestPolicy ( socket : Socket, getOption : Function ) {
			
			this.socket		= socket;
			this.getOption	= getOption;
		}
		
		
		public function socketOptionSupported ( ) : Array {
			
			return [
				SocketOption.IDENTITY
			];
		}


		public function send ( message : Array, address : String = "" ) : void {
			
			var byteArray : ByteArray = new ByteArray ( );
			
			byteArray.writeBytes ( writeAddress ( address ) );
			
			while ( message.length > 0 ) {
				var data : ByteArray = new ByteArray ( );
				data.writeUTFBytes ( message.shift ( ) );
				byteArray.writeBytes ( Encoding.writeFrame ( data, message.length > 0 ) );
			}
			
			socket.writeBytes ( byteArray );
		}
		
		
		public function receive ( data : ByteArray ) : Array {
			
			var response	: Array = new Array ( );
			var message		: Vector.<ByteArray> = new Vector.<ByteArray> ( );
			
			while ( data.bytesAvailable > 0 ) {
				message.push ( Encoding.readFrame ( data ) );
			}
			
			for each ( var byteArray : ByteArray in message ) {
				response.push ( byteArray.readUTFBytes ( byteArray.bytesAvailable ) );
			}
			
			// Remove first frame as it's an emplty frame for REQ-REP connection
			response.shift();
			
			return response;
		}
		
		
//		TODO this not working see >> http://zguide.zeromq.org/page:all#Request-Reply-Envelopes
		private function writeAddress ( address : String ) : ByteArray {
			
			var data : ByteArray = new ByteArray ( );
			data.writeUTFBytes ( address );
			return Encoding.writeFrame ( data, true );
		}
		
		
	}
	
	
}
