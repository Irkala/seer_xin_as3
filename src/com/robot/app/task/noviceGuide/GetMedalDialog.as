package com.robot.app.task.noviceGuide
{
   import com.robot.app.task.taskUtils.manage.TaskUIManage;
   import com.robot.app.task.taskUtils.taskDialog.TaskBaseDialog;
   import flash.display.MovieClip;
   
   public class GetMedalDialog
   {
      private static var sDialog:MovieClip;
      
      public function GetMedalDialog()
      {
         super();
      }
      
      public static function show(str:String = "", fun:Function = null) : void
      {
         sDialog = TaskUIManage.getMovieClip("getMedalDialog",4);
         TaskBaseDialog.dialogMC = sDialog;
         TaskBaseDialog.showAwardDialog(str);
      }
   }
}

