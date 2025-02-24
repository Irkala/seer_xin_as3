package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class TeamPkHistoryInfo
   {
      public var killPlayer:uint;
      
      public var killBuilding:uint;
      
      public var mvpNum:uint;
      
      public var winTimes:uint;
      
      public var lostTimes:uint;
      
      public var drawTimes:uint;
      
      public var point:uint;
      
      private var _week:int;
      
      public function TeamPkHistoryInfo(data:IDataInput)
      {
         super();
         this.killPlayer = data.readUnsignedInt();
         this.killBuilding = data.readUnsignedInt();
         this.mvpNum = data.readUnsignedInt();
         this.winTimes = data.readUnsignedInt();
         this.lostTimes = data.readUnsignedInt();
         this.drawTimes = data.readUnsignedInt();
         this.point = data.readUnsignedInt();
         this._week = data.readInt();
      }
      
      public function get week() : uint
      {
         if(this._week <= 0)
         {
            return 1;
         }
         return this._week;
      }
   }
}

