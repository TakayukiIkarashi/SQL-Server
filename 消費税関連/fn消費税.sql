--�T�v�@�@�@�F�w�肵�����t�̊��ԂɊY������Ŕ����z�������Ŋz��Ԃ��܂��B
--�����@�@�@�F[@�Ŕ����z]
--�@�@�@�@�@�@[@�Ώۓ��t]
--�߂�l�@�@�F�Ŕ����z
IF (EXISTS(SELECT * FROM sysobjects WHERE (type = 'FN') AND (name = 'fn�����')))
BEGIN
    DROP FUNCTION fn�����;
END
GO

CREATE FUNCTION fn�����
(
    @�Ŕ����z MONEY,
    @�Ώۓ��t DATETIME
)
RETURNS MONEY
AS
BEGIN
    --�Ώۓ��t�ɊY���������ŗ�������ŗ��}�X�^����擾���܂��B
    DECLARE @����ŗ� INT;
    SET @����ŗ� = 0;
    SELECT @����ŗ� = [�ŗ�] FROM [����ŗ�]
    WHERE @�Ώۓ��t BETWEEN [�J�n���t] AND [�I�����t];

    --�擾��������ŗ��ƐŔ����z����Z���ď���Ŋz�����߂܂��B
    RETURN ROUND(@�Ŕ����z * @����ŗ� / 100, 0, 1);
END
GO
