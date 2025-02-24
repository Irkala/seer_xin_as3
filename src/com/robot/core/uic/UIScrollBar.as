package com.robot.core.uic
{
   import flash.display.InteractiveObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class UIScrollBar extends EventDispatcher
   {
      private var _barBack:Sprite;
      
      private var _barBlock:Sprite;
      
      private var _upBtn:SimpleButton;
      
      private var _downBtn:SimpleButton;
      
      private var _scrollRect:Rectangle;
      
      private var _maxCount:int;
      
      private var _per:Number = 0;
      
      private var _index:int = 0;
      
      private var _totalLength:int = 0;
      
      private var _lineNum:uint = 1;
      
      private var _wheelObject:InteractiveObject;
      
      private var _scrollY:Number = 3;
      
      private var _upNum:Number = 0;
      
      private var _downNum:Number = 0;
      
      public function UIScrollBar(barBlock:Sprite, barBack:Sprite, maxCount:int, upBtn:SimpleButton = null, downBtn:SimpleButton = null)
      {
         super();
         this._barBlock = barBlock;
         this._barBack = barBack;
         this._maxCount = maxCount;
         this._upBtn = upBtn;
         this._downBtn = downBtn;
         if(Boolean(this._upBtn))
         {
            this._upNum = this._upBtn.height;
            this._upBtn.x = this._barBack.x;
            this._upBtn.y = this._barBack.y;
            this._upBtn.mouseEnabled = false;
         }
         if(Boolean(this._downBtn))
         {
            this._downNum = this._downBtn.height;
            this._downBtn.x = this._barBack.x;
            this._downBtn.y = this._barBack.y + this._barBack.height - this._downBtn.height;
            this._downBtn.mouseEnabled = false;
         }
         this._barBlock.buttonMode = true;
         this._barBlock.mouseEnabled = false;
         this.upDateScroll();
         this._barBlock.x = this._scrollRect.x;
         this._barBlock.y = this._scrollRect.y;
         this._barBlock.visible = false;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function get lineNum() : int
      {
         return this._lineNum;
      }
      
      public function set lineNum(i:int) : void
      {
         this._lineNum = i;
      }
      
      public function set index(v:int) : void
      {
         if(v < 0 || v > this._totalLength)
         {
            return;
         }
         this._index = v;
         this._barBlock.y = this._index * this._per + this._scrollRect.y;
         dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
      }
      
      public function set totalLength(len:int) : void
      {
         this._totalLength = len;
         this._barBlock.y = this._scrollRect.y;
         this._index = 0;
         if(len > this._maxCount)
         {
            this._barBlock.mouseEnabled = true;
            this._barBlock.visible = true;
            this._per = this._scrollRect.height / (len - this._maxCount);
            trace("拖动的比例\t " + this._per);
            this._barBlock.addEventListener(MouseEvent.MOUSE_DOWN,this.onBarBlockDown);
            this._barBack.addEventListener(MouseEvent.MOUSE_DOWN,this.onBackDown);
            if(Boolean(this._wheelObject))
            {
               this._wheelObject.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
            }
            if(Boolean(this._upBtn))
            {
               this._upBtn.mouseEnabled = true;
               this._upBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onUpDown);
            }
            if(Boolean(this._downBtn))
            {
               this._downBtn.mouseEnabled = true;
               this._downBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onDownDown);
            }
         }
         else
         {
            this._barBlock.mouseEnabled = false;
            this._barBlock.visible = false;
            this._barBlock.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBarBlockDown);
            this._barBack.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBackDown);
            if(Boolean(this._wheelObject))
            {
               this._wheelObject.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
            }
            if(Boolean(this._upBtn))
            {
               this._upBtn.mouseEnabled = false;
               this._upBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onUpDown);
               if(Boolean(this._upBtn.stage))
               {
                  this._upBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpUp);
               }
            }
            if(Boolean(this._downBtn))
            {
               this._downBtn.mouseEnabled = false;
               this._downBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDownDown);
               if(Boolean(this._downBtn.stage))
               {
                  this._downBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDownUp);
               }
            }
         }
      }
      
      public function set wheelObject(o:InteractiveObject) : void
      {
         this._wheelObject = o;
         if(this._barBlock.mouseEnabled)
         {
            this._wheelObject.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
         }
      }
      
      public function get wheelObject() : InteractiveObject
      {
         return this._wheelObject;
      }
      
      public function destroy() : void
      {
         this._barBlock.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBarBlockDown);
         this._barBack.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBackDown);
         if(Boolean(this._wheelObject))
         {
            this._wheelObject.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
            this._wheelObject = null;
         }
         if(Boolean(this._upBtn))
         {
            this._upBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onUpDown);
            if(Boolean(this._upBtn.stage))
            {
               this._upBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpUp);
            }
            this._upBtn = null;
         }
         if(Boolean(this._downBtn))
         {
            this._downBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDownDown);
            if(Boolean(this._downBtn.stage))
            {
               this._downBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDownUp);
            }
            this._downBtn = null;
         }
         this._barBlock = null;
         this._barBack = null;
         this._scrollRect = null;
      }
      
      private function upDateScroll() : void
      {
         this._scrollRect = new Rectangle(this._barBack.x - (this._barBlock.width - this._barBack.width) / 2,this._barBack.y + this._upNum,0,this._barBack.height - this._barBlock.height - this._upNum - this._downNum);
      }
      
      private function onBarBlockDown(e:MouseEvent) : void
      {
         this._barBlock.startDrag(false,this._scrollRect);
         this._barBlock.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onBarBlockMove);
         this._barBlock.stage.addEventListener(MouseEvent.MOUSE_UP,this.onBarBlockUp);
         this._barBlock.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBarBlockDown);
      }
      
      private function onBarBlockMove(e:MouseEvent) : void
      {
         if(this._barBlock.y < this._scrollRect.y)
         {
            this._barBlock.y = this._scrollRect.y;
         }
         if(this._barBlock.y > this._scrollRect.bottom)
         {
            this._barBlock.y = this._scrollRect.bottom;
         }
         var index:int = Math.round((this._barBlock.y - this._scrollRect.y) / this._per);
         if(index < 0)
         {
            index = 0;
         }
         if(Math.ceil(index / this._lineNum) != this._index)
         {
            this._index = Math.ceil(index / this.lineNum);
            dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
         }
      }
      
      private function onBarBlockUp(e:MouseEvent) : void
      {
         this._barBlock.stopDrag();
         this._barBlock.addEventListener(MouseEvent.MOUSE_DOWN,this.onBarBlockDown);
         this._barBlock.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onBarBlockMove);
         this._barBlock.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onBarBlockUp);
      }
      
      private function onBackDown(e:MouseEvent) : void
      {
         this._barBlock.y = (this._barBack.parent.mouseY - this._scrollRect.y) / (this._scrollRect.height + this._barBlock.height) * this._scrollRect.height + this._scrollRect.y;
         this.onBarBlockMove(null);
      }
      
      private function onWheel(e:MouseEvent) : void
      {
         if(this._barBlock.y >= this._scrollRect.y && this._barBlock.y <= this._scrollRect.bottom)
         {
            this._barBlock.y -= e.delta;
            this.onBarBlockMove(null);
         }
      }
      
      private function onUpDown(e:MouseEvent) : void
      {
         this._upBtn.addEventListener(Event.ENTER_FRAME,this.onUpEnter);
         if(Boolean(this._upBtn.stage))
         {
            this._upBtn.stage.addEventListener(MouseEvent.MOUSE_UP,this.onUpUp);
         }
      }
      
      private function onUpUp(e:MouseEvent) : void
      {
         if(Boolean(this._upBtn.stage))
         {
            this._upBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpUp);
         }
         this._upBtn.removeEventListener(Event.ENTER_FRAME,this.onUpEnter);
      }
      
      private function onUpEnter(e:Event) : void
      {
         if(this._barBlock.y >= this._scrollRect.y)
         {
            this._barBlock.y -= this._scrollY;
            this.onBarBlockMove(null);
         }
         else
         {
            this._barBlock.y = this._scrollRect.y;
            this._upBtn.removeEventListener(Event.ENTER_FRAME,this.onUpEnter);
         }
      }
      
      private function onDownDown(e:MouseEvent) : void
      {
         this._downBtn.addEventListener(Event.ENTER_FRAME,this.onDownEnter);
         if(Boolean(this._downBtn.stage))
         {
            this._downBtn.stage.addEventListener(MouseEvent.MOUSE_UP,this.onDownUp);
         }
      }
      
      private function onDownUp(e:MouseEvent) : void
      {
         if(Boolean(this._downBtn.stage))
         {
            this._downBtn.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDownUp);
         }
         this._downBtn.removeEventListener(Event.ENTER_FRAME,this.onDownEnter);
      }
      
      private function onDownEnter(e:Event) : void
      {
         if(this._barBlock.y <= this._scrollRect.bottom)
         {
            this._barBlock.y += this._scrollY;
            this.onBarBlockMove(null);
         }
         else
         {
            this._barBlock.y = this._scrollRect.bottom;
            this._downBtn.removeEventListener(Event.ENTER_FRAME,this.onDownEnter);
         }
      }
      
      public function set scrollY(len:Number) : void
      {
         this._scrollY = len;
      }
      
      public function get scrollY() : Number
      {
         return this._scrollY;
      }
      
      public function get per() : Number
      {
         return this._per;
      }
      
      public function get scrollHeight() : Number
      {
         return this._scrollRect.height;
      }
   }
}

