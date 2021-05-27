Set wshShell = CreateObject("WScript.shell")
wshShell.run "mfgtool2.exe -c ""linux"" -l ""eMMC-Brillo"" -s ""7duboot=pico"" -s ""7ddtb=sdb"" -s ""folder=pico_imx7d"" -s ""soc=7d"" -s ""mmc=2"" -s ""data_type="""
Set wshShell = Nothing

