Set wshShell = CreateObject("WScript.shell")
wshShell.run "mfgtool2.exe -c ""linux"" -l ""SDCard-Android"" -s ""board=sabreauto"" -s ""folder=sabreauto"" -s ""soc=6q"" -s ""plus=p"" -s ""mmc=2"" -s ""data_type=-f2fs"""
Set wshShell = Nothing
