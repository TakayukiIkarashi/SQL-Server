--�T�v�@�@�@�F�����Ɏw�肳�ꂽ�e���|�����e�[�u���ɋx�����Z�b�g���܂��i�U�֋x�����l�����܂��j
--�����@�@�@�F[@���t]�c�e���|�����e�[�u���ɒǉ�����x��
--�߂�l�@�@�F����I���Ȃ�0�A�����łȂ����-1
--���ʃZ�b�g�F��O�����������ꍇ�A�G���[���
IF (EXISTS(SELECT * FROM sys.objects WHERE (type = 'P') AND (name = 'sp_holiday_insert')))
BEGIN
  DROP PROCEDURE sp_holiday_insert;
END
GO

CREATE PROCEDURE sp_holiday_insert
  @���t DATETIME
AS
BEGIN
  SET NOCOUNT ON;

  --�����Ɏw�肳��Ă���x�����e���|�����e�[�u���ɒǉ����܂�
  DECLARE @sql_ins VARCHAR(8000);
  SET @sql_ins = '';
  SET @sql_ins = @sql_ins + ' IF (NOT EXISTS(SELECT * FROM �x�� WHERE ���t = ''' + CONVERT(VARCHAR, @���t, 120) + '''))';
  SET @sql_ins = @sql_ins + ' INSERT INTO';
  SET @sql_ins = @sql_ins + '   �x��';
  SET @sql_ins = @sql_ins + ' (';
  SET @sql_ins = @sql_ins + '   ���t';
  SET @sql_ins = @sql_ins + ' )';
  SET @sql_ins = @sql_ins + ' VALUES';
  SET @sql_ins = @sql_ins + ' (';
  SET @sql_ins = @sql_ins + '   ''' + CONVERT(VARCHAR, @���t, 120) + '''';
  SET @sql_ins = @sql_ins + ' )';

  BEGIN TRY
    EXECUTE (@sql_ins);
  END TRY
  BEGIN CATCH
    RETURN -1;
  END CATCH

  --�����Ɏw�肳��Ă�����t�����j���ł���΁A������U�֋x���Ƃ��ăe���|�����e�[�u���ɒǉ����܂�
  DECLARE @weekday INT;
  SET @weekday = DATEPART(weekday, @���t);
  IF (@weekday = 1)
  BEGIN
    DECLARE @month INT;
    SET @month = MONTH(@���t);

    DECLARE @day INT;
    SET @day = DAY(@���t);

    --�������A�O�����ɂ͐U�֋x��������܂���
    IF NOT ((@month = 1) AND (@day = 3))
    BEGIN
      SET @���t = DATEADD(day, 1, @���t);

      DECLARE @sql_ins2 VARCHAR(8000);
      SET @sql_ins2 = '';
      SET @sql_ins2 = @sql_ins2 + ' IF (NOT EXISTS(SELECT * FROM �x�� WHERE ���t = ''' + CONVERT(VARCHAR, @���t, 120) + '''))';
      SET @sql_ins2 = @sql_ins2 + ' INSERT INTO';
      SET @sql_ins2 = @sql_ins2 + '   �x��';
      SET @sql_ins2 = @sql_ins2 + ' (';
      SET @sql_ins2 = @sql_ins2 + '   ���t';
      SET @sql_ins2 = @sql_ins2 + ' )';
      SET @sql_ins2 = @sql_ins2 + ' VALUES';
      SET @sql_ins2 = @sql_ins2 + ' (';
      SET @sql_ins2 = @sql_ins2 + '   ''' + CONVERT(VARCHAR, @���t, 120) + '''';
      SET @sql_ins2 = @sql_ins2 + ' )';

      BEGIN TRY
        EXECUTE (@sql_ins2);
      END TRY
      BEGIN CATCH
        RETURN -1;
      END CATCH
    END
  END

  RETURN 0;
END
GO
