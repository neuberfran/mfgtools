Set wshShell = CreateObject("WScript.shell")
wshShell.run "mfgtool2.exe -c ""linux"" -l ""eMMC-Brillo-uboot-fuse"" -s ""7duboot=multa"" -s ""7ddtb=multa"" -s ""folder=multa_imx7d"" -s ""soc=7d"" -s ""mmc=2"" -s ""data_type="""
Set wshShell = Nothing

