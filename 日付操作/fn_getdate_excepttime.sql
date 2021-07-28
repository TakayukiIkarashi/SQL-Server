--�T�v�@�@�@�F�����Ɏw�肳�ꂽ���t�^���玞���v�f����菜���ĕԂ��܂��B
--�����@�@�@�F[@date]�cDATETIME�^
--�߂�l�@�@�F�����v�f����菜����DATETIME�^
IF (EXISTS(SELECT * FROM sys.objects WHERE (type = 'FN') AND (name = 'fn_getdate_excepttime')))
BEGIN
    DROP FUNCTION fn_getdate_excepttime;
END
GO

CREATE FUNCTION fn_getdate_excepttime
(
    @date DATETIME
)
RETURNS DATETIME
AS
BEGIN
    RETURN CONVERT(DATETIME, CONVERT(nvarchar, @date, 111), 120);
END
GO
