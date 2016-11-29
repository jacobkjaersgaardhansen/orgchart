$path ="" # type path or make dynamic

$dataDep = (Get-Content ($path + "\data_departments.csv")) -join "`n"  
$dataEmp = (Get-Content ($path + "\data_employees.csv")) -join "`n"  

$hierarchy = ""
$parentID = "NULL" # NB "NULL" may be "" (blank), if it is directly output from SQL

function insideLoop([string]$parentID)
{
    foreach ($rowDep in $dataDep.split("`n")) 
    {
        $cellsDep = $rowDep.Split(";")
        if ($cellsDep[2] -eq $parentID)
        {
            $hierarchy = $hierarchy + "{ ""type"": ""dep"", ""departmentname"": """ + $cellsDep[0] + """, ""manager"": """ + $cellsDep[1] + """, ""children"": ["
            
            #find and attach all employees in this department
            foreach ($rowEmp in $dataEmp.split("`n"))
            {
                $cellsEmp = $rowEmp.Split(";")
                if ($cellsEmp[2] -eq $cellsDep[4])
                {
                    $hierarchy = $hierarchy + "{ ""type"": ""emp"", ""initials"": """ + $cellsEmp[0] + """, ""name"": """ + $cellsEmp[1] + """}"
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
