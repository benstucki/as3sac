package com.benstucki.css.dom
{
	import org.w3c.css.dom.*;
	import com.benstucki.css.sac.LexicalUnit;
	import org.w3c.css.sac.ILexicalUnit;

	public class CSSStyleDeclaration implements ICSSStyleDeclaration
	{
		
		private var _properties:Array = new Array(); // names
		private var _values:Array = new Array(); // CSSValue
		private var _parentRule:CSSRule;
		
		public function getPropertyValue(propertyName:String):String {
			return _values[propertyName].cssText;
		}
		
		public function removeProperty(propertyName:String):String {
			return null;
		}
		
		public function get length():uint {
			return _properties.length;
		}
		
		public function setProperty(propertyName:String, value:String, priority:String):void {
			_properties.push(propertyName);
			var cssValue:CSSValue = new CSSValue();
			cssValue.setCSSValueObject(new LexicalUnit(value));
			_values[propertyName] = cssValue;
		}
		
		public function get cssText():String {
			var result:String = "";
			for(var i:uint=0;i<length;i++) {
				result += _properties[i] + CSSValue(_values[i]).cssText + ";\r\n";
			}
			return result;
		}
		
		public function set cssText(value:String):void
		{
		}
		
		public function getPropertyCSSValue(propertyName:String):ICSSValue {
			return _values[propertyName];
		}
		
		public function get parentRule():ICSSRule {
			return _parentRule;;
		}
		
		public function item(index:uint):String {
			return _properties[index];
		}
		
		// non standard interface
		
		public function setPropertyObject(propertyName:String, value:ILexicalUnit, priority:Boolean):void {
			_properties.push(propertyName);
			var cssValue:CSSValue = new CSSValue();
			cssValue.setCSSValueObject(value);
			_values[propertyName] = cssValue;
		}
		
	}
}