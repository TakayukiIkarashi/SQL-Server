--�T�v�@�@�@�F�w�肵���z�X�g������������SQL Server�̃v���Z�X���擾���Aspid��Ԃ��܂��B
--�����@�@�@�F[@hostname]...�z�X�g��
--�߂�l�@�@�F����I���Ȃ�0�A�����łȂ����-1
--���ʃZ�b�g�F����I�������ꍇ�A�w�肵���z�X�g��spid���ʃ��X�g
--�@�@�@�@�@�@��O�����������ꍇ�A�G���[���
CREATE PROCEDURE [sp_get_process]
    @hostname VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    --spid���擾���܂��B
    BEGIN TRY
        SELECT [spid]
        FROM [sys].[sysprocesses] WITH (nolock)
        WHERE [hostname] = @hostname
        AND [spid] <> @@spid
        ORDER BY [spid];
    END TRY
    BEGIN CATCH
        EXECUTE sp_returnerror 'sp_get_process:�v���Z�X�̎擾�Ɏ��s���܂����B';
        RETURN (-1);
    END CATCH

    --����I����Ԃ��܂��B
    RETURN (0);
END
GO
