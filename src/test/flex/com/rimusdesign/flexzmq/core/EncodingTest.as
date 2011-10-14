package com.rimusdesign.flexzmq.core {


	import org.flexunit.Assert;
	import flash.utils.ByteArray;
	
	
	public class EncodingTest {
		
		
		public var byteArray	: ByteArray;
		public var lipsum		: String = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
		
		
		[Before]
		public function setUp ( ) : void {
			
			byteArray = new ByteArray ( );
		}
		
		
		[After]
		public function tearDown ( ) : void {
			
			byteArray = null;
		}
		
		
		[Test]
		public function testFrameEncoding ( ) : void {
			
			byteArray.writeUTFBytes ( lipsum );
			Assert.assertEquals ( "Value read should match the value given when written.", lipsum, Encoding.readFrame ( Encoding.writeFrame ( byteArray ) ).readUTFBytes ( lipsum.length ) );
		}
		
		
	}
}
