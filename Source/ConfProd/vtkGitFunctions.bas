Attribute VB_Name = "vtkGitFunctions"
'---------------------------------------------------------------------------------------
' Module    : vtkGitHubFunctions
' Author    : Abdelfattah Lahbib
' Date      : 08/06/2013
' Purpose   : Interact with Git
'---------------------------------------------------------------------------------------

Option Explicit


'---------------------------------------------------------------------------------------
' Procedure : isGitCmdInString
' Author    : Lucas Vitorino
' Purpose   : Test if a string contains the "Git\cmd" substring.
'---------------------------------------------------------------------------------------
'
Private Function isGitCmdInString(myString As String) As Boolean
    isGitCmdInString = (InStr(UCase(myString), UCase("Git\cmd")))
End Function


'---------------------------------------------------------------------------------------
' Procedure : isGitInstalled
' Author    : Abdelfattah Lahbib
' Date      : 09/06/2013
' Purpose   : - Check if the Git "cmd.exe" is accessible via the PATH.
'---------------------------------------------------------------------------------------
'
Private Function isGitInstalled() As Boolean
    
    'Test if the "Git\cmd" substring is in the PATH string
    isGitInstalled = InStr(UCase(Environ("PATH")), UCase("Git\cmd"))
    
End Function

'---------------------------------------------------------------------------------------
' Procedure : vtkInitializeGit
' Author    : Abdelfattah Lahbib
' Date      : 27/04/2013
' Purpose   : - Initialize Git in the project root folder using the "git init" command.
'             - Log the output of the "git init" command in $projectDirectory\GitLog\logGitInitialize.log
'---------------------------------------------------------------------------------------
'
Public Function vtkInitializeGit()
       
    Dim logFileName As String
    Dim GitLogAbsoluteDirPath As String
    Dim GitLogRelativeDirPath As String
    Dim FileInitPath As String
    Dim RetShell1 As String
    Dim RetShell2 As String
    Dim RetFnVerifyEnvVar As String
    Dim ActiveProjPath As String
    Dim RetShellMessage As String
    Dim logFileFullPath As String
    Dim fso As New FileSystemObject
 
    On Error GoTo vtkInitializeGit_Err
     
 If isGitInstalled Then
 
    ' Make paths
    ActiveProjPath = fso.GetParentFolderName(ActiveWorkbook.path)
    GitLogRelativeDirPath = "GitLog"
    GitLogAbsoluteDirPath = ActiveProjPath & "\" & GitLogRelativeDirPath
    logFileName = "logGitInitialize.log"
  
    ' Create log file
    logFileFullPath = vtkCreateFileInDirectory(logFileName, GitLogAbsoluteDirPath)
    ' Execute git init in the project directory and log the output in the relevant file
    ' NB : You have to redirect the log using the *relative* path.
    RetShell1 = Shell("cmd.exe /k cd " & ActiveProjPath & " & git init   >" & GitLogRelativeDirPath & "\" & logFileName & " ")
    ' Make a break to execute shell commands
    Application.Wait (Now + TimeValue("0:00:01"))
    ' Kill related processus
    RetShell2 = Shell("cmd.exe /k  TASKKILL /IM cmd.exe")
    ' Make a break to execute shell commands
    Application.Wait (Now + TimeValue("0:00:01"))

 End If
 
 On Error GoTo 0
 Exit Function
 
vtkInitializeGit_Err:
    Debug.Print "Error " & err.Number & " in vtkInitializeGit : " & err.Description
    vtkInitializeGit = err.Number
 
End Function


'---------------------------------------------------------------------------------------
' Procedure : vtkStatusGit
' Author    : Abdelfattah Lahbib
' Date      : 30/04/2013
' Purpose   : - Log the output of the "git status" command in $projectDirectory\GitLog\logStatus.log
'             - Pop a MsgBox with the content of this file.
'---------------------------------------------------------------------------------------
'
Public Function vtkStatusGit() As String
  
    Dim ActiveProjPath As String
    Dim logFileName As String
    Dim GitLogRelativeDirPath As String
    Dim GitLogAbsoluteDirPath As String
    Dim logFileFullPath As String
    Dim RetShell As String
    Dim RetShell2 As String
    Dim fso As New FileSystemObject
      
    On Error GoTo vtkStatusGit_Error
    
    ' make paths
    ActiveProjPath = fso.GetParentFolderName(ActiveWorkbook.path)
    logFileName = "logStatus.log"
    GitLogRelativeDirPath = "GitLog"
    GitLogAbsoluteDirPath = ActiveProjPath & "\" & GitLogRelativeDirPath
    logFileFullPath = GitLogAbsoluteDirPath & "\" & logFileName
    
    ' create status log file
    vtkCreateFileInDirectory logFileName, GitLogAbsoluteDirPath
    ' Execute git status in the project directory  and log the output in the relevant file
    RetShell = Shell("cmd.exe /k cd " & ActiveProjPath & " & git status   >" & logFileFullPath & " ", vbHide)
    ' make a break to execute shell commands
    Application.Wait (Now + TimeValue("0:00:01"))
    ' kill related processus
    RetShell2 = Shell("cmd.exe /k  TASKKILL /IM cmd.exe")
    ' make a break to execute shell commands
    Application.Wait (Now + TimeValue("0:00:01"))
    ' read log file , and return its content
    vtkStatusGit = vtkTextFileReader(logFileFullPath)

   On Error GoTo 0
   Exit Function

vtkStatusGit_Error:
    MsgBox "Error " & err.Number & " (" & err.Description & ") in procedure vtkStatusGit of Module vtkGitFunctions"
    vtkStatusGit = err.Number
End Function



