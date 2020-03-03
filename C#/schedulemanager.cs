using System;

namespace schedulemanager {
    class subjects { //time [time] ; name [day,time] ; teacher [day,time]
        public string[] days = {
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday"
        };
        public string[] time = {
            "8:00 - 8:35",
            "8:35 - 9:10",
            "9:10 - 9:45",
            "9:45 - 10:20",
            "10:20 - 10:55",
            "10:55 - 11:30"
        };
        public string[,] name = {
            {//Monday
                "Geometria A3",
                "Geometria A3",
                "Libre",
                "Fisica II F34",
                "Fisica II F34",
                "Fisica II F34"
            },
            {//Tuesday
                "Libre",
                "Libre",
                "Libre",
                "Geometria B26",
                "Geometria B26",
                "Geometria B26"
            },
            {//Wednesday
                "Calculo III A12",
                "Calculo III A12",
                "Calculo III A12",
                "Libre",
                "Libre",
                "Libre",
            },
            {//Thursday
                "Act. Fi F50",
                "Act. Fi F50",
                "Act. Fi F50",
                "Programacion F57",
                "Programacion F57",
                "Programacion F57"
            },
            { //Friday
                "Fisica II F35",
                "Fisica II F35",
                "Fisica II F35",
                "Calculo III A8",
                "Calculo III A8",
                "Calculo III A8"
            }
        };
        public string[] prof = {
            "Geometria: Edixo Sanchez",
            "Fisica II: Gustavo Urdaneta",
            "Calculo III: Alexis Landaeta",
            "Programacion: Junior Gonzalez",
            "Act. Fi: Jose Villa"
        };
    }
    class manager { 
        static void Main(){
            subjects subs = new subjects();
            for(int a=0;a<5;a++){
                Console.WriteLine("------{0}",subs.days[a]);
                for(int b=0;b<6;b++){
                    Console.WriteLine("+ {0} :: {1}",subs.time[b],subs.name[a,b]);
                }
                Console.WriteLine();
            }
            foreach(string str in subs.prof){
                Console.WriteLine("#Prof. of {0}",str);
            }
            Console.ReadKey();
        }
    }
}