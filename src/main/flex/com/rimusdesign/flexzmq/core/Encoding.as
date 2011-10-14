package com.rimusdesign.flexzmq.core{


	import flash.utils.ByteArray;
	
	
	/**
	 * Handles encoding of frames as described by '13/ZMTP - ZeroMQ Message Transport Protocol'.
	 * 
	 * @see http://rfc.zeromq.org/spec:13
	 */
	public class Encoding {
		
		
		public static function readFrame ( data : ByteArray ) : ByteArray {
			
			var byteArray : ByteArray = new ByteArray ( );
			
			// Get length of the frame. This includes one byte for flags.
			var length : uint = data.readUnsignedByte ( );
			
			// Check if frame is longer than 254 octets.
			var long : Boolean = ( length == 0xFF ) ? true : false;
			
			// Amend 'length' value if needed.
			if ( long ) {
				
				// If most significant 32-bits are not equal to '0', it means incoming data exceeds maximum size limit of 4294967295 bytes (4gb).
				if ( data.readUnsignedInt ( ) != 0 ) {
					throw new Error ( "incoming data exceeds maximum size limit" );
				}
				
				// Read least significant 32-bits to get the length of a long frame
				length = data.readUnsignedInt ( );
				
			}
			
			// Correct length.
			length -= 1;
			
			// Get 'more' flag value.
			var more : Boolean = ( data.readUnsignedByte ( ) & 0x01 == 1 ) ? true : false;
			
			// Get body of the frame.
			if ( length != 0 ) data.readBytes ( byteArray, 0, length );
			
			return byteArray;
			
		}
		
		
		public static function writeFrame ( data : ByteArray, more : Boolean = false ) : ByteArray {
			
			var byteArray : ByteArray = new ByteArray ( );
			
			// Determine length of the frame.
			var length : uint = data.length;
			
			// Adjust lenght value to accommodate flag
			length += 1;
			
			if ( length < 0xFF ) {
				byteArray.writeByte ( length );
				
			} else {
				byteArray.writeByte ( 0xFF );
				byteArray.writeUnsignedInt ( 0 );
				byteArray.writeUnsignedInt ( length );
			}
			
			// Set a 'more' flag.
			byteArray.writeByte ( more ? 1 : 0 );
			
			// Write data.
			byteArray.writeBytes ( data );
			
			// Once done writing reset read/write position of the byte stream.
			byteArray.position = 0;
			
			return byteArray;
			
		}
		
		
	}
	
	
}
