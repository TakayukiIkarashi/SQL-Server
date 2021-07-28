--�T�v�@�@�@�F�C�ӂ̔N���̑悎��ڂ́Z�j���̓��t�����߂܂�
--�����@�@�@�F[@year] �@�@�c�Ώ۔N
--�@�@�@�@�@�@[@month]�@�@�c�Ώی�
--�@�@�@�@�@�@[@num]�@�@�@�c���Ԗڂ̗j�����A��1�j���Ȃ�1�A��3�j���Ȃ�3
--�@�@�@�@�@�@[@dayofweek]�c1�i���j���j����7�i�y�j���j�܂ł̐�����Ԃ��܂�
--�߂�l�@�@�F�C�ӂ̔N���̑�n���j���̓��t
IF (EXISTS(SELECT * FROM sys.objects WHERE (type = 'FN') AND (name = 'fn_getdate_dayofweek')))
BEGIN
    DROP FUNCTION fn_getdate_dayofweek;
END
GO

CREATE FUNCTION fn_getdate_dayofweek
(
    @yyyy INT
  , @mm INT
  , @num INT
  , @dayofweek INT
)
RETURNS DATETIME
AS
BEGIN
    --�N����ь��̕�����^��ϐ��Ɏ擾���܂�
    DECLARE @str_yyyy VARCHAR(4);
    SET @str_yyyy = CONVERT(VARCHAR, @yyyy);

    DECLARE @str_mm VARCHAR(2);
    SET @str_mm = RIGHT('00' + CONVERT(VARCHAR, @mm), 2);

    --���t�f�[�^�̍�Ɨp�ϐ��ł�
    DECLARE @date_work DATETIME;
    SET @date_work = NULL;

    --�w�肵���N����1���̗j�����擾���܂�
    SET @date_work = CONVERT(DATETIME, @str_yyyy + '-' + @str_mm + '-01');
    DECLARE @dayofweek_first INT;
    SET @dayofweek_first = DATEPART(weekday, @date_work);

    --�w�肵���j���̑�1�j���̓������߂܂�
    DECLARE @int_dd INT;
    SET @int_dd = @dayofweek - @dayofweek_first + 1;
    IF (@int_dd <= 0)
    BEGIN
        SET @int_dd = @int_dd + 7;
    END

    --���߂�������t�^�ɕϊ����܂��B
    SET @date_work = CONVERT(DATETIME, @str_yyyy + '-' + @str_mm + '-' + CONVERT(VARCHAR, @int_dd));

    --�w�肵���񐔕��A�T���ړ����܂��B
    RETURN (DATEADD(day, (@num - 1) * 7, @date_work));
END
GO
