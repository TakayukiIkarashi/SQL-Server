--�T�v�@�@�@�F�w�肵�����t�̊��ԂɊY���������ŗ�����ō����z��Ԃ��܂��B
--�����@�@�@�F[@�Ŕ����z]
--�@�@�@�@�@�@[@�Ώۓ��t]
--�߂�l�@�@�F�ō����z
IF (EXISTS(SELECT * FROM sysobjects WHERE (type = 'FN') AND (name = 'fn�ō�')))
BEGIN
    DROP FUNCTION fn�ō�;
END
GO

CREATE FUNCTION fn�ō�
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
    WHERE @�Ώۓ��t BETWEEN [�J�n���t] AND [�I�����t]

    --�擾��������ŗ��Ƌ��z����Z���Ė߂�l�Ƃ��ĕԂ��܂��B
    RETURN ROUND(@�Ŕ����z * (100 + @����ŗ�) / 100, 0, 1);
END
GO
