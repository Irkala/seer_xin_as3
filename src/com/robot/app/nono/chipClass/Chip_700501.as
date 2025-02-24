package com.robot.app.nono.chipClass
{
   import com.robot.core.CommandID;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.net.SocketConnection;
   
   public class Chip_700501
   {
      public function Chip_700501(info:SingleItemInfo)
      {
         super();
         SocketConnection.send(CommandID.NONO_PLAY,info.itemID);
      }
   }
}

