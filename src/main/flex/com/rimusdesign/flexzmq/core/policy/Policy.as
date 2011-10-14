package com.rimusdesign.flexzmq.core.policy {


	import flash.utils.ByteArray;
	
	
	/**
	 * @author rimaskrivickas
	 */
	
	
	public interface Policy {
		
		
		function send ( message : Array, address : String = "" )	: void;
		function receive ( data : ByteArray )						: Array;
		function socketOptionSupported ( )							: Array;
		
		
	}
}
