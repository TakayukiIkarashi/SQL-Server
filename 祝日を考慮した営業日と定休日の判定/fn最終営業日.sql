--�T�v�@�@�@�F�C�ӂ̔N���̍ŏI�c�Ɠ������߂܂��B
--�����@�@�@�F[@year] �c�Ώ۔N
--�@�@�@�@�@�@[@month]�c�Ώی�
--�߂�l�@�@�F�C�ӂ̔N���̑�n���j���̓��t
IF (EXISTS(SELECT * FROM sys.objects WHERE (type = 'FN') AND (name = 'fn�ŏI�c�Ɠ�')))
BEGIN
    DROP FUNCTION fn�ŏI�c�Ɠ�;
END
GO

CREATE FUNCTION fn�ŏI�c�Ɠ�
(
    @yyyy INT,
    @mm INT
)
RETURNS DATETIME
AS
BEGIN
    --�������t���擾���܂��B
    DECLARE @�������t DATETIME;
    SET @�������t = dbo.fn_getdate_monthend(@yyyy, @mm);

    --�߂�l�p���t���`���܂��B
    DECLARE @r���t DATETIME;
    SET @r���t = @�������t;

    --�x���e�[�u���ɋx���Ƃ��ēo�^����Ă��Ȃ����t�����߂܂��B
    WHILE (0 = 0)
    BEGIN
        IF (NOT EXISTS(SELECT * FROM [�x��] WHERE [���t] = @r���t))
        BEGIN
            BREAK;
        END
        SET @r���t = DATEADD(d, -1, @r���t);
    END

    RETURN @r���t;
END
GO
