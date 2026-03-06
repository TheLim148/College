using System;

namespace Pr5
{
    public static class Program
    {
        public static void Main(string[] args)
        {
            int stCount = 5;
            int Count = 5;
            Person[] people = new Person[stCount];
            people[0] = new Person();
            people[1] = new Person();
            people[2] = new Person();
            people[3] = new Person();
            people[4] = new Person();

            people[0].Name = "Misha"; people[0].Age = 17;

            people[1].Name = "Oleg"; people[1].Age = 16;

            people[2].Name = "Sasha"; people[2].Age = 20;

            people[3].Name = "Semen"; people[3].Age = 7;

            people[4].Name = "Alex"; people[4].Age = 15;
            
            Student[] students = new Student[stCount];
            students[0] = new Student();
            students[1] = new Student();
            students[2] = new Student();
            students[3] = new Student();
            students[4] = new Student();

            students[0].Name = "Ivan";
            students[0].Age = 36;
            students[0].Group = "4996";
            students[0].AverageMark = 4.2;

            students[1].Name = "Ivan1";
            students[1].Age = 148;
            students[1].Group = "4996";
            students[1].AverageMark = 5.0;

            students[2].Name = "Ivan2";
            students[2].Age = 21;
            students[2].Group = "3996";
            students[2].AverageMark = 3.2;

            students[3].Name = "Ivan3";
            students[3].Age = 26;
            students[3].Group = "2996";
            students[3].AverageMark = 2.2;

            students[4].Name = "Ivan4";
            students[4].Age = 14;
            students[4].Group = "1996";
            students[4].AverageMark = 3.9;

            for (int i = 0; i < Count; i++)
            {
                students[i].PrintInfo();
            }

            for (int j = 0; j < stCount; j++)
            {
                students[j].Print();
            }

            Console.WriteLine("\nAverage Mark > 4.0: ");
            for (int i = 0; i < stCount; i++)
            {
                if (students[i].AverageMark > 4.0) {
                    students[i].PrintInfo();
                }    
            }
            Console.WriteLine("\nAge > 20: ");
            for (int i = 0; i < stCount; i++)
            {
                if (students[i].Age > 20) {
                    students[i].PrintInfo();
                }    
            }

            Employee worker1 = new Employee("Ivan1", 20);
            Employee worker2 = new Employee("Ivan2", 34, 3.0, 4.0);

            worker1.PrintWorker();
            worker2.PrintWorker();
        }
    }
}
