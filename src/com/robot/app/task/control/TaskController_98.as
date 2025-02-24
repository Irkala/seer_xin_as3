package com.robot.app.task.control
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.mode.AppModel;
   
   public class TaskController_98
   {
      public static const TASK_ID:uint = 98;
      
      private static var panel:AppModel = null;
      
      public function TaskController_98()
      {
         super();
      }
      
      public static function showPanel() : void
      {
         var name:String = "TaskPanel_" + TASK_ID;
         if(panel == null)
         {
            panel = new AppModel(ClientConfig.getTaskModule(name),"正在打开任务信息");
            panel.setup();
         }
         panel.show();
      }
      
      public static function setup() : void
      {
      }
      
      public static function start() : void
      {
      }
      
      public static function destroy() : void
      {
         if(Boolean(panel))
         {
            panel.destroy();
            panel = null;
         }
      }
   }
}

