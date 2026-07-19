# packs captions/*.vtt into captions.js — file:// pages can't load .vtt tracks
# directly (same reason the TV model ships as magnavox.glb.js). rerun after
# adding or editing any .vtt; over http the captions/ folder works as-is.
$m = @{}
Get-ChildItem "$PSScriptRoot\captions\*.vtt" | ForEach-Object { $m[$_.BaseName] = (Get-Content $_ -Raw) }
"window.CAPTIONS = " + ($m | ConvertTo-Json -Compress) + ";" | Set-Content -Encoding utf8 "$PSScriptRoot\captions.js"
Write-Host "captions.js: $($m.Count) episode(s)"
