package com.benstucki.css.sac
{
	import org.w3c.css.sac.ISelector;
	import org.w3c.css.sac.ICondition;
	import org.w3c.css.sac.ISelectorFactory;
	import org.w3c.css.sac.ISimpleSelector;
	import org.w3c.css.sac.IElementSelector;
	import org.w3c.css.sac.IProcessingInstructionSelector;
	import org.w3c.css.sac.ICharacterDataSelector;
	import org.w3c.css.sac.IDescendantSelector;
	import org.w3c.css.sac.IConditionalSelector;
	import org.w3c.css.sac.INegativeSelector;
	import org.w3c.css.sac.ISiblingSelector;

	public class SelectorFactory implements ISelectorFactory
	{
		public function createPseudoElementSelector(namespaceURI:String, pseudoName:String):IElementSelector
		{
			return null;
		}
		
		public function createProcessingInstructionSelector(target:String, data:String):IProcessingInstructionSelector
		{
			return null;
		}
		
		public function createCDataSectionSelector(data:String):ICharacterDataSelector
		{
			return null;
		}
		
		public function createDescendantSelector(parent:ISelector, descendant:ISimpleSelector):IDescendantSelector {
			return new DescendantSelector(parent, descendant);
		}
		
		public function createElementSelector(namespaceURI:String, tagName:String):IElementSelector {
			return new ElementSelector(namespaceURI, tagName);
		}
		
		public function createTextNodeSelector(data:String):ICharacterDataSelector
		{
			return null;
		}
		
		public function createCommentSelector(data:String):ICharacterDataSelector
		{
			return null;
		}
		
		public function createRootNodeSelector():ISimpleSelector
		{
			return null;
		}
		
		public function createAnyNodeSelector():ISimpleSelector {
			return new SimpleSelector();
		}
		
		public function createChildSelector(parent:ISelector, child:ISimpleSelector):IDescendantSelector {
			return new DescendantSelector( parent, child, true );
		}
		
		public function createConditionalSelector(selector:ISimpleSelector, condition:ICondition):IConditionalSelector {
			return new ConditionalSelector( selector, condition );
		}
		
		public function createNegativeSelector(selector:ISimpleSelector):INegativeSelector {
			return new NegativeSelector( selector );
		}
		
		public function createDirectAdjacentSelector(nodeType:uint, child:ISelector, directAdjacent:ISimpleSelector):ISiblingSelector {
			return new SiblingSelector( nodeType, child, directAdjacent );
		}
		
	}
}