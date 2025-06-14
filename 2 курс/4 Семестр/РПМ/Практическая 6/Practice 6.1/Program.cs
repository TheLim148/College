using Microsoft.Office.Interop.Excel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Practice_6._1
{
    internal class Program
    {
        static void Main(string[] args)
        {
            var XL1 = new Microsoft.Office.Interop.Excel.Application();
            XL1.Visible = true;
            var t = Type.Missing;
            var Book1 = XL1.Workbooks.Add(t);
            var Lists = Book1.Worksheets;
            Worksheet List1 = Lists.Item[1];
            string[] Months = {"January", "February", "March", "April", "May"};
            int[] Sales = {500, 600, 300, 500, 800};
            List1.Range["A1", t].Value2 = "Months";
            List1.Range["B1", t].Value2 = "Sales";
            List1.Range["C1", t].Value2 = "Tax";

            for (int i = 0; i < Months.Length; i++)
            {
                List1.Range[$"A{i + 2}", t].Value2 = Months[i];
                List1.Range[$"B{i + 2}", t].Value2 = Sales[i];
                //List1.Range[$"C{i + 2}", t].Value2 = Sales[i] * 0.18;
                List1.Range[$"C{i + 2}", t].Formula = $"=B{i+2} * 0.18";
            }

            List1.Range["B7", t].Value2 = XL1.WorksheetFunction.Sum(List1.Range["B2:B6"]);

            Chart Graph = XL1.Charts.Add(t, t, t, t);
            Graph.ChartType = XlChartType.xlConeBarClustered;
            Graph.SetSourceData(List1.Range["A1:C6"], t);
            Graph.HasLegend = false;
            Graph.HasTitle = true;
            Graph.ChartTitle.Caption = "Sales for five months";
            //XL1.ActiveChart.Export(@"C:\Users\Student\Desktop\Graph.jpg", t, t);

            //XL1.Quit();
            //XL1 = null;
        }
    }
}
