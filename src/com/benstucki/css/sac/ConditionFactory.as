package com.benstucki.css.sac
{
	import org.w3c.css.sac.ICondition;
	import org.w3c.css.sac.IConditionFactory;
	import org.w3c.css.sac.ICombinatorCondition;
	import org.w3c.css.sac.IAttributeCondition;
	import org.w3c.css.sac.IContentCondition;
	import org.w3c.css.sac.INegativeCondition;
	import org.w3c.css.sac.IAttributeCondition;
	import org.w3c.css.sac.IPositionalCondition;
	import org.w3c.css.sac.ILangCondition;
	import org.w3c.css.sac.ConditionTypes;
	
	public class ConditionFactory implements IConditionFactory
	{
		public function createOrCondition(first:ICondition, second:ICondition):ICombinatorCondition {
			return new CombinatorCondition( first, second, ConditionTypes.SAC_OR_CONDITION );
		}
		
		public function createAndCondition(first:ICondition, second:ICondition):ICombinatorCondition {
			return new CombinatorCondition( first, second, ConditionTypes.SAC_AND_CONDITION );
		}
		
		public function createAttributeCondition(localName:String, namespaceURI:String, specified:Boolean, value:String):IAttributeCondition {
			return new AttributeCondition(localName, namespaceURI, specified, value, ConditionTypes.SAC_ATTRIBUTE_CONDITION);
		}
		
		public function createOnlyChildCondition():ICondition
		{
			return null;
		}
		
		public function createContentCondition(data:String):IContentCondition
		{
			return null;
		}
		
		public function createNegativeCondition(condition:ICondition):INegativeCondition
		{
			return null;
		}
		
		public function createPseudoClassCondition(namespaceURI:String, value:String):IAttributeCondition {
			return new AttributeCondition(null,namespaceURI,true,value,ConditionTypes.SAC_PSEUDO_CLASS_CONDITION);
		}
		
		public function createPositionalCondition(position:int, typeNode:Boolean, type:Boolean):IPositionalCondition {
			return new PositionalCondition( position, typeNode, type );
		}
		
		public function createNthPositionalCondition(position:int, typeNode:Boolean, type:Boolean, grouping:int=0):PositionalCondition {
			return new PositionalCondition( position, typeNode, type, grouping );
		}
		
		public function createOneOfAttributeCondition(localName:String, namespaceURI:String, specified:Boolean, value:String):IAttributeCondition {
			return new AttributeCondition( localName, namespaceURI, specified, value, ConditionTypes.SAC_ONE_OF_ATTRIBUTE_CONDITION );
		}
		
		public function createLangCondition(lang:String):ILangCondition
		{
			return null;
		}
		
		public function createIdCondition(value:String):IAttributeCondition {
			return new AttributeCondition( null, null, true, value, ConditionTypes.SAC_ID_CONDITION );
		}
		
		public function createOnlyTypeCondition():ICondition
		{
			return null;
		}
		
		public function createBeginHyphenAttributeCondition(localName:String, namespaceURI:String, specified:Boolean, value:String):IAttributeCondition {
			return new AttributeCondition( localName, namespaceURI, specified, value, ConditionTypes.SAC_BEGIN_HYPHEN_ATTRIBUTE_CONDITION );
		}
		
		public function createClassCondition(namespaceURI:String, value:String):IAttributeCondition {
			return new AttributeCondition( null, namespaceURI, true, value, ConditionTypes.SAC_CLASS_CONDITION );
		}
		
	}
}