#Requires -Version 5.1
<#
.SYNOPSIS
    프로젝트 전체에서 이미지 파일의 대문자 확장자를 찾아 소문자로 변경합니다.
    (사용처 검색 및 수정 기능은 현재 주석 처리됨)

.DESCRIPTION
    1. 프로젝트 루트부터 모든 하위 디렉토리를 재귀적으로 탐색합니다.
    2. 불필요한 디렉토리(.git, target 등)는 검색에서 제외합니다.
    3. 확장자가 대문자인 이미지 파일을 찾아 `git mv`로 소문자로 변경합니다.
    4. 변경된 파일 목록을 출력합니다.

.USAGE
    1. PowerShell 7 이상 또는 Windows PowerShell 5.1 환경을 준비합니다.
    2. 프로젝트 루트에서 PowerShell을 엽니다.
    3. 처음 실행 시: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process` 입력
    4. 스크립트 실행: `.\update-image-references.ps1`
#>

# --- 설정 (사용자 환경에 맞게 수정) ---

# 1. 검색에서 제외할 디렉토리 및 파일 패턴
#    프로젝트 전체 검색 시 성능 저하 및 오류를 방지하기 위해 필수적입니다.
$excludePatterns = @(
    ".git*",
    "node_modules*",
    "target*",
    "build*",
    "out*",
    ".idea*",
    ".vscode*",
    "*.jar",
    "*.class",
    # 스크립트 자기 자신은 제외
    "update-image-references.ps1"
)

# 2. 대상 이미지 확장자 (소문자로)
$imageExtensions = @(
    "*.png", "*.jpg", "*.jpeg", "*.gif", "*.svg", "*.webp", "*.bmp", "*.tiff", "*.ico"
)

# --- 스크립트 시작 ---

# Git 명령어 존재 여부 확인
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "오류: 'git' 명령어를 찾을 수 없습니다. Git이 설치되어 있고 Path에 등록되어 있는지 확인하세요." -ForegroundColor Red
    exit 1
}

Write-Host "🚀 이미지 확장자 변경 스크립트를 시작합니다. (대상: 프로젝트 전체)" -ForegroundColor Cyan
Write-Host "----------------------------------------------------"

# 1단계: 대문자 확장자 이미지 파일 찾기 및 이름 변경
Write-Host "[1단계] 대문자 확장자를 가진 이미지 파일을 검색하고 이름을 변경합니다..." -ForegroundColor Yellow

$renamedFilesLog = @()

# 프로젝트 루트(.)부터 모든 하위 디렉토리를 재귀적으로 검색 (-Recurse)
# 단, 제외 패턴(-Exclude)에 해당하는 항목은 건너뜀
Get-ChildItem -Path . -Include $imageExtensions -Recurse -Exclude $excludePatterns -File -ErrorAction SilentlyContinue | ForEach-Object {
    $file = $_
    $lowercaseExtension = $file.Extension.ToLower()

    # 확장자가 이미 소문자인 경우 건너뛰기 (대소문자 구분 비교: -cne)
    if ($file.Extension -cne $lowercaseExtension) {
        $oldPath = $file.FullName
        $newPath = Join-Path -Path $file.DirectoryName -ChildPath ($file.BaseName + $lowercaseExtension)

        Write-Host "  - 이름 변경 시도: $($file.Name) (경로: $($file.Directory.FullName))"
        try {
            # git mv를 사용하여 파일 이름 변경 및 Git 추적
            git mv $oldPath $newPath
            $renamedFilesLog += [PSCustomObject]@{
                OldName = $file.Name
                NewName = (Get-Item $newPath).Name
                OldPath = $oldPath
                NewPath = $newPath
            }
        } catch {
            Write-Host "  - 오류: 'git mv' 실행 실패. 파일: $oldPath" -ForegroundColor Red
        }
    }
}


if ($renamedFilesLog.Count -eq 0) {
    Write-Host "`n✅ 발견된 대문자 확장자 파일이 없습니다. 모든 작업이 완료되었습니다." -ForegroundColor Green
    exit
}

Write-Host "`n✅ 총 $($renamedFilesLog.Count)개의 파일 이름이 변경되었습니다." -ForegroundColor Green
$renamedFilesLog | ForEach-Object {
    Write-Host "  - $($_.OldName) -> $($_.NewName)"
}
Write-Host "----------------------------------------------------"
Write-Host "🎉 파일명 변경 작업이 완료되었습니다." -ForegroundColor Cyan
Write-Host "   'git status'로 확인 후 'git commit'을 진행하세요."

# <#
# --- 2/3단계 주석 처리 시작 ---
# (이 부분은 사용처 검색 및 코드 수정을 위한 로직으로, 현재는 비활성화되어 있습니다.)
# ... (이전과 동일한 코드) ...
# --- 2/3단계 주석 처리 끝 ---
# #>