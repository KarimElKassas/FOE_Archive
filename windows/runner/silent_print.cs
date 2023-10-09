using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

namespace SilentPrint
{
    public class PrintHandler
    {
        public static void PrintFile(string filePath)
        {
            try
            {
                var process = new Process();
                var startInfo = new ProcessStartInfo
                {
                    CreateNoWindow = true,
                    Verb = "print",
                    FileName = filePath
                };
                process.StartInfo = startInfo;
                process.Start();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Printing failed: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}