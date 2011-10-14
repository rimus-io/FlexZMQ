package com.rimusdesign.flexzmq.core.policy {


	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * @author rimaskrivickas
	 */
	public class PolicyContext implements Policy {
		
		
		private var socket			: Socket;
		private var getOption		: Function;
		private var policies		: Dictionary;
		private var activePolicy	: Policy;


		public function PolicyContext ( socket : Socket, getOption : Function ) {
			
			this.socket		= socket;
			this.getOption	= getOption;
			this.policies	= new Dictionary ();
		}

		
		public function activatePolicy ( key : String ) : void {
			
			activePolicy = new ( policies [ key ] as Class ) ( socket, getOption );
		}
		
		
		public function addPolicy ( key : String, policy : Class ) : PolicyContext {
			
			policies [ key ] = policy;
			
			return this;
		}
		
		
		public function socketOptionSupported ( ) : Array {
			
			return activePolicy.socketOptionSupported ( );
		}
		
		
		public function send ( message : Array, address : String = "" ) : void {
			
			activePolicy.send ( message, address );
		}
		
		
		public function receive ( data : ByteArray ) : Array {
			
			return activePolicy.receive ( data );
		}
		
		
	}
}
