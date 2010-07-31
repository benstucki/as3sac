package com.benstucki.css.sac
{
	import org.w3c.css.sac.*;
	import com.benstucki.css.sac.*;
	import flash.utils.getQualifiedClassName;
	import mx.core.UIComponent;
	import flash.display.DisplayObject;
	import mx.events.StateChangeEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import mx.controls.Button;
	import mx.skins.halo.ButtonSkin;
	import mx.events.FlexEvent;
	import com.benstucki.css.dom.*;
	import mx.controls.listClasses.ListBase;
	import mx.controls.listClasses.ListBaseContentHolder;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.events.ChildExistenceChangedEvent;

	/**
	 * @inheritDoc IDocumentHandler
	 */
	public class FlexHandler implements IDocumentHandler
	{	
		private var _root:UIComponent;
		private var _css:String;
		
		private var _style:CSSStyleSheet = new CSSStyleSheet();
		private var _rule:CSSRule = new CSSRule();
		
		//protected var parser:Parser = new Parser();
		protected var selectedItems:Array = new Array();
		
		/**
		 * In liveUpdate mode the FlexHandler will automatically restyle components when:
		 * <ul>
		 * <li>components are added dynamically</li>
		 * <li>a value used in a CSS condition is changed</li>
		 * </ul>
		 */
		private var _liveUpdate:Boolean;
		public function get liveUpdate():Boolean { return _liveUpdate; }
		public function set liveUpdate( value:Boolean ):void { _liveUpdate = value; }
		
		public function FlexHandler( root:UIComponent ) {
			_root = root;
			//_root.addEventListener(ChildExistenceChangedEvent.CHILD_ADD, evaluateNewComponent, true, 0, false);
			_root.addEventListener(Event.ADDED, evaluateLater, true, 0, false);
		}
		
		public function importStyle(uri:String, media:ISACMediaList, defaultNamespaceURI:String):void
		{
		}
		
		public function endMedia(media:ISACMediaList):void
		{
		}
		
		public function startSelector(selectors:ISelectorList):void {
			selectedItems = new Array();
			_rule = new CSSStyleRule();
			CSSStyleRule(_rule).selectors = selectors;
			evaluateComponent( selectors, _root );
		}
		
		public function endFontFace():void
		{
		}
		
		public function ignorableAtRule(atRule:String):void
		{
		}
		
		public function endDocument(source:String):void {}
		
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
			_css = source;
		}
		
		public function namespaceDeclaration(prefix:String, uri:String):void
		{
		}
		
		public function property(name:String, value:ILexicalUnit, important:Boolean):void{
			applyProperty(name, value, important);
			CSSStyleRule(_rule).declaration.setPropertyObject(name, value, important);
		}
		
		public function endPage(name:String, pseudo_page:String):void
		{
		}
		
		public function endSelector(selectors:ISelectorList):void {
			_style.insertRuleObject(_rule, _style.cssRules.length);
		}
		
		// Protected and Private methods
		protected function evaluateComponent( selectors:ISelectorList, obj:UIComponent ):void {
			trace(obj);
			for(var j:uint=0;j<selectors.length;j++) {
				if( passCombinators(selectors.item(j), obj) ) { selectedItems.push( obj ); }
			}
			for(var i:uint=0;i<obj.numChildren;i++){
				var child:* = obj.getChildAt(i);
				if(child is UIComponent) { evaluateComponent( selectors, child ); }
			}
		}
		
		protected function passCombinators( selector:ISelector, obj:UIComponent ):Boolean {
			var pass:Boolean = false;
			switch( selector.selectorType ) {
				case SelectorTypes.SAC_DESCENDANT_SELECTOR:
					if( passSelectors( IDescendantSelector(selector).simpleSelector, obj ) ) {
						var owner:* = obj.owner;
						while(pass==false && owner!=_root.owner) {
							if( owner is UIComponent ) {
								pass = passCombinators( IDescendantSelector(selector).ancestorSelector, UIComponent(owner) );
								owner = UIComponent(owner).owner
							}
						}
					}
					break;
				case SelectorTypes.SAC_CHILD_SELECTOR:
					if( passSelectors( IDescendantSelector(selector).simpleSelector, obj ) ) {
						pass = passCombinators( IDescendantSelector(selector).ancestorSelector, UIComponent(obj.owner) )
					}
					break;
				default:
					pass = passSelectors( selector, obj );
					break;
			}
			return pass;
		}
		
		protected function passSelectors( selector:ISelector, obj:UIComponent ):Boolean {
			var pass:Boolean = false;
			switch( selector.selectorType ) {
				case SelectorTypes.SAC_ANY_NODE_SELECTOR:
					pass = true;
					break;
				case SelectorTypes.SAC_ELEMENT_NODE_SELECTOR:
					if( obj.className == IElementSelector(selector).localName && passNamespace(IElementSelector(selector).namespaceURI, flash.utils.getQualifiedClassName(obj)) ) {
						pass = true;
					}
					break;
				case SelectorTypes.SAC_CONDITIONAL_SELECTOR:
					if( passSelectors(IConditionalSelector(selector).simpleSelector, obj) ) {
						pass = passConditions(IConditionalSelector(selector).condition, obj);
					}
					break;
			}
			return pass;
		}
		
		protected function passConditions( condition:ICondition, obj:UIComponent ):Boolean {
			var pass:Boolean = false;
			switch( condition.conditionType ) {
				case ConditionTypes.SAC_ID_CONDITION:
					if( obj.name==IAttributeCondition(condition).value && passNamespace( IAttributeCondition(condition).namespaceURI, flash.utils.getQualifiedClassName(obj)) ) {
						pass = true;
					}
					break;
				case ConditionTypes.SAC_CLASS_CONDITION:
					if( obj.styleName==IAttributeCondition(condition).value && passNamespace( IAttributeCondition(condition).namespaceURI, flash.utils.getQualifiedClassName(obj)) ) {
						pass = true
					}
					break;
				case ConditionTypes.SAC_PSEUDO_CLASS_CONDITION:
					if( passNamespace( IAttributeCondition(condition).namespaceURI, flash.utils.getQualifiedClassName(obj)) ) {
						if( obj.currentState==IAttributeCondition(condition).value ) { pass = true; }
						//obj.addEventListener(mx.events.FlexEvent.ENTER_STATE, replay, false, 0, false);
					}
					break;
				case ConditionTypes.SAC_POSITIONAL_CONDITION:
					var position:Number;
					if(obj.owner is ListBaseContentHolder) {
						if(UIComponent(obj.owner).owner is ListBase && obj is IListItemRenderer){
							position = ListBase(UIComponent(obj.owner).owner).itemRendererToIndex(IListItemRenderer(obj));
						}
					} else { position = obj.owner.getChildIndex(obj); }
					var iteration:Number = position / PositionalCondition(condition).grouping;
					if(position<=0) {iteration=0;}
					var remainder:int = position - (Math.floor(iteration) * PositionalCondition(condition).grouping)
					if( remainder == IPositionalCondition(condition).position ) {
						pass = true;
					}
					break;
				case ConditionTypes.SAC_ATTRIBUTE_CONDITION:
					if( obj.hasOwnProperty(IAttributeCondition(condition).localName) ) {
						if( IAttributeCondition(condition).specified ) {
							if( obj[IAttributeCondition(condition).localName]==IAttributeCondition(condition).value && passNamespace( IAttributeCondition(condition).namespaceURI, flash.utils.getQualifiedClassName(obj)) ) {
								pass = true;
							}
						} else { pass = true; }
					}
					break;
				case ConditionTypes.SAC_AND_CONDITION:
					if( passConditions(ICombinatorCondition(condition).firstCondition, obj) && passConditions(ICombinatorCondition(condition).secondCondition, obj) ) {
						pass = true;
					}
			}
			return pass;
		}
		
		protected function passNamespace( ns1:String, ns2:String ):Boolean {
			var pass:Boolean = false;
			if( ns1==null ) { pass = true; }
			else {}
			return pass;
		}
		
		protected function printSelectors( selectors:ISelectorList ):String {
			var result:String = "";
			var length:int = selectors.length;
			for (var i:int = 0; i < length; i++) {
				result += printSelector( selectors.item(i) );
				if( i==length-1 ) { result += " {\n"; }
				else { result += ",\n"; }
			}
			return result;
		}
		
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
		
		protected function applyProperty(name:String, value:ILexicalUnit, important:Boolean):void{
			for(var i:uint;i<selectedItems.length;i++) {
				UIComponent(selectedItems[i]).setStyle(name, value.stringValue);
			}
		}
		
		protected function evaluateLater( event:Event ):void {
			if(event.target is UIComponent) {
				UIComponent(event.target).addEventListener(FlexEvent.CREATION_COMPLETE, evaluateNewComponent);
			}
		}
		
		protected function evaluateNewComponent( event:Event ):void {
			trace("new-----------------------------");
			if(event.target is UIComponent) {
				for(var i:uint=0;i<_style.cssRules.length;i++) {
					//if(_style.cssRules.item(i) is ICSSStyleRule) {
						var rule:CSSStyleRule = CSSStyleRule(_style.cssRules.item(i));
						selectedItems = new Array();
						evaluateComponent( rule.selectors, UIComponent(event.target) );
						for(var j:uint=0;j<rule.declaration.length;j++) {
							applyProperty(rule.declaration.item(j), CSSValue(rule.declaration.getPropertyCSSValue(rule.declaration.item(j))).lexicalUnit, false);
						}
					//}
				}
			}
			
		}
		
	}
}