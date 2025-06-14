using System;

namespace Pr5
{
    public class Employee : Person
    {
        public double Salary;
        public double WorkExperience;
        
        public Employee(string name, int age) : this(name, age, 10000.0, 4.0)
        { }
        

        
        public Employee(string name, int age, double salary, double work_experience)
        {
            Name = name;
            Age = age;
            Salary = salary;
            WorkExperience = work_experience;
        }
        
        public void PrintWorker() 
        {
            Console.WriteLine($"Name: {Name}\n Age: {Age}\n Salary: {Salary}\n Work Experience: {WorkExperience}\n"); 
        }
    }
}