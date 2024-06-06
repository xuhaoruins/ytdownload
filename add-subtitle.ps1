# 定义一个递归函数来遍历目录
function Traverse-Directories {
    param (
        [string]$path
    )

    # 获取子目录
    $subDirectories = Get-ChildItem -Path $path -Directory

    # 如果没有子目录，则执行命令
    if ($subDirectories.Count -eq 0) {
        Write-Host "Executing command in: $path"

        # 检查视频和字幕文件是否存在
        $videoFile = Join-Path $path "TranslatedVideo.mp4"
        $subtitleFile = Join-Path $path "TranslatedSubtitle.vtt"
        #$outputFile = Join-Path $path "output.mp4"
        # 获取父级的父级目录的名字，并将其作为 outputFile 的名字
        $parentDirPath = Split-Path $path
        $grandParentDirName = Split-Path $parentDirPath -Leaf

        # 将 outputFile 保存到 $startingPath 路径下
        $outputFile = Join-Path $startingPath "$grandParentDirName.mp4"

        if ((Test-Path $videoFile) -and (Test-Path $subtitleFile)) {
            # 执行 ffmpeg 命令
            ffmpeg -i $videoFile -i $subtitleFile -c copy -c:s mov_text $outputFile
            Write-Host "Command executed successfully in: $path"
        } else {
            Write-Host "Video or subtitle file not found in: $path"
        }
    } else {
        # 递归遍历每个子目录
        foreach ($dir in $subDirectories) {
            Traverse-Directories -path $dir.FullName
        }
    }
}

# 调用函数并传入起始目录路径
$startingPath = "C:\Users\haxu\Desktop\AI Day\booth"
Traverse-Directories -path $startingPath
