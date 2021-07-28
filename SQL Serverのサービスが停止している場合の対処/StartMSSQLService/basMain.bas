Attribute VB_Name = "basMain"
'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
' SQLServer�̃T�[�r�X����~���Ă����ꍇ�A�N�����܂�
'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Option Explicit

'----------------------------------------
' Win32 API
'----------------------------------------
Private Declare Sub Sleep Lib "kernel32" (ByVal ms As Long)

'----------------------------------------
' �萔��`
'----------------------------------------
'�T�[�r�X�̏��
Public Const STATUS_RUNNING As String = "RUNNING"
Public Const STATUS_STOPPED As String = "STOPPED"
Public Const STATUS_START_PENDING As String = "START PENDING"
Public Const STATUS_STOP_PENDING As String = "STOP PENDING"

'********************************************************************************
' �֐����FMain
' �T�v�@�F�N��������
' �����@�F�Ȃ�
' �߂�l�F�Ȃ�
'********************************************************************************
Sub Main()

    'SQL Server �T�[�r�X�̃C���X�^���X���`���܂�
    Dim Service As Object

    'SQL Server �T�[�r�X�̏�Ԃ��擾���܂�
    Dim s As String
    s = GetStatus(Service)

    'SQL Server �T�[�r�X�̏�Ԃ��m�F���܂�
    Select Case UCase(s)
    '��~��
    Case STATUS_STOPPED
        'SQL Server �T�[�r�X���N�����܂�
        If (StartService(Service) = False) Then
            '�N���Ɏ��s�����ꍇ�A�_�C�A���O��\�����ăT�[�r�X���N������܂őҋ@���܂�
            Call ShowDialog
        End If

    '���s�J�n���E��~�ڍs��
    Case STATUS_START_PENDING, STATUS_STOP_PENDING
        '�_�C�A���O��\�����ăT�[�r�X���N������܂őҋ@���܂�
        Call ShowDialog

    '���s���i�������͂���ȊO�j
    Case Else
        '���ɉ������Ȃ�

    End Select

End Sub

'********************************************************************************
' �֐����FGetStatus()
' �T�v�@�FSQL Server �T�[�r�X�̏�Ԃ𕶎���Ŏ擾���܂�
' �����@�F[Service]...SQL Server �T�[�r�X�̃I�u�W�F�N�g
' �߂�l�FSQL Server �T�[�r�X�̏�ԁi������j
'********************************************************************************
Public Function GetStatus(ByRef Service As Object) As String

    '�߂�l�����������܂�
    GetStatus = ""

    Set Service = Nothing

    '�G���[�����������ꍇ�͗�O�����Ɉڍs���܂�
    On Error GoTo Exception

    'SQL Server�T�[�r�X�̏�Ԃ��擾���邽�߂�WQL���`���܂�
    Dim WQL As String
    WQL = "SELECT * FROM Win32_Service WHERE Name = 'MSSQLSERVER'"

    '��`����WQL�����s���܂�
    Dim ServiceList As Object
    Set ServiceList = CreateObject("WbemScripting.SWbemLocator").ConnectServer.ExecQuery(WQL)

    'SQL Server�T�[�r�X�̏�Ԃ��擾���܂�
    For Each Service In ServiceList
        '�߂�l���Z�b�g���܂�
        GetStatus = Service.state
        Exit For
    Next

    Exit Function

Exception:
    '�G���[���������Ă��������܂���

End Function

'********************************************************************************
' �֐����FStartService
' �T�v�@�F�T�[�r�X���J�n���܂�
' �����@�F[Service]...�J�n����T�[�r�X
' �߂�l�F�T�[�r�X�̊J�n�ɐ���������True�A���s������False
'********************************************************************************
Public Function StartService(ByRef Service As Object) As Boolean

    '�T�[�r�X���N�����܂�
    Dim lngRet As Long
    lngRet = Service.StartService()

    '�߂�l��0�Ȃ琬���A0�ȊO�Ȃ玸�s
    If (lngRet = 0) Then
        StartService = True
    Else
        StartService = False
    End If

End Function

'********************************************************************************
' �֐����FStopService
' �T�v�@�F�T�[�r�X���~���܂�
' �����@�F[Service]...��~����T�[�r�X
' �߂�l�F�T�[�r�X�̒�~�ɐ���������True�A���s������False
'********************************************************************************
Public Function StopService(ByRef Service As Object) As Boolean

    '�T�[�r�X���~���܂�
    Dim lngRet As Long
    lngRet = Service.StopService()

    '�߂�l��0�Ȃ琬���A0�ȊO�Ȃ玸�s
    If (lngRet = 0) Then
        StopService = True
    Else
        StopService = False
    End If

End Function

'********************************************************************************
' �֐����FShowDialog
' �T�v�@�F�T�[�r�X�J�n���_�C�A���O��\�����܂�
' �����@�F�Ȃ�
' �߂�l�F�Ȃ�
'********************************************************************************
Private Sub ShowDialog()

    '�T�[�r�X�N�����_�C�A���O��\�����܂�
    Dim f As New frmDialog
    f.Show vbModal

End Sub
