Set wshShell = CreateObject("WScript.shell")
wshShell.run "mfgtool2.exe -c ""linux"" -l ""eMMC-Brillo"" -s ""6uluboot=pico"" -s ""6uldtb=picosom-hobbit"" -s ""folder=pico"" -s  ""soc=6ul"" -s ""mmc=0"" -s ""data_type="""
Set wshShell = Nothing
