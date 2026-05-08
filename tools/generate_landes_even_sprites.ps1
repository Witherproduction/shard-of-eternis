param(
    [string]$SourceDir = "F:\shard of eternis dev\carte\landes du sepulcre",
    [string]$ProjectDir = "F:\shard of eternis dev\shard-of-eternis"
)

$ErrorActionPreference = "Stop"

function New-GuidString {
    return [guid]::NewGuid().ToString()
}

$spritesRoot = Join-Path $ProjectDir "sprites"
$yypPath = Join-Path $ProjectDir "shard of eternis.yyp"

if (-not (Test-Path $SourceDir)) {
    throw "Dossier source introuvable: $SourceDir"
}
if (-not (Test-Path $yypPath)) {
    throw "Fichier projet introuvable: $yypPath"
}

$allPng = Get-ChildItem -Path $SourceDir -Filter "*.png" -File | Sort-Object Name
$selected = @()
for ($i = 0; $i -lt $allPng.Count; $i++) {
    if ((($i + 1) % 2) -eq 0) {
        $selected += $allPng[$i]
    }
}

if ($selected.Count -eq 0) {
    throw "Aucune image paire detectee."
}

$addedEntries = New-Object System.Collections.Generic.List[string]
$selectedSpriteNames = New-Object System.Collections.Generic.List[string]

foreach ($img in $selected) {
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($img.Name)
    $spriteName = "s$baseName"
    $selectedSpriteNames.Add($spriteName)
    $spriteDir = Join-Path $spritesRoot $spriteName
    $spriteYYPath = Join-Path $spriteDir "$spriteName.yy"

    if (Test-Path $spriteYYPath) {
        continue
    }

    New-Item -ItemType Directory -Path $spriteDir -Force | Out-Null

    Add-Type -AssemblyName System.Drawing
    $bitmap = [System.Drawing.Image]::FromFile($img.FullName)
    $width = $bitmap.Width
    $height = $bitmap.Height
    $bitmap.Dispose()

    $frameId = New-GuidString
    $layerId = New-GuidString
    $keyframeId = New-GuidString

    $destPng = Join-Path $spriteDir "$frameId.png"
    Copy-Item -Path $img.FullName -Destination $destPng -Force

    $xorigin = [int]($width / 2)
    $yorigin = [int]($height / 2)
    $bboxRight = [Math]::Max(0, $width - 1)
    $bboxBottom = [Math]::Max(0, $height - 1)

    $yy = @"
{
  "`$GMSprite":"v2",
  "%Name":"$spriteName",
  "bboxMode":0,
  "bbox_bottom":$bboxBottom,
  "bbox_left":0,
  "bbox_right":$bboxRight,
  "bbox_top":0,
  "collisionKind":1,
  "collisionTolerance":0,
  "DynamicTexturePage":false,
  "edgeFiltering":false,
  "For3D":false,
  "frames":[
    {"`$GMSpriteFrame":"v1","%Name":"$frameId","name":"$frameId","resourceType":"GMSpriteFrame","resourceVersion":"2.0",},
  ],
  "gridX":0,
  "gridY":0,
  "height":$height,
  "HTile":false,
  "layers":[
    {"`$GMImageLayer":"","%Name":"$layerId","blendMode":0,"displayName":"default","isLocked":false,"name":"$layerId","opacity":100.0,"resourceType":"GMImageLayer","resourceVersion":"2.0","visible":true,},
  ],
  "name":"$spriteName",
  "nineSlice":null,
  "origin":4,
  "parent":{
    "name":"Monstre",
    "path":"folders/Sprites/collection/Card/Landes du s\u00e9pulcre/Monstre.yy",
  },
  "preMultiplyAlpha":false,
  "resourceType":"GMSprite",
  "resourceVersion":"2.0",
  "sequence":{
    "`$GMSequence":"v1",
    "%Name":"$spriteName",
    "autoRecord":true,
    "backdropHeight":768,
    "backdropImageOpacity":0.5,
    "backdropImagePath":"",
    "backdropWidth":1366,
    "backdropXOffset":0.0,
    "backdropYOffset":0.0,
    "events":{
      "`$KeyframeStore<MessageEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MessageEventKeyframe>",
      "resourceVersion":"2.0",
    },
    "eventStubScript":null,
    "eventToFunction":{},
    "length":1.0,
    "lockOrigin":false,
    "moments":{
      "`$KeyframeStore<MomentsEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MomentsEventKeyframe>",
      "resourceVersion":"2.0",
    },
    "name":"$spriteName",
    "playback":1,
    "playbackSpeed":0.0,
    "playbackSpeedType":0,
    "resourceType":"GMSequence",
    "resourceVersion":"2.0",
    "seqHeight":$height.0,
    "seqWidth":$width.0,
    "showBackdrop":true,
    "showBackdropImage":false,
    "timeUnits":1,
    "tracks":[
      {"`$GMSpriteFramesTrack":"","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"`$KeyframeStore<SpriteFrameKeyframe>":"","Keyframes":[
            {"`$Keyframe<SpriteFrameKeyframe>":"","Channels":{
                "0":{"`$SpriteFrameKeyframe":"","Id":{"name":"$frameId","path":"sprites/$spriteName/$spriteName.yy",},"resourceType":"SpriteFrameKeyframe","resourceVersion":"2.0",},
              },"Disabled":false,"id":"$keyframeId","IsCreationKey":false,"Key":0.0,"Length":1.0,"resourceType":"Keyframe<SpriteFrameKeyframe>","resourceVersion":"2.0","Stretch":false,},
          ],"resourceType":"KeyframeStore<SpriteFrameKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"frames","resourceType":"GMSpriteFramesTrack","resourceVersion":"2.0","spriteId":null,"trackColour":0,"tracks":[],"traits":0,},
    ],
    "visibleRange":null,
    "volume":1.0,
    "xorigin":$xorigin,
    "yorigin":$yorigin,
  },
  "swatchColours":null,
  "swfPrecision":0.5,
  "textureGroupId":{
    "name":"Default",
    "path":"texturegroups/Default",
  },
  "type":0,
  "VTile":false,
  "width":$width,
}
"@

    [System.IO.File]::WriteAllText($spriteYYPath, $yy, [System.Text.Encoding]::UTF8)
}

if ($selectedSpriteNames.Count -gt 0) {
    $yyp = [System.IO.File]::ReadAllText($yypPath, [System.Text.Encoding]::UTF8)
    foreach ($spriteName in $selectedSpriteNames) {
        if ($yyp -notmatch [regex]::Escape("""name"":""$spriteName""")) {
            $addedEntries.Add("    {`"id`":{`"name`":`"$spriteName`",`"path`":`"sprites/$spriteName/$spriteName.yy`",},},")
        }
    }
}

if ($addedEntries.Count -gt 0) {
    $marker = "`n  `"resourceType`":`"GMProject`""
    $insert = ($addedEntries -join "`r`n") + "`r`n"
    $idx = $yyp.IndexOf($marker)
    if ($idx -lt 0) {
        throw "Impossible de trouver la fin de la section resources dans le yyp."
    }
    $yyp = $yyp.Insert($idx, $insert)
    [System.IO.File]::WriteAllText($yypPath, $yyp, [System.Text.Encoding]::UTF8)
}

Write-Output "Sprites crees: $($addedEntries.Count)"
