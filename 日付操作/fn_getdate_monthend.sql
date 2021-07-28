--�T�v�@�@�@�F�����Ɏw�肳�ꂽ�N�̏t���̓���Ԃ��܂�
--�����@�@�@�F[@yyyy]�c�Ώ۔N
--�߂�l�@�@�F�����Ɏw�肳�ꂽ�N�̏t���̓�
IF (EXISTS(SELECT * FROM sys.objects WHERE (type = 'FN') AND (name = 'fn_getdate_monthend')))
BEGIN
    DROP FUNCTION fn_getdate_monthend;
END
GO

CREATE FUNCTION fn_getdate_monthend
(
    @year INT
  , @month INT
)
RETURNS DATETIME
AS
BEGIN
    --�Ώی��̌����̕�����^�����߂܂�
    DECLARE @strdate_start VARCHAR(10);
    SET @strdate_start = CONVERT(VARCHAR, @year) + '-' + CONVERT(VARCHAR, @month) + '-1';

    --�Ώی��̌����̓��t�^�����߂܂�
    DECLARE @date_month_start DATETIME;
    SET @date_month_start = CONVERT(DATETIME, @strdate_start);

    --�Ώی��̌�����1�J��������߂܂�
    DECLARE @date_month_plus1 DATETIME;
    SET @date_month_plus1 = DATEADD(month, 1, @date_month_start);

    --�Ώی��̌�����1�J����̑O����Ԃ��܂�
    RETURN DATEADD(day, -1, @date_month_plus1);
END
GO
