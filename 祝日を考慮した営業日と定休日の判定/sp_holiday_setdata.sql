--�T�v�@�@�@�F�w�肳�ꂽ�N�̋x�����J�����_�[�e�[�u���ɒǉ����܂�
--�����@�@�@�F[@yyyy]�c�ΏۂƂȂ�N
--�߂�l�@�@�F����I���Ȃ�0�A�����łȂ����-1
--���ʃZ�b�g�F��O�����������ꍇ�A�G���[���
IF (EXISTS(SELECT * FROM sys.objects WHERE (type = 'P') AND (name = 'sp_holiday_setdata')))
BEGIN
  DROP PROCEDURE sp_holiday_setdata;
END
GO

CREATE PROCEDURE sp_holiday_setdata
  @yyyy INT
AS
BEGIN
  SET NOCOUNT ON;

/*
******************************
�e���|�����e�[�u���Ƀf�[�^���Z�b�g
******************************
*/
  SET NOCOUNT ON;

  --�v���V�[�W���̖߂�l��Ԃ��ϐ����`���܂�
  DECLARE @RTCD INT;
  SET @RTCD = 0;

  --�Ώ۔N�̕�����^��ϐ��Ɋi�[���܂�
  DECLARE @str_year VARCHAR(4);
  SET @str_year = CONVERT(VARCHAR, @yyyy);

  --���t�f�[�^�̍�Ɨp�ϐ��ł�
  DECLARE @date_work DATETIME;
  SET @date_work = CONVERT(DATETIME, @str_year + '-01-01');

  --�y�����x���Ƃ��ēo�^���܂�
  WHILE (0 = 0)
  BEGIN
    --�N���ς��܂�1������J��Ԃ��y�����ǂ����𔻒f���A�y���ł���΃J�����_�[�e�[�u���ɓo�^���܂�
    IF (@yyyy < YEAR(@date_work))
    BEGIN
      BREAK;
    END

    IF ((DATEPART(weekday, @date_work) = 1) OR (DATEPART(weekday, @date_work) = 7))
    BEGIN
      BEGIN TRY
        INSERT INTO �J�����_�[ (�Ώۓ��t, �Ώۋ敪) VALUES (@date_work, 1);
      END TRY
      BEGIN CATCH
        EXECUTE sp_returnerror 'sp_holiday_setdata:�y���̒ǉ��Ɏ��s���܂����B';
        RETURN -1;
      END CATCH
    END

    SET @date_work = DATEADD(d, 1, @date_work);
  END

  --�N�n1��
  SET @date_work = CONVERT(DATETIME, @str_year + '-01-01');
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�N�n2��
  SET @date_work = CONVERT(DATETIME, @str_year + '-01-02');
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�N�n3��
  SET @date_work = CONVERT(DATETIME, @str_year + '-01-03');
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --���l�̓��i1���̑�2�T���j���j
  SET @date_work = dbo.fn_getdate_dayofweek(@yyyy, 1, 2, 2);
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�����L�O�̓�
  SET @date_work = CONVERT(DATETIME, @str_year + '-02-11');
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�t���̓�
  SET @date_work = CONVERT(DATETIME, @str_year + '-03-' + CONVERT(VARCHAR, (dbo.fn_getdate_syunbun(@yyyy))));
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --���a�̓�
  SET @date_work = CONVERT(DATETIME, @str_year + '-04-29');
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --���@�L�O��
  SET @date_work = CONVERT(DATETIME, @str_year + '-05-03');
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�݂ǂ�̓�
  SET @date_work = CONVERT(DATETIME, @str_year + '-05-04');
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --���ǂ��̓�
  SET @date_work = CONVERT(DATETIME, @str_year + '-05-05');
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�n�b�s�[�}���f�[
  If ((DATEPART(weekday, (CONVERT(DATETIME, @str_year + '-05-03'))) = 2) OR (DATEPART(weekday, (CONVERT(DATETIME, @str_year + '-05-04'))) = 2) OR (DATEPART(weekday, (CONVERT(DATETIME, @str_year + '-05-05'))) = 2))
  BEGIN
    SET @date_work = CONVERT(DATETIME, @str_year + '-05-06');
    EXECUTE @RTCD = sp_holiday_insert @date_work;
    IF (@RTCD = -1)
    BEGIN
      RETURN -1;
    END
  END

  --�C�̓��i7���̑�3�T���j���j
  SET @date_work = dbo.fn_getdate_dayofweek(@yyyy, 7, 3, 2);
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�R�̓�
  SET @date_work = CONVERT(DATETIME, @str_year + '-08-11');
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�h�V�̓��i9���̑�3�T���j���j
  SET @date_work = dbo.fn_getdate_dayofweek(@yyyy, 9, 3, 2);
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�����̋x���i�h�V�̓��ƏH���̓���1�������󂢂Ă���΁j
  IF (DAY(dbo.fn_getdate_dayofweek(@yyyy, 9, 3, 2)) = dbo.fn_getdate_syuubun(@yyyy))
  BEGIN
    SET @date_work = dbo.fn_getdate_dayofweek(@yyyy, 9, 3, 1);
    EXECUTE @RTCD = sp_holiday_insert @date_work;
    IF (@RTCD = -1)
    BEGIN
      RETURN -1;
    END
  END

  --�H���̓�
  SET @date_work = CONVERT(DATETIME, @str_year + '-09-' + CONVERT(VARCHAR, (dbo.fn_getdate_syuubun(@yyyy))));
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�̈�̓��i10���̑�2�T���j���j
  SET @date_work = dbo.fn_getdate_dayofweek(@yyyy, 10, 2, 2);
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�����̓�
  SET @date_work = CONVERT(DATETIME, @str_year + '-11-03');
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�h�V���ӂ̓�
  SET @date_work = CONVERT(DATETIME, @str_year + '-11-23');
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�V�c�a����
  SET @date_work = CONVERT(DATETIME, @str_year + '-12-23');
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�N��29��
  SET @date_work = CONVERT(DATETIME, @str_year + '-12-29');
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�N��30��
  SET @date_work = CONVERT(DATETIME, @str_year + '-12-30');
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  --�N��31��
  SET @date_work = CONVERT(DATETIME, @str_year + '-12-31');
  EXECUTE @RTCD = sp_holiday_insert @date_work;
  IF (@RTCD = -1)
  BEGIN
    RETURN -1;
  END

  RETURN 0;
END
GO
