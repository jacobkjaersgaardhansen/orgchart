$path ="" # type path or make dynamic

$pathIn = $path + "\data.csv"
$table = (Get-Content $pathIn) -join "`n"  

$hierarchy = ""
$parentID = "NULL" # NB "NULL" may be "" (blank), if it is directly output from SQL

function insideLoop([string]$parentID)
{
    foreach ($row in $table.split("`n")) 
    {
        $cells = $row.Split(",")
        if ($cells[2] -eq $parentID)
        {
            $hierarchy = $hierarchy + "{ ""departmentname"": """ + $cells[0] + """, ""manager"": """ + $cells[1] + """, ""children"": ["
            $hierarchy = insideLoop $cells[3]
            
            $hierarchy = $hierarchy + "]}"
        }
    }
    return $hierarchy
}

$hierarchy = insideLoop $parentID

$hierarchy = "var root = " + $hierarchy.Replace("}{","},{")
$hierarchy = $hierarchy.Replace(", ""children"": []","")

$pathOut = $path + "\hierarchy.js"
$hierarchy | Out-File $pathOut
