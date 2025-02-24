package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   
   public class PetBookXMLInfo
   {
      private static var _dataMap:HashMap;
      
      private static var xmlClass:Class = PetBookXMLInfo_xmlClass;
      
      setup();
      
      public function PetBookXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         _dataMap = new HashMap();
         var xl:XMLList = XML(new xmlClass()).elements("Monster");
         for each(item in xl)
         {
            _dataMap.add(item.@ID.toString(),item);
         }
      }
      
      public static function get dataList() : Array
      {
         return _dataMap.getValues();
      }
      
      public static function getPetXML(id:uint) : XML
      {
         return _dataMap.getValue(id);
      }
      
      public static function getName(id:uint) : String
      {
         return getPetXML(id).@DefName.toString();
      }
      
      public static function getType(id:uint) : String
      {
         return getPetXML(id).@Type.toString();
      }
      
      public static function getHeight(id:uint) : String
      {
         return getPetXML(id).@Height.toString();
      }
      
      public static function getWeight(id:uint) : String
      {
         return getPetXML(id).@Weight.toString();
      }
      
      public static function getFoundin(id:uint) : String
      {
         return getPetXML(id).@Foundin.toString();
      }
      
      public static function getFeatures(id:uint) : String
      {
         return getPetXML(id).@Features.toString();
      }
      
      public static function hasSound(id:uint) : Boolean
      {
         var xml:XML = getPetXML(id) as XML;
         if(Boolean(xml.hasOwnProperty("@hasSound")))
         {
            return Boolean(xml.@hasSound);
         }
         return false;
      }
      
      public static function food(id:uint) : String
      {
         return getPetXML(id).@Food.toString();
      }
   }
}

