using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace MatlabGUI
{
    public partial class MatlabGUIForm : Form
    {
        bool finished;
        public MatlabGUIForm()
        {
            InitializeComponent();
            finished = false;
        }

        public string returnUserInput()
        {
            return textBoxUserInput.Text;
        }

        public bool returnFinished()
        {
            return finished;
        }

        private void OK_Click(object sender, EventArgs e)
        {
            finished = true;
        }
    }
}