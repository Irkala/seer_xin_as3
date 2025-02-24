package com.robot.core.energyExchange
{
   import com.robot.core.config.xml.ItemTipXMLInfo;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.userItem.SingleItemInfo;
   
   public class ExchangeItemInfo
   {
      private var _itemName:String;
      
      public var _itemNum:uint;
      
      private var _itemSellPrice:uint;
      
      private var _itemDescription:String;
      
      private var _itemId:uint;
      
      private var _itemRule:String;
      
      private var _leftTime:uint;
      
      private var _isSuper:Boolean;
      
      public function ExchangeItemInfo(info:SingleItemInfo)
      {
         super();
         this._itemId = info.itemID;
         this._itemNum = info.itemNum;
         this._itemName = String(ItemXMLInfo.getName(info.itemID));
         this._itemDescription = ItemTipXMLInfo.getItemDes(info.itemID);
         this._itemRule = ItemXMLInfo.getRule(info.itemID);
         this._itemSellPrice = ItemXMLInfo.getSellPrice(info.itemID);
         this._leftTime = info.leftTime;
         this._isSuper = ItemXMLInfo.getIsSuper(info.itemID);
      }
      
      public function get itemSellPrice() : uint
      {
         return this._itemSellPrice;
      }
      
      public function get itemId() : uint
      {
         return this._itemId;
      }
      
      public function get itemNum() : uint
      {
         return this._itemNum;
      }
      
      public function get itemName() : String
      {
         return this._itemName;
      }
      
      public function get itemDescription() : String
      {
         return this._itemDescription;
      }
      
      public function get itemRule() : String
      {
         return this._itemRule;
      }
      
      public function get leftTime() : uint
      {
         return this._leftTime;
      }
      
      public function get isSuper() : Boolean
      {
         return this._isSuper;
      }
   }
}

