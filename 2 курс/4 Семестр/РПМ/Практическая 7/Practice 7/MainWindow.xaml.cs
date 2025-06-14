using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Practice_7
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        bool colorFlag = true;
        System.Windows.Media.Brush color;
        public MainWindow()
        {
            InitializeComponent();
            Btn1.Click += new RoutedEventHandler(Btn1_Click);
            Btn2.Click += new RoutedEventHandler(Btn2_Click);
            color = this.Windows.Background;
        }

        void Btn1_Click(object sender, RoutedEventArgs e)
        {
            if (colorFlag)
            {
                this.Windows.Background = System.Windows.Media.Brushes.Purple;
            }
            else
            {
                this.Windows.Background = color;
            }
            colorFlag = !colorFlag;
        }

        void Btn2_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }
    }
}
