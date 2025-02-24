package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.Alarm;
   
   public class TaskClass_405
   {
      public function TaskClass_405(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(405,TasksManager.COMPLETE);
         var cn:uint = uint(info.monBallList[0].itemCnt);
         Alarm.show("    你和比比鼠可真是功不可没呢！为我们的赛尔号航行能源补充了不少噢。<font color=\'#ff0000\'>" + cn + "积累经验</font>已经存入你的经验分配器中。快回基地看看吧！");
      }
   }
}

