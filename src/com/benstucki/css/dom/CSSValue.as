package com.benstucki.css.dom
{
	import org.w3c.css.sac.ILexicalUnit;
	import org.w3c.css.dom.ICSSValue;
	import com.benstucki.css.sac.LexicalUnit;
	
	public class CSSValue implements ICSSValue
	{
		
		public var lexicalUnit:ILexicalUnit;
		
		public function get cssText():String {
			return lexicalUnit.stringValue;
		}
		
		public function set cssText( value:String ):void {
			lexicalUnit = new LexicalUnit(value);
		}
		
		public function get cssValueType():uint {
			return 0;
		}
		
		// non standard interface
		public function setCSSValueObject( value:ILexicalUnit ):void {
			lexicalUnit = value;
		}
		
	}
}