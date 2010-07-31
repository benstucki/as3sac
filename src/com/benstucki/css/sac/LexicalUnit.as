package com.benstucki.css.sac
{
	import org.w3c.css.sac.ILexicalUnit;

	public class LexicalUnit implements ILexicalUnit
	{
		private var _text:String;
		public function LexicalUnit( value:String ) {
			_text = value;
		}
		
		public function get floatValue():Number
		{
			return 0;
		}
		
		public function get integerValue():int
		{
			return 0;
		}
		
		public function get previousLexicalUnit():ILexicalUnit
		{
			return null;
		}
		
		public function get functionName():String
		{
			return null;
		}
		
		public function get subValues():ILexicalUnit
		{
			return null;
		}
		
		public function get parameters():ILexicalUnit
		{
			return null;
		}
		
		public function get dimensionUnitText():String
		{
			return null;
		}
		
		public function get nextLexicalUnit():ILexicalUnit
		{
			return null;
		}
		
		public function get lexicalUnitType():uint
		{
			return 0;
		}
		
		public function get stringValue():String
		{
			return _text;
		}
		
	}
}