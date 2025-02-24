package com.robot.app.task.tc
{
   import com.robot.app.task.control.TaskController_97;
   import com.robot.app.task.control.TasksController;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.Alarm;
   
   public class TaskClass_97
   {
      public function TaskClass_97(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(97,TasksManager.COMPLETE);
         TaskController_97.destroy();
         MainManager.actorInfo.coins += 1000;
         Alarm.show("<font color=\'#ff0000\'>1000积累经验</font>已经存入你的经验分配器中。",function():void
         {
            Alarm.show("<font color=\'#ff0000\'>" + 1000 + "赛尔豆" + "</font>已放入了你的储存箱。",function():void
            {
               TasksController.taskCompleteUI();
            });
         });
      }
   }
}

