--�T�v�@�@�@�F�����Ɏw�肳�ꂽ�N�̏H���̓���Ԃ��܂�
--�����@�@�@�F[@yyyy]�c�Ώ۔N
--�߂�l�@�@�F�����Ɏw�肳�ꂽ�N�̏H���̓�
IF (EXISTS(SELECT * FROM sys.objects WHERE (type = 'FN') AND (name = 'fn_getdate_syuubun')))
BEGIN
    DROP FUNCTION fn_getdate_syuubun;
END
GO

CREATE FUNCTION fn_getdate_syuubun
(
    @year INT
)
RETURNS INT
AS
BEGIN
    RETURN (CONVERT(INT, ((23.2488 + 0.242194 * (@year - 1980)) - (CONVERT(INT, ((@year - 1980) / 4.000000))))));
END
GO
