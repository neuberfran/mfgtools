Set wshShell = CreateObject("WScript.shell")
wshShell.run "mfgtool2.exe -c ""linux"" -l ""eMMC-Brillo"" -s ""6uluboot=iopb"" -s ""6uldtb=iopb"" -s ""folder=iopb"" -s  ""soc=6ul"" -s ""mmc=0"" -s ""data_type="""
Set wshShell = Nothing
