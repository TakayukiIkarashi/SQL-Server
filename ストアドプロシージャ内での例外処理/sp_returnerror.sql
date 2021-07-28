--�T�v�@�@�@�F�G���[�̏ڍׂ�Ԃ��܂�
--�����@�@�@�F[@message]�c�G���[�ڍׂɊ܂߂�C�ӂ̕�����
--�߂�l�@�@�F�Ȃ�
--���ʃZ�b�g�F�G���[���
CREATE PROCEDURE [dbo].[sp_returnerror]
    @message VARCHAR(255)   --�G���[�ڍׂɊ܂߂�C�ӂ̕�����
AS
BEGIN
   --���ʌ�����\�����Ȃ��悤�ɂ��܂��B
    SET NOCOUNT ON;

    --�e��G���[�֐����猋�ʃZ�b�g�Ɋ܂߂郌�R�[�h�𐶐����܂��B
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage,
        @message AS ApplicationMessage;
END
