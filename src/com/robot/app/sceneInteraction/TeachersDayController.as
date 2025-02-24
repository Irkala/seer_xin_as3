package com.robot.app.sceneInteraction
{
   import com.robot.core.CommandID;
   import com.robot.core.event.MapEvent;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.net.SocketConnection;
   import org.taomee.events.SocketEvent;
   
   public class TeachersDayController
   {
      public static var isPosComplete:Boolean;
      
      public function TeachersDayController()
      {
         super();
      }
      
      public static function setup() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchComplete);
      }
      
      private static function onMapSwitchComplete(e:MapEvent) : void
      {
         if(MapManager.prevMapID == 301)
         {
            if(MapManager.getMapController().newMapID != 301)
            {
               isPosComplete = false;
               MapManager.removeEventListener(MapEvent.MAP_SWITCH_COMPLETE,onMapSwitchComplete);
               SocketConnection.removeCmdListener(CommandID.FIGHT_OVER,onFightOver);
            }
         }
      }
      
      private static function onFightOver(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.FIGHT_OVER,onFightOver);
         var info:FightOverInfo = e.data as FightOverInfo;
         if(info.winnerID == MainManager.actorID)
         {
            TasksManager.setTaskStatus(21,TasksManager.COMPLETE);
         }
      }
      
      public static function starFig() : void
      {
         SocketConnection.addCmdListener(CommandID.FIGHT_OVER,onFightOver);
      }
   }
}

