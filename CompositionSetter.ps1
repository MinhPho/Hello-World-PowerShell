# Arg parse
param (
    [string]$CsvFilePath = ".\Sample.csv",
    [string]$SkuStringToCompare = "22W10001",
    [string]$NewCompositionValue = "Pig"
)

Write-Host "This script will replace Composition value of all SKU that contains $SkuStringToCompare with Composition value $NewCompositionValue"

# Csv file parser
Write-Host "Reading CSV input file from $CsvFilePath"
$Csv = Import-Csv $CsvFilePath

# Keep a counter for keeping track of line change in actual CSV file
# Starting from 2 since Row 1 is meant for Properties
$Counter = 2

# Build up content of the new CSV file
$NewData =
ForEach($Row in $Csv){
    $SKU = $Row.SKU
    $Composition = $Row.Composition

    if ($SKU.Contains($SkuStringToCompare)){
        #Some magic to highlight $SKU without having to regex :P
        Write-Host "Row number $Counter SKU=" -NoNewline 
        Write-Host "$SKU " -NoNewline -ForegroundColor Red
        Write-Host "contains string $SkuStringToCompare"

        Write-Host "Proceed to replace existing Composition=" -NoNewline
        Write-Host "$Composition " -NoNewline -ForegroundColor Red
        Write-Host "with value " -NoNewline 
        Write-Host "$NewCompositionValue" -ForegroundColor Green
        
        $NewComposition = $NewCompositionValue
    }
    else {
        Write-Host "Row number $Counter does not match"
        $NewComposition = $Composition
    }
    
    #Build up the result csv file content
    [pscustomobject]@{
        SKU = $SKU
        Composition = $NewComposition
    }

    $Counter++
}

$NewData | Export-Csv ".\Output.csv" -NoTypeInformation