package com.robot.app.task.publicizeenvoy
{
   public class PublicizeEnvoyController
   {
      private static var publicizeEnvoyPanle:PublicizeEnvoyPanel;
      
      public function PublicizeEnvoyController()
      {
         super();
      }
      
      public static function show(b:Boolean = false) : void
      {
         if(!publicizeEnvoyPanle)
         {
            publicizeEnvoyPanle = new PublicizeEnvoyPanel();
         }
         publicizeEnvoyPanle.show(b);
      }
   }
}

