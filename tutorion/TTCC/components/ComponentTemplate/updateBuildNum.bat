@ECHO OFF 
SET /p CurrentBuild=<build.txt
SET /a NewBuild=%CurrentBuild%+1
>build.txt echo %NewBuild%