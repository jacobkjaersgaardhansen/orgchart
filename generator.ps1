$path ="C:\Users\jkdh\Desktop\orgchart-master" # type path or make dynamic

$dataDep = (Get-Content ($path + "\data_departments.csv")) -join "`n"  
$dataEmp = (Get-Content ($path + "\data_employees.csv")) -join "`n"  

$hierarchy = ""
$parentID = "TOP_LEVEL" 

function insideLoop([string]$parentID)
{
    foreach ($rowDep in $dataDep.split("`n")) 
    {
        $cellsDep = $rowDep.Split(";")
        if ($cellsDep[2] -eq $parentID)
        {
            $hierarchy = $hierarchy + "{ ""type"": ""dep"", ""name"": """ + $cellsDep[0] + """, ""initials"": """ + $cellsDep[1] + """, ""children"": ["
            
            #find and attach all employees in this department
            foreach ($rowEmp in $dataEmp.split("`n"))
            {
                $cellsEmp = $rowEmp.Split(";")
                if ($cellsEmp[2] -eq $cellsDep[4])
                {
                    $hierarchy = $hierarchy + "{ ""type"": ""emp"", ""name"": """ + $cellsEmp[1] + """, ""initials"": """ + $cellsEmp[0] + """}"
                }
            }
            
            $hierarchy = insideLoop $cellsDep[3]
            
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
