--�T�v�@�@�@�F�w�肵�����t�̊��ԂɊY���������ŗ�����Ŕ����z��Ԃ��܂��B
--�����@�@�@�F[@�ō����z]
--�@�@�@�@�@�@[@�Ώۓ��t]
--�߂�l�@�@�F�Ŕ����z
IF (EXISTS(SELECT * FROM sysobjects WHERE (type = 'FN') AND (name = 'fn�Ŕ�')))
BEGIN
    DROP FUNCTION fn�Ŕ�;
END
GO

CREATE FUNCTION fn�Ŕ�
(
    @�ō����z MONEY,
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
    DECLARE @����Ŋz INT;
    SET @����Ŋz = ROUND(@�ō����z * @����ŗ� / (100 + @����ŗ�), 0, 1);

    --�ō����z�������Ŋz�����Z���A�Ŕ����z��Ԃ��܂��B
    RETURN @�ō����z - @����Ŋz;
END
GO
