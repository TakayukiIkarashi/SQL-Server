--�T�v�@�@�@�F������Ԃ��܂�
--�����@�@�@�F[@year] �c�Ώ۔N
--�@�@�@�@�@�@[@month]�c�Ώی�
--�߂�l�@�@�F�Ώ۔N���̌���
IF (EXISTS(SELECT * FROM sys.objects WHERE (type = 'FN') AND (name = 'fn_getdate_monthstart')))
BEGIN
    DROP FUNCTION fn_getdate_monthstart;
END
GO

CREATE FUNCTION fn_getdate_monthstart
(
    @year INT,
    @month INT
)
RETURNS DATETIME
AS
BEGIN
    DECLARE @strdate VARCHAR(10);
    SET @strdate = CONVERT(VARCHAR, @year) + '-' + CONVERT(VARCHAR, @month) + '-1';

    RETURN CONVERT(DATETIME, @strdate);
END
GO
