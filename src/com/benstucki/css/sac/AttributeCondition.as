package com.benstucki.css.sac
{
	import org.w3c.css.sac.IAttributeCondition;
	import org.w3c.css.sac.ConditionTypes;

	public class AttributeCondition implements IAttributeCondition
	{
		private var _value:String;
		private var _namespaceURI:String;
		private var _specified:Boolean;
		private var _localName:String;
		private var _type:uint;
		
		public function AttributeCondition( localName:String, namespaceURI:String, specified:Boolean, value:String, type:uint ) {
			_value = value;
			_namespaceURI = namespaceURI;
			_localName = localName;
			_specified = specified;
			_type = type;
		}
		
		public function get value():String { return _value; }

		public function get namespaceURI():String { return _namespaceURI; }

		public function get specified():Boolean { return _specified; }

		public function get localName():String { return _localName; }

		public function get conditionType():uint { return _type; }
		
	}
}