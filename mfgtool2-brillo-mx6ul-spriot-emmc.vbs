Set wshShell = CreateObject("WScript.shell")
wshShell.run "mfgtool2.exe -c ""linux"" -l ""eMMC-Brillo"" -s ""6uluboot=spriot"" -s ""6uldtb=spriot"" -s ""folder=spriot"" -s  ""soc=6ul"" -s ""mmc=1"" -s ""data_type="""
Set wshShell = Nothing
