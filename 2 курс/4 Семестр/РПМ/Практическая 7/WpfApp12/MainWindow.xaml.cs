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

namespace WpfApp12
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        void bg_color_1(object sender, RoutedEventArgs e)
        {
            this.Window.Background = System.Windows.Media.Brushes.Red;
        }

        void bg_color_2(object sender, RoutedEventArgs e)
        {
            this.Window.Background = System.Windows.Media.Brushes.Blue;
        }

        void bg_color_3(object sender, RoutedEventArgs e)
        {
            this.Window.Background = System.Windows.Media.Brushes.Cyan;
        }

        void dev_info(object sender, RoutedEventArgs e)
        {
            MessageBox.Show("Developer: Ryzhov Kostya 3992\nAll rights reserved");
        }

        void Close(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        void bg_color_1_hover(object sender, RoutedEventArgs e)
        {
            statusBar.Text = "Change background to 1";
        }

        void bg_color_2_hover(object sender, RoutedEventArgs e)
        {
            statusBar.Text = "Change background to 2";
        }

        void bg_color_3_hover(object sender, RoutedEventArgs e)
        {
            statusBar.Text = "Change background to 3";
        }

        void dev_info_hover(object sender, RoutedEventArgs e)
        {
            statusBar.Text = "Show developer information";
        }

        void Close_hover(object sender, RoutedEventArgs e)
        {
            statusBar.Text = "Close";
        }

        void default_hover(object sender, RoutedEventArgs e)
        {
            statusBar.Text = "Status bar";
        }
    }
}
