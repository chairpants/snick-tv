# packs captions/*.vtt into captions.js — file:// pages can't load .vtt tracks
# directly (same reason the TV model ships as magnavox.glb.js). rerun after
# adding or editing any .vtt; over http the captions/ folder works as-is.
#
# a handful of broadcasts share one archive.org item (see EPISODES/epKey in
# tv3d-lite.html), so caption_factory.py names their .vtt files by a filename
# hash (Windows forbids ':' in filenames) instead of the true id::filename key
# the player looks up. translate those back here, same mapping caption_factory
# .py's own rebuild_js() uses — keep in sync if the bundled episode list changes.
$fsKeyToEpKey = @{
  'snick-1993-05-22-woc-archiver-sketch-the-cow__9c0ea11a' = 'snick-1993-05-22-woc-archiver-sketch-the-cow::SNICK (1993-05-15) WOC {Archiver mushbrain}.mp4'
  'snick-1993-05-22-woc-archiver-sketch-the-cow__c915dde8' = 'snick-1993-05-22-woc-archiver-sketch-the-cow::SNICK (1993-05-22) WOC {Archiver Sketch the Cow}.mp4'
  'snick-1993-05-22-woc-archiver-sketch-the-cow__36b57a5e' = 'snick-1993-05-22-woc-archiver-sketch-the-cow::SNICK (1993-05-29) Clarissa, Roundhouse, Ren & Stimpy, AYAOTD {Archiver ACarchives}.mp4'
  'snick-1993-05-22-woc-archiver-sketch-the-cow__30f3e6b5' = 'snick-1993-05-22-woc-archiver-sketch-the-cow::SNICK (1993-06-19) WOC {Archived by mushbrain}.mp4'
  'snick-1993-05-22-woc-archiver-sketch-the-cow__305c612d' = 'snick-1993-05-22-woc-archiver-sketch-the-cow::SNICK (1993-06-26) {Archiver mushbrain} (WOC).mp4'
  'snick-1993-05-22-woc-archiver-sketch-the-cow__0af028de' = 'snick-1993-05-22-woc-archiver-sketch-the-cow::SNICK (1993-07-03) WOC {Archiver mushbrain}.mp4'
  'snick-1993-05-22-woc-archiver-sketch-the-cow__0e4e965c' = 'snick-1993-05-22-woc-archiver-sketch-the-cow::SNICK (1993-07-10) WOC {Archiver musbrain}.mp4'
}
$m = @{}
Get-ChildItem "$PSScriptRoot\captions\*.vtt" | ForEach-Object {
  $key = if ($fsKeyToEpKey.ContainsKey($_.BaseName)) { $fsKeyToEpKey[$_.BaseName] } else { $_.BaseName }
  $m[$key] = (Get-Content $_ -Raw)
}
"window.CAPTIONS = " + ($m | ConvertTo-Json -Compress) + ";" | Set-Content -Encoding utf8 "$PSScriptRoot\captions.js"
Write-Host "captions.js: $($m.Count) episode(s)"
