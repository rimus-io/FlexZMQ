package com.rimusdesign.flexzmq {


	import flash.events.Event;


	
	public class ZMQEvent extends Event {
		
		
		public static const MESSAGE_RECEIVED	: String = "messageReceived";
		
		
		private var _data	: Array;
		
		
		public function ZMQEvent ( type : String, data : Array = null ) {
			
			_data	= data;
			
			super ( type, true, false );
		}


		public function get data ( ) : Array {
			
			return _data;
		}
		
		
		override public function clone ( ) : Event {
			
			return new ZMQEvent ( type, data );
		}
		
		
	}
	
	
}
