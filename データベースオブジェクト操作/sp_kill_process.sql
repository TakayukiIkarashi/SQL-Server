--�T�v�@�@�@�F�w�肵��spid�̃v���Z�X���폜���܂��B
--�����@�@�@�F[@target_spid]...�v���Z�X���폜����spid
--�߂�l�@�@�F����I���Ȃ�0�A�����łȂ����-1
--���ʃZ�b�g�F��O�����������ꍇ�A�G���[���
CREATE PROCEDURE [sp_kill_process]
    @target_spid SMALLINT
AS
BEGIN
    SET NOCOUNT ON;

    --KILL�R�}���h�����s���铮�ISQL���쐬���܂��B
    --���uKILL @spid;�v�̓G���[�ƂȂ邽�߁A���ISQL�őΉ�
    DECLARE @sql VARCHAR(MAX);
    SET @sql = 'KILL ' + CONVERT(VARCHAR, @target_spid);

    --spid���폜���܂��B
    BEGIN TRY
        EXECUTE (@sql);
    END TRY
    BEGIN CATCH
        EXECUTE sp_returnerror 'sp_kill_process:�v���Z�X�̍폜�Ɏ��s���܂����B';
        RETURN (-1);
    END CATCH

    --����I����Ԃ��܂��B
    RETURN (0);
END
GO
