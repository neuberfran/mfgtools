Set wshShell = CreateObject("WScript.shell")
wshShell.run "mfgtool2.exe -c ""linux"" -l ""eMMC-Brillo-6dl"" -s ""6dluboot=pico"" -s ""6dldtb=pico"" -s ""folder=pico_imx6dl"" -s ""soc=6dl"" -s ""mmc=2"" -s ""data_type="""
Set wshShell = Nothing
