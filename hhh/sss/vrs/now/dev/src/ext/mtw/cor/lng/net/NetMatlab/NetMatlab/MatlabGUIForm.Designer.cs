namespace MatlabGUI
{
    partial class MatlabGUIForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.textBoxUserInput = new System.Windows.Forms.TextBox();
            this.OK = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // textBoxUserInput
            // 
            this.textBoxUserInput.Location = new System.Drawing.Point(31, 24);
            this.textBoxUserInput.Name = "textBoxUserInput";
            this.textBoxUserInput.Size = new System.Drawing.Size(151, 20);
            this.textBoxUserInput.TabIndex = 0;
            // 
            // OK
            // 
            this.OK.Location = new System.Drawing.Point(191, 24);
            this.OK.Name = "OK";
            this.OK.Size = new System.Drawing.Size(42, 19);
            this.OK.TabIndex = 1;
            this.OK.Text = "OK";
            this.OK.UseVisualStyleBackColor = true;
            this.OK.Click += new System.EventHandler(this.OK_Click);
            // 
            // MatlabGUIForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(245, 79);
            this.Controls.Add(this.OK);
            this.Controls.Add(this.textBoxUserInput);
            this.Name = "MatlabGUIForm";
            this.Text = "Matlab GUI Form";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox textBoxUserInput;
        private System.Windows.Forms.Button OK;
    }
}