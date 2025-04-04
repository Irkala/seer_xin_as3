package com.robot.app.spt
{
   public class SptInfo
   {
      private var _id:uint;
      
      private var _online:Boolean;
      
      private var _status:uint;
      
      private var _title:String;
      
      private var _description:String;
      
      private var _level:uint;
      
      private var _seatID:uint;
      
      private var _enterID:uint;
      
      private var _fightCondition:String;
      
      public function SptInfo()
      {
         super();
      }
      
      public function get seatID() : uint
      {
         return this._seatID;
      }
      
      public function set seatID(id:uint) : void
      {
         this._seatID = id;
      }
      
      public function get enterID() : uint
      {
         return this._enterID;
      }
      
      public function set enterID(id:uint) : void
      {
         this._enterID = id;
      }
      
      public function get fightCondition() : String
      {
         return this._fightCondition;
      }
      
      public function set fightCondition(con:String) : void
      {
         this._fightCondition = con;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function set id(id:uint) : void
      {
         this._id = id;
      }
      
      public function get level() : uint
      {
         return this._level;
      }
      
      public function set level(lv:uint) : void
      {
         this._level = lv;
      }
      
      public function get onLine() : Boolean
      {
         return this._online;
      }
      
      public function set onLine(b1:Boolean) : void
      {
         this._online = b1;
      }
      
      public function get status() : uint
      {
         return this._status;
      }
      
      public function set status(sta:uint) : void
      {
         this._status = sta;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(ti:String) : void
      {
         this._title = ti;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function set description(des:String) : void
      {
         this._description = des;
      }
   }
}

