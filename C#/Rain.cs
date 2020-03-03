using System;
namespace Rain{
    class rain{

        public void sleep(int time){ //in ms
            System.Threading.Thread.Sleep(time);
        }
        public void Main(){
            for(;;){
                for(int h=0;h<Console.WindowHeight;h++){
                    for(int w=0;w<Console.WindowWidth;w=w+2){
                        Console.Write(";");
                    }
                }
                sleep(50);
            }
        }
    }
}