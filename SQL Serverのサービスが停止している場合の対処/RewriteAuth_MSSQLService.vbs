Option Explicit

'==============================
' ������
'==============================
'RewriteAuth_MSSQLService�N���X���C���X�^���X�����܂�
Dim ra
Set ra = New RewriteAuth_MSSQLService

'RewriteAuth_MSSQLService�N���X��Execute()���\�b�h�����s���܂�
Dim bRet
bRet = ra.Execute()

'�������b�Z�[�W��\�����܂�
If (bRet) Then
    MsgBox "SQLServer�T�[�r�X�̎��s���������������܂����B"
Else
    MsgBox "���s���܂����B", vbCritical + vbOkOnly
End If

'�N���X���FRewriteAuth_MSSQLService
'�T�v�@�@�FSQLServer�T�[�r�X�̌����������ς��邽�߂̃N���X�ł�
Class RewriteAuth_MSSQLService

    '================================================================================
    ' �v���p�e�B�FSQLServer�T�[�r�X�̃A�N�Z�X�������o�b�N�A�b�v����p�X���擾���܂�
    '================================================================================
    Private Property Get SD_PATH()
        Dim fso
        Set fso = CreateObject("Scripting.FileSystemObject")

        SD_PATH = fso.GetSpecialFolder(2).Path & "\mssqlserver_sd.txt"
    End Property

    '********************************************************************************
    ' ���\�b�h���FExecute()
    ' �T�v�@�@�@�F�����������s
    ' �p�����[�^�F�Ȃ�
    ' �߂�l�@�@�F����I���Ȃ�True�A�����łȂ����False
    '********************************************************************************
    Public Function Execute()

        '�߂�l�����������܂�
        Execute = False

        'SQLServer�T�[�r�X�̃A�N�Z�X�������X�g���擾���܂�
        Dim sAcc
        If (GetSD(sAcc) = False) Then
            Exit Function
        End If

        '���ł�PowerUsers�O���[�v�̃A�N�Z�X���������݂���ꍇ�͏����𔲂��܂�
        If (IsDone(sAcc)) Then
            Execute = True
            Exit Function
        End If

        '�A�N�Z�X�������X�g�������ς��܂�
        sAcc = RemakeDACL(sAcc)

        '�A�N�Z�X�������X�g�̏����������s���Ȃ������ꍇ�͏����𔲂��܂�
        If (sAcc = "") Then
            Call MsgBox("�A�N�Z�X�������X�g�̌`�����z��O�̂��߁A�����ł��܂���ł����B")
            Exit Function
        End If

        '�����������A�N�Z�X�������X�g��SQLServer�T�[�r�X�ɍĐݒ肵�܂�
        If (SetSD(sAcc) = False) Then
            Exit Function
        End If

        '����I����Ԃ��܂�
        Execute = True

    End Function

    '********************************************************************************
    ' ���\�b�h���FGetSD()
    ' �T�v�@�@�@�FSQLServer�T�[�r�X�̃A�N�Z�X�������擾���܂�
    ' �p�����[�^�F[sAcc]...�A�N�Z�X�������X�g
    ' �߂�l�@�@�F����Ɏ擾�ł����True�A�����łȂ����False
    '********************************************************************************
    Private Function GetSD(ByRef sAcc)

        '�߂�l�����������܂�
        GetSD = False

        '�ϐ������������܂�
        sAcc = ""

        '���s����R�}���h���쐬���܂�
        Dim cmd
        cmd = "sc sdshow MSSQLSERVER > " & SD_PATH

        '�쐬�����R�}���h�����s���܂��i��������������܂őҋ@���܂��j
        If (CommandBatShell(cmd, True) = False) Then
            Exit Function
        End If

        '�A�N�Z�X�������X�g�̏o�͂Ɏ��s�����ꍇ�͏����𔲂��܂�
        If (IsFileExists(SD_PATH) = False) Then
            Call MsgBox("SQLServer�T�[�r�X�̃A�N�Z�X�������X�g�̏o�͂Ɏ��s���܂����B")
            Exit Function
        End If

        '�R�}���h�̎��s���ʂ�ǂݍ��݂܂�
        sAcc = ReadText(SD_PATH)

        '���s�R�[�h����菜���܂�
        sAcc = Replace(sAcc, vbCrLf, "")

        '����I����Ԃ��܂�
        GetSD = True

    End Function

    '********************************************************************************
    ' ���\�b�h���FIsDone()
    ' �T�v�@�@�@�F���ł�PowerUsers�̃A�N�Z�X�������ݒ肳��Ă��邩�ǂ�����Ԃ��܂�
    ' �p�����[�^�F[sAcc]...�A�N�Z�X�������X�g
    ' �߂�l�@�@�FPowerUsers�̃A�N�Z�X�������ݒ肳��Ă����True�A�ݒ肳��Ă��Ȃ����False
    '********************************************************************************
    Private Function IsDone(ByVal sAcc)

        'PowerUsers�̃A�N�Z�X�������܂ޕ�����̑��݃`�F�b�N���s���܂�
        If (0 < InStr(1, sAcc, ";;;PU)")) Then
            '����Ζ߂�l�Ƃ���True��Ԃ��܂�
            IsDone = True
        Else
            '�Ȃ���Ζ߂�l�Ƃ���False��Ԃ��܂�
            IsDone = False
        End If

    End Function

    '********************************************************************************
    ' ���\�b�h���FRemakeDACL()
    ' �T�v�@�@�@�F�����Ɏw�肳�ꂽ�A�N�Z�X�������X�g��ύX���܂�
    ' �p�����[�^�F[sAcc]...�A�N�Z�X�������X�g
    ' �߂�l�@�@�F�ύX�����A�N�Z�X�������X�g
    '********************************************************************************
    Private Function RemakeDACL(ByVal sAcc)

        'PowerUsers�ɕt�^���錠�����i�[����ϐ����`���܂�
        Dim sAccPU
        sAccPU = ""

        '�ʒu�������ϐ����擾���܂�
        Dim pos

        '"D:"�̈ʒu���擾���܂�
        pos = InStr(1, sAcc, "D:")

        '"D:"��������Ȃ���Ώ����𔲂��܂�
        If (pos < 1) Then
            Call MsgBox("�A�N�Z�X�������X�g�̋L�q���z��O�̂��߁A�����ł��܂���ł����B")
            Exit Function
        End If

        'POS�̈ʒu���A�N�Z�X�����̕�����̊J�n�ʒu�܂ňړ����܂�
        pos = InStr(1, sAcc, "(")

        '���[�U�[�����������܂�
        Do
            '�A�N�Z�X�������X�g�̕�������I�[�܂Ō��������ꍇ�̓��[�v�𔲂��܂�
            If (Len(sAcc) < pos) Then
                Exit Do
            End If

            '���ɑ������������[�U�[��`�̃u���b�N�ł͂Ȃ��ꍇ�̓��[�v�𔲂��܂�
            If (Mid(sAcc, pos, 1) <> "(") Then
                Exit Do
            End If

            '���[�U�[�P�ʂ̌����̖������擾���܂�
            Dim posE
            posE = InStr(pos, sAcc, ")")

            '���[�U�[�����擾���܂�
            Dim usr
            usr = Mid(sAcc, posE - 2, 2)

            '�����������[�U�[��"SY"�iLocal System�j���[�U�[�̏ꍇ�͂��̌������R�s�[���܂�
            If (usr = "SY") Then
                sAccPU = Mid(sAcc, pos, posE - pos + 1)
            End If

            '���̃��[�U�[�����Ɉڍs���܂�
            pos = posE + 1
        Loop

        'PowerUsers�ɃR�s�[����\���Local System���[�U�[�̃A�N�Z�X�������擾�ł��Ȃ���Ώ����𔲂��܂�
        If (sAccPU = "") Then
            Call MsgBox("Local System���[�U�[�̃A�N�Z�X�������擾�ł��܂���ł����B")
            Exit Function
        End If

        'Local System���[�U�[�̃A�N�Z�X�������z��O�̕�����̏ꍇ�͏����𔲂��܂�
        If (InStr(1, sAccPU, ";;;SY") < 1) Then
            Call MsgBox("Local System���[�U�[�̃A�N�Z�X�������z��O�̂��߁A�����ł��܂���ł����B")
            Exit Function
        End If

        'Local System���[�U�[�̃A�N�Z�X�����̕�����ɂāA���[�U�[����PowerUsers�ɒu����������������擾���܂�
        sAccPU = Replace(sAccPU, ";;;SY", ";;;PU")

        '�߂�l�ƂȂ�ϐ����`���܂�
        Dim sRet
        sRet = Left(sAcc, posE) & sAccPU & Right(sAcc, Len(sAcc) - posE)

        '���������̌��ʂ��z��̏ꍇ�A�߂�l�Ƃ��ċ󕶎����Ԃ��܂��i�ҏW���s�j
        If (Replace(sRet, sAccPU, "") <> sAcc) Then
            sRet = ""
        End If

        '�ҏW��̕������Ԃ��܂�
        RemakeDACL = sRet

    End Function

    '********************************************************************************
    ' ���\�b�h���FSetSD()
    ' �T�v�@�@�@�FSQLServer�T�[�r�X�̃A�N�Z�X������ݒ肵�܂�
    ' �p�����[�^�F[sAcc]...�A�N�Z�X�������X�g
    ' �߂�l�@�@�F����ɐݒ�ł����True�A�����łȂ����False
    '********************************************************************************
    Private Function SetSD(ByVal sAcc)

        '�߂�l�����������܂�
        SetSD = False

        '���s����R�}���h���쐬���܂�
        Dim cmd
        cmd = "sc sdset MSSQLSERVER " & sAcc

        '�쐬�����R�}���h�����s���܂��i��������������܂őҋ@���܂���j
        If (CommandBatShell(cmd, False) = False) Then
            Exit Function
        End If

        '����I����Ԃ��܂�
        SetSD = True

    End Function

    '********************************************************************************
    ' ���\�b�h���FCommandBatShell()
    ' �T�v�@�@�@�F�����Ɏw�肳�ꂽ�R�}���h�����s���܂�
    ' �p�����[�^�F[cmd]...���s����R�}���h
    ' �@�@�@�@�@�@[bWait]...��������������܂őҋ@����ꍇ��True�A�ҋ@���Ȃ��ꍇ��False���w��
    ' �߂�l�@�@�F����Ɏ��s�ł����True�A�����łȂ����False
    '********************************************************************************
    Private Function CommandBatShell(ByVal cmd, ByVal bWait)

        '�߂�l�����������܂�
        CommandBatShell = False

        '�o�b�`�t�@�C�����e���|�����ɍ쐬���܂�
        Dim batpath
        batpath = GetTempPath() & "\sccmd.bat"
        If (IsFileExists(batpath)) Then
            '���łɑO����s�����o�b�`�t�@�C�������݂���ꍇ�͍폜���܂�
            If (RemoveFile(batpath) = False) Then
                Exit Function
            End If
        End If

        '�����Ɏw�肳�ꂽ�R�}���h���o�b�`�t�@�C���ɏo�͂��܂�
        Dim fso
        Set fso = CreateObject("Scripting.FileSystemObject")
        Dim bat
        Set bat = fso.CreateTextFile(batpath)
        bat.WriteLine(cmd)
        bat.Close()

        '�ҋ@���K�v�ȏꍇ
        If (bWait) Then
            '�o�b�`�t�@�C�������s���A�I������܂őҋ@���܂�
            Dim intRet
            intRet = WScript.CreateObject("WScript.Shell").Run(batpath, 1, true)

            '�G���[�R�[�h���Ԃ��Ă����ꍇ�͏����𔲂��܂�
            If (intRet <> 0) Then
                Dim msg
                msg = ""
                msg = msg & "�R�}���h���s�Ɏ��s���܂����B" & vbCrLf
                msg = msg & vbCrLf
                msg = msg & "�G���[�R�[�h�F" & CStr(intRet)

                Call MsgBox(msg, vbCritical + vbOkOnly)
                Exit Function
            End If

        '�ҋ@���s�v�ȏꍇ�͊Ǘ��҃��[�h�Ŏ��s
        Else
            '�o�b�`�t�@�C�����Ǘ��҂Ƃ��Ď��s���܂�
            Dim sh
            Set sh = Wscript.CreateObject("Shell.Application")

            Call sh.ShellExecute(batpath, , , "runas")
        End If

        '����I����Ԃ��܂�
        CommandBatShell = True

    End Function

    '********************************************************************************
    ' ���\�b�h���FIsFileExists()
    ' �T�v�@�@�@�F�����Ɏw�肳�ꂽ�t�@�C���̑��݂��m�F���܂�
    ' �p�����[�^�F[fpath]...���݊m�F���s���t�@�C���̃t���p�X
    ' �߂�l�@�@�F�t�@�C�������݂���ꍇ��True�A���݂��Ȃ��ꍇ��False
    '********************************************************************************
    Function IsFileExists(ByVal fpath)

        'Scripting.FileSystemObject��COM���Q�Ƃ��܂�
        Dim fso
        Set fso = CreateObject("Scripting.FileSystemObject")

        'FileExists()���\�b�h�̖߂�l�����̊֐��̖߂�l�Ƃ��ĕԂ��܂�
        IsFileExists = fso.FileExists(fpath)

    End Function

    '********************************************************************************
    ' ���\�b�h���FRemoveFile()
    ' �T�v�@�@�@�F�����Ɏw�肳�ꂽ�t�@�C�����폜���܂�
    ' �p�����[�^�F[fpath]...�폜����t�@�C���̃t���p�X
    ' �߂�l�@�@�F����ɍ폜�ł����True�A�����łȂ����False
    '********************************************************************************
    Function RemoveFile(ByVal fpath)

        '�߂�l�����������܂�
        RemoveFile = False

        'Scripting.FileSystemObject��COM���Q�Ƃ��܂�
        Dim fso
        Set fso = CreateObject("Scripting.FileSystemObject")

        '�G���[�����������ꍇ�ł������𑱍s���܂�
        On Error Resume Next

        '�����Ɏw�肳�ꂽ�t�@�C�����폜���܂�
        Call fso.DeleteFile(fpath)

        '�G���[���������Ă����ꍇ�̂��̓��e�����b�Z�[�W�\�����ď����𔲂��܂�
        If (Err.Number <> 0) Then
            Call MsgBox(CStr(Err.Number) & ": " & Err.Description, vbCritical + vbOkOnly)
            Exit Function
        End If

        '����I����Ԃ��܂�
        RemoveFile = True

    End Function

    '********************************************************************************
    ' ���\�b�h���FReadText()
    ' �T�v�@�@�@�F�����Ɏw�肳�ꂽ�e�L�X�g�t�@�C����ǂݍ��݁A���̓��e��Ԃ��܂�
    ' �p�����[�^�F[tfpath]...�ǂݍ��ݑΏۂƂȂ�e�L�X�g�t�@�C���̃t���p�X
    ' �߂�l�@�@�F�e�L�X�g�t�@�C���̓��e
    '********************************************************************************
    Function ReadText(ByVal tfpath)

        '�߂�l�����������܂�
        ReadText = ""

        'Scripting.FileSystemObject��COM���Q�Ƃ��܂�
        Dim fso
        Set fso = CreateObject("Scripting.FileSystemObject")

        '�����Ɏw�肳�ꂽ�t�@�C����ǂݍ��݂܂�
        Dim s
        s = fso.OpenTextFile(tfpath, 1).ReadAll()

        '�ǂݍ��񂾓��e��߂�l�Ƃ��ĕԂ��܂�
        ReadText = s

    End Function

    '********************************************************************************
    ' ���\�b�h���FGetTempPath()
    ' �T�v�@�@�@�F�e���|�����p�X���擾���܂�
    ' �p�����[�^�F�Ȃ�
    ' �߂�l�@�@�F�e���|�����p�X
    '********************************************************************************
    Function GetTempPath()

        'Scripting.FileSystemObject��COM���Q�Ƃ��܂�
        Dim fso
        Set fso = CreateObject("Scripting.FileSystemObject")

        '�e���|�����̃t���p�X���擾���܂�
        Dim tp
        tp = fso.GetSpecialFolder(2).Path

        '�擾�����e���|�����̃t���p�X��Ԃ��܂�
        GetTempPath = tp

    End Function

End Class
