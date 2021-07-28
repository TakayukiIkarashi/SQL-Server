--�T�v�@�@�@�F�����Ɏw�肳�ꂽ�N�̏t���̓���Ԃ��܂�
--�����@�@�@�F[@yyyy]�c�Ώ۔N
--�߂�l�@�@�F�����Ɏw�肳�ꂽ�N�̏t���̓�
IF (EXISTS(SELECT * FROM sys.objects WHERE (type = 'FN') AND (name = 'fn_getdate_syunbun')))
BEGIN
    DROP FUNCTION fn_getdate_syunbun;
END
GO

CREATE FUNCTION fn_getdate_syunbun
(
    @year INT
)
RETURNS INT
AS
BEGIN
    RETURN (CONVERT(INT, ((20.8431 + 0.242194 * (@year - 1980)) - ((@year - 1980) / 4.000000))));
END
GO
