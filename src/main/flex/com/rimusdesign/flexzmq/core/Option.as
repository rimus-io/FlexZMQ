package com.rimusdesign.flexzmq.core {
	
	
	/**
	 * @author rimaskrivickas
	 */
	
	
	public class Option {


		private var _optionName		: String;
		private var _optionValue	: Object;


		public function Option ( optionName : String, optionValue : Object ) {
			
			_optionName		= optionName;
			_optionValue	= optionValue;
		}


		public function get optionName ( ) : String {
			
			return _optionName;
		}


		public function get optionValue ( ) : Object {
			
			return _optionValue;
		}
		

	}
	
	
}
