/*
********************************************************************************
 �T�v�F���l�̊J�n�ƏI�����w�肵�A�Y������͈͂̐���̏W�����e�[�u���Ƃ��ĕԂ�
********************************************************************************
*/
CREATE FUNCTION fn_getdigits
(
    @start  INT     --�J�n���l
  , @end    INT     --�I�����l
)
RETURNS @table TABLE
(
    num_value   INT
)
AS
BEGIN
    --���l���i�[����ϐ����`���A�����l�Ƃ��ĊJ�n���l�������܂�
    DECLARE @i INT;
    SET @i = @start;

    --�I�����l�ɂȂ�܂ŏ������J��Ԃ��܂�
    WHILE (@i <= @end)
    BEGIN
        --�e���|�����e�[�u���Ɍ��݂̐��l�f�[�^��ǉ����܂�
        INSERT INTO @table (num_value) VALUES (@i);

        --���̐��l���������܂�
        SET @i = @i + 1;
    END

    --�I�����܂�
    RETURN;
END
