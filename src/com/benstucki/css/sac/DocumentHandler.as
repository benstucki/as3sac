package com.benstucki.css.sac
{
	import flash.events.*;
	import org.w3c.css.sac.*;

	[Event(name=Event.COMPLETE)]
	public class DocumentHandler extends EventDispatcher implements IDocumentHandler
	{
		private var _text:String = "";
		public function get text():String { return _text; }
		public function set text( value:String ):void { _text = value; }
		
		private var nsPrefix:String = "";
		private var nsURI:String = ""

		public function namespaceDeclaration(prefix:String, uri:String):void {
			nsPrefix = prefix;
			nsURI = uri;
		}

		public function importStyle(uri:String, media:ISACMediaList, defaultNamespaceURI:String):void
		{
		}
		
		public function endMedia(media:ISACMediaList):void
		{
		}
		
		public function startSelector(selectors:ISelectorList):void {
			var result:String = "";
			var length:int = selectors.length;
			for (var i:int = 0; i < length; i++) {
				result += printSelector( selectors.item(i) );
				if( i==length-1 ) { result += " {\n"; }
				else { result += ",\n"; }
			}
			this.text += result;
		}
		
		public function endFontFace():void
		{
		}
		
		public function ignorableAtRule(atRule:String):void
		{
		}
		
		public function endDocument(source:String):void {
			//trace("/* end document */");
			dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		public function startMedia(media:ISACMediaList):void
		{
		}
		
		public function comment(text:String):void
		{
		}
		
		public function startPage(name:String, pseudo_page:String):void
		{
		}
		
		public function startFontFace():void
		{
		}
		
		public function startDocument(source:String):void {
			//trace("/* start document */");
		}
		
		public function property(name:String, value:ILexicalUnit, important:Boolean):void {
			this.text += "  " + name + ": " + value.stringValue + ";\n";
		}
		
		public function endPage(name:String, pseudo_page:String):void
		{
		}
		
		public function endSelector(selectors:ISelectorList):void {
			this.text += "}\n";
		}
		
		// Private & Protected Functions
		protected function printSelector( selector:ISelector ):String {
			var result:String = "";
			switch ( selector.selectorType ) {
				case SelectorTypes.SAC_DESCENDANT_SELECTOR:
					result += printSelector( IDescendantSelector(selector).ancestorSelector );
					result += " " + printSelector( IDescendantSelector(selector).simpleSelector );
					break;
				case SelectorTypes.SAC_CHILD_SELECTOR:
					result += printSelector( IDescendantSelector(selector).ancestorSelector );
					result += " > " + printSelector( IDescendantSelector(selector).simpleSelector );
					break;
				case SelectorTypes.SAC_DIRECT_ADJACENT_SELECTOR:
					result += printSelector( ISiblingSelector(selector).selector );
					result += " + " + printSelector( ISiblingSelector(selector).siblingSelector );
					break;
				case SelectorTypes.SAC_CONDITIONAL_SELECTOR:
					result += printSelector( IConditionalSelector(selector).simpleSelector );
					result += printCondition( IConditionalSelector(selector).condition );
					break;
				case SelectorTypes.SAC_ELEMENT_NODE_SELECTOR:
					if( IElementSelector(selector).namespaceURI != null ) { result += IElementSelector(selector).namespaceURI + "|"; }
					result += IElementSelector(selector).localName;
					break;
				case SelectorTypes.SAC_ANY_NODE_SELECTOR:
					result += "*";
					break;
			}
			return result;
		}

		protected function printCondition( condition:ICondition ):String {
			var result:String = "";
			switch ( condition.conditionType ) {
				case ConditionTypes.SAC_ID_CONDITION:
					result += "#" + IAttributeCondition(condition).value;
					break;
				case ConditionTypes.SAC_CLASS_CONDITION:
					result += "." + IAttributeCondition(condition).value;
					break;
				case ConditionTypes.SAC_ATTRIBUTE_CONDITION:
					result += "[" + IAttributeCondition(condition).localName;
					if( IAttributeCondition(condition).specified ) { result += "=\"" + IAttributeCondition(condition).value + "\""; }
					result += "]";
					break;
				case ConditionTypes.SAC_ONE_OF_ATTRIBUTE_CONDITION:
					result += "[" + IAttributeCondition(condition).localName;
					if( IAttributeCondition(condition).specified ) { result += "~=\"" + IAttributeCondition(condition).value + "\""; }
					result += "]";
					break;
				case ConditionTypes.SAC_BEGIN_HYPHEN_ATTRIBUTE_CONDITION:
					result += "[" + IAttributeCondition(condition).localName;
					if( IAttributeCondition(condition).specified ) { result += "|=\"" + IAttributeCondition(condition).value + "\""; }
					result += "]";
					break;
				case ConditionTypes.SAC_PSEUDO_CLASS_CONDITION:
					result += ":" + IAttributeCondition(condition).value;
					break;
				case ConditionTypes.SAC_POSITIONAL_CONDITION:
					result += ":nth-child(" + PositionalCondition(condition).grouping + "n+" + IPositionalCondition(condition).position + ")";
					break;
				case ConditionTypes.SAC_AND_CONDITION:
					result += printCondition( ICombinatorCondition(condition).firstCondition );
					result += printCondition( ICombinatorCondition(condition).secondCondition );
			}
			return result;
		}
	}
}