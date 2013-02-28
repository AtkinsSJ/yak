package{
    public class ShuffleBag{
        private var data:Array=[];
        private var cursor:int;
        public function ShuffleBag(){
            cursor = -1;
        }
        public function size():int {
            return data.length;
        }
        public function add(item:int,quantity:int=1):void{
            for (var i:int = 0; i < quantity;i++){
                data.push(item);
            }
            cursor=data.length-1;
        }
        public function next():int{
            if(cursor<1){
                cursor=data.length-1;
                return data[0];
            }
            var grab:int=Math.floor(Math.random()*(cursor+1));
            var temp:int=data[grab];
            data[grab]=data[cursor];
            data[cursor]=temp;
            cursor--;
            return temp;
        }
    }
}