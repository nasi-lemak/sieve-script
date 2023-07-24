param (
    [string]$sourceFolder,
    [string]$ignoreText = ""
)

if (-not (Test-Path $sourceFolder)) {
    Write-Host "Source folder not found: $sourceFolder"
    exit 1
}

$outputFile = "output_$((Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')).txt"

# Remove milliseconds from the timestamp in $Time
$timeWithoutMilliseconds = Get-Date -Format "HH:mm:ss"

# Replace colons in the timestamp with hyphens to make it suitable for a filename
$outputFile = $outputFile -replace ":", "-"
$outputFile = $outputFile -replace " ", ""

# Delete the output file if it already exists
if (Test-Path $outputFile) {
    Remove-Item $outputFile
}

# Loop through each file in the source folder
$files = Get-ChildItem "$sourceFolder\*.cs"
foreach ($file in $files) {
    Write-Host "Processing file: $($file.Name)"

    # Read the content of the file and search for variable declarations
    $content = Get-Content $file.FullName
    # If ignoreText is provided, construct the custom regex pattern; otherwise, use the default pattern
    if ($ignoreText -ne "") {
        $regex = "public (?!$ignoreText)(?:[A-z]+)\??\s([A-z]+)\s\{\sget;\sset;\s\}"
    }
    else {
        $regex = "public (?:[A-z]+)\?*\s([A-z]+)\s\{\sget;\sset;\s\}"
    }
    $matches = [Regex]::Matches($content, $regex)

    # Append additional text including the captured variable name to each variable declaration and write to the output file
    foreach ($match in $matches) {
        $variableName = $match.Groups[1].Value
		$camelCaseVariableName = $variableName.Substring(0,1).Tolower() + $variableName.Substring(1,$variableName.Length-1) 
        $outputText = "mapper.Property<$($file.BaseName)>(p.$variableName).CanSort().CanFilter().HasName(`"$camelCaseVariableName`");`r`n"
        Add-Content -Path $outputFile -Value $outputText
    }
}

Write-Host "All files have been processed, and variable declarations with additional text are saved to $outputFile"
