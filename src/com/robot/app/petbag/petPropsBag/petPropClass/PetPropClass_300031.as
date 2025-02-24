package com.robot.app.petbag.petPropsBag.petPropClass
{
   import com.robot.app.petbag.PetPropInfo;
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   
   public class PetPropClass_300031
   {
      public function PetPropClass_300031(info:PetPropInfo)
      {
         super();
         SocketConnection.send(CommandID.EAT_SPECIAL_MEDICINE,info.petInfo.catchTime,info.itemId);
      }
   }
}

