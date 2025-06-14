using System.Windows;
using System.Windows.Media;

namespace WpfApp9
{
    public partial class MainWindow : Window
    {
        private Brush color;
        private bool colorFlag = true;

        public MainWindow()
        {
            InitializeComponent();
            Btn1.Click += new RoutedEventHandler(Btn1_Click);
            Btn2.Click += new RoutedEventHandler(Btn2_Click);
            color = this.Window.Background;
        }
        private void Btn1_Click(object sender, RoutedEventArgs e)
        {
            if (colorFlag)
            {
                this.Background = System.Windows.Media.Brushes.Purple;
            }
            else
            {
                this.Background = color;
            }
            colorFlag = !colorFlag;
        }
        private void Btn2_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}