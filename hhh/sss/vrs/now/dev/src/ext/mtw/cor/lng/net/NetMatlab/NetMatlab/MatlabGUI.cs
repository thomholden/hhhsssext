using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;

namespace MatlabGUI
{
    public interface FormControlSignature
    {
        string ReturnInput();
        void showGUI();
        void closeGUI();
        bool ReturnFinished();
    }

    [ClassInterface(ClassInterfaceType.AutoDual)]
    public class FormControlClass : FormControlSignature
    {
        MatlabGUIForm Form1Obj = new MatlabGUIForm();
        public string ReturnInput()
        {
            return Form1Obj.returnUserInput();
        }

        public bool ReturnFinished()
        {
            return Form1Obj.returnFinished();
        }

        public void showGUI()
        {
            Form1Obj.Show();
        }

        public void closeGUI()
        {
            Form1Obj.Close();
        }
    }
}

