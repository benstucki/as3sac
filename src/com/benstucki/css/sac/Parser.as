package com.benstucki.css.sac
{
	import org.w3c.css.sac.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	// this parser desperately needs to be rewritten
	public class Parser implements IParser
	{
		
		private var _handler:IDocumentHandler;
		private var _sFactory:ISelectorFactory;
		private var _cFactory:IConditionFactory;
		
		public function Parser():void {}
		
		public function get parserVersion():String { return null; }
		public function set documentHandler( handler:IDocumentHandler ):void { _handler = handler; }
		public function set selectorFactory( factory:ISelectorFactory ):void { _sFactory = factory; }
		public function set conditionFactory( factory:IConditionFactory ):void { _cFactory = factory; }
		
		public function loadStyleSheet( request:URLRequest ):void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener( Event.COMPLETE, onComplete, false, 0, false );
			loader.load( request );
		}
		
		public function parseStyleSheet( css:String ):void {
			if( _handler==null ) { _handler = new DocumentHandler(); }
			if( _sFactory==null ) { _sFactory = new SelectorFactory(); }
			if( _cFactory==null ) { _cFactory = new ConditionFactory(); }
			
			_handler.startDocument( css );
			
			var rules:Array = css.split("}");
			var length:uint = rules.length-1;
			for(var i:uint=0; i < length; i++) {
				parseRule( rules[i] );
			}
			
			_handler.endDocument( css );
		}
		
		public function parseRule( rule:String ):void {
			var x:Array = rule.split("{");
			var selectors:ISelectorList = parseSelectors( trim(x[0]) );
			_handler.startSelector( selectors );
			parseStyleDeclaration( trim(x[1]) );
			_handler.endSelector( selectors );
		}
		
		public function parseStyleDeclaration( declaration:String ):void {
			var properties:Array = declaration.split(";");
			var length:uint = properties.length-1;
			for(var i:uint = 0; i < length; i++) {
				var x:Array = properties[i].split(":");
				_handler.property( trim(x[0]), parsePropertyValue( trim(x[1]) ), false );
			}
		}
		
		public function parsePriority(priority:String):Boolean {
			return false;
		}
		
		public function parsePropertyValue(value:String):ILexicalUnit {
			var lex:LexicalUnit = new LexicalUnit(value);
			return lex;
		}
		
		public function set errorHandler(handler:IErrorHandler):void
		{
		}
		
		public function set locale(locale:*):void
		{
		}
		
		public function parseSelectors(selectors:String):ISelectorList {
			var list:SelectorList = new SelectorList();
			var array:Array = selectors.split(",");
			for (var i:uint=0;i<array.length;i++) {
				list.addItem( parseCombinators(array[i]) );
			}
			//list.addItem( parseCombinators(selectors) );
			return list;
		}
		
		// Private and Protected Functions
		protected function parseCombinators( selectors:String ):ISelector {
			var t:ISelector;
			var inCondition:Boolean = false;
			selectors = trim(selectors);
			for(var i:int=selectors.length-1;i>=0;i--) {
				switch( selectors.charAt(i) ) {
					case ")":
						inCondition = true;
						break;
					case "(":
						if(inCondition) {
							inCondition = false;
						}
						break;
					case " ":
						if(!inCondition) {
							var nextControl:String = trim(selectors.substring(0,i));
							nextControl = nextControl.charAt(nextControl.length-1);
							if ( nextControl!=">" && nextControl!="+" && nextControl!="~" ) {
								t = _sFactory.createDescendantSelector( parseCombinators(selectors.substring(0,i)), parseSimpleSelectors(selectors.substr(i+1)) );
								i = -1;
							}
						}
						break;
					case ">":
						if(!inCondition) {
							t = _sFactory.createChildSelector( parseCombinators(selectors.substring(0,i)), parseSimpleSelectors(selectors.substr(i+1)) );
							i = -1;
						}
						break;
					case "+":
						if(!inCondition) {
							t = _sFactory.createDirectAdjacentSelector( 0, parseCombinators(selectors.substring(0,i)), parseSimpleSelectors(selectors.substr(i+1)) );
							i = -1;
						}
						break;
					case "~":
						if(!inCondition) {
							i = -1;
						}
						break;
				}
			}
			if(t==null) { t = parseSimpleSelectors( selectors ); }
			return t;
		}
		
		protected function parseSimpleSelectors( selectors:String ):ISimpleSelector {
			var t:ISimpleSelector;
			var temp:String = "";
			var ns:String = null;
			selectors = trim(selectors);
			for(var i:int=0;i<selectors.length;i++) {
				switch( selectors.charAt(i) ) {
					case "|":
						ns = temp;
						temp="";
						break;
					case "#":
					case ".":
					case "[":
					case ":":
						if(i>0 && temp!="*") { t = _sFactory.createConditionalSelector( _sFactory.createElementSelector(ns, temp), parseConditions(selectors.substr(i)) ); }
						else { t =  _sFactory.createConditionalSelector( _sFactory.createAnyNodeSelector(), parseConditions(selectors.substr(i)) ); }
						i = selectors.length;
						break;
					default:
						temp += selectors.charAt(i);
						break;
				}
			}
			if(t==null) {
				if(temp=="*") { t = _sFactory.createAnyNodeSelector(); }
				else { t = _sFactory.createElementSelector(ns, temp); }
			}
			return t;
		}

		protected function parseConditions( conditions:String ):ICondition {
			var c:ICondition;
			var temp:String = "";
			var inAttribute:Boolean = false;
			conditions = trim(conditions);
			for(var i:int=conditions.length-1;i>=0;i--) {
				switch( conditions.charAt(i) ) {
					case "]":
						inAttribute = true;
						break;
					case "[":
						if(inAttribute) {
							if(i==0) { c = parseAttributeCondition(temp); } // _cFactory.createAttributeCondition(temp, "", false, "")
							else { c = _cFactory.createAndCondition( parseConditions( conditions.substring(0,i) ), parseAttributeCondition(temp) ); } // _cFactory.createAttributeCondition(temp, "", false, "")
							inAttribute = false;
							i = -1;
						}
						break;
					case "#":
						if(!inAttribute) {
							if(i==0) { c = _cFactory.createIdCondition(temp); }
							else { c = _cFactory.createAndCondition( parseConditions( conditions.substring(0,i) ), _cFactory.createIdCondition(temp) ); }
							i = -1;
							break;
						}
					case ".":
						if(!inAttribute) {
							if(i==0) { c = _cFactory.createClassCondition(null,temp); }
							else { c = _cFactory.createAndCondition( parseConditions( conditions.substring(0,i) ), _cFactory.createClassCondition(null,temp) ); }
							i = -1;
							break;
						}
					case ":":
						if(!inAttribute) {
							if(i==0) { c = parsePseudoCondition(temp) }
							else { c = _cFactory.createAndCondition( parseConditions( conditions.substring(0,i) ), parsePseudoCondition(temp) ); }
							i = -1;
							break;
						}
					default:
						temp = conditions.charAt(i) + temp;
						break;
				}
			}
			return c;
		}
		
		protected function parseAttributeCondition( condition:String ):IAttributeCondition {
			var c:IAttributeCondition;
			var n:String = "";
			var v:String = "";
			var s:Boolean = false;
			var t:uint = ConditionTypes.SAC_ATTRIBUTE_CONDITION;
			var quotes:uint = 0;
			condition = trim(condition);
			for(var i:int=condition.length-1;i>=0;i--) {
				switch( condition.charAt(i) ) {
					case "\"":
						if( quotes==1 && condition.charAt(i-1)=="\"" ) {
							n = "\"" + n;
							i--;
						}
						else { quotes++; }
						break;
					case "=":
						s = true;
						v = n;
						n = "";
						switch( condition.charAt(i-1) ) {
							case "~":
								t = ConditionTypes.SAC_ONE_OF_ATTRIBUTE_CONDITION;
								i--;
								break;
							case "|":
								t = ConditionTypes.SAC_BEGIN_HYPHEN_ATTRIBUTE_CONDITION;
								i--;
								break;
						}
						break;
					default:
						n = condition.charAt(i) + n;
				}
			}
			switch( t ) {
				case ConditionTypes.SAC_ONE_OF_ATTRIBUTE_CONDITION:
					c = _cFactory.createOneOfAttributeCondition(trim(n), "", s, trim(v));
					break;
				case ConditionTypes.SAC_BEGIN_HYPHEN_ATTRIBUTE_CONDITION:
					c = _cFactory.createBeginHyphenAttributeCondition(trim(n), "", s, trim(v));
					break;
				default:
					c = _cFactory.createAttributeCondition(trim(n), "", s, trim(v));
					break;
			}
			return c;
		}

		protected function parsePseudoCondition( condition:String ):ICondition {
			var c:ICondition;
			condition = trim(condition);
			if(condition.substr(0, 10)=="nth-child(") {
				var group:String = condition.substr(0,condition.length-1).substr(10);
				c = ConditionFactory(_cFactory).createNthPositionalCondition(int(group.charAt(3)), true, true, int(group.charAt(0)));
			} else {
				c = _cFactory.createPseudoClassCondition(null,condition);
			}
			return c;
		}
		
		protected function trim( string:String ):String {
			while( string.charAt(0)==" " || string.charAt(0)=="\r" || string.charAt(0)=="\n" ){ string = string.substr(1); }
			while( string.charAt(string.length-1)==" " || string.charAt(string.length-1)=="\r" || string.charAt(string.length-1)=="\n" ){ string = string.substring(0,string.length-1) }
			return string;
		}
		
		// Event Handlers
		protected function onComplete( event:Event ):void {
			parseStyleSheet( event.target.data );
			event.currentTarget.removeEventListener( Event.COMPLETE, onComplete);
		}
		
	}
}