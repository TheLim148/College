using System;

namespace Pr5
{
    public class Student : Person
    {
        public string Group = "0000";
        public double AverageMark;
        /*
        public Student(string name, int age) : this(name, age, "0901", 4.5)
        { }
        */

        /*
        public Student(string name, int age, string group, double averageMark)
        {
            Name = name;
            Age = age;
            Group = group;
            AverageMark = averageMark;
        }
        */
        public void PrintInfo()
        {
            Console.WriteLine("Student: ");
            Console.WriteLine($"Name: {Name}\n Age: {Age}\n Group: {Group}\n Average Mark: {AverageMark}\n");
        }
    }
}

