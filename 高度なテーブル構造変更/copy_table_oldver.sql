/*
********************************************************************************
�T�v�@�F����V�X�e���̃f�[�^�x�[�X�ɂ����āA����f�[�^�x�[�X����ʂ̃f�[�^�x�[�X
�@�@�@�@�ւ��ׂẴe�[�u���̓��e���R�s�[���܂��B
--------------------------------------------------------------------------------
�ڍׁ@�F�R�s�[���̃e�[�u���̗񖼂���A�񖼎w���INSERT���߂��쐬���A�R�s�[��̓�
�@�@�@�@��e�[�u���ɒǉ����܂��B
�@�@�@�@����V�X�e���̋��o�[�W�����̃f�[�^�x�[�X����A���s�o�[�W�����̃f�[�^�x�[
�@�@�@�@�X�ւ̃f�[�^�ڍs�̍ۂɎg�p���܂��B���s�o�[�W�����ł͐V���ȃJ��������
�@�@�@�@������Ă���ꍇ�ɂ��Ή��ł��܂��B
--------------------------------------------------------------------------------
�g�����F�R�s�[���f�[�^�x�[�X����[db1]�A�R�s�[��f�[�^�x�[�X����[db2]�ƂȂ��Ă���
�@�@�@�@���B������A���ꂼ����ɍ��킹���������f�[�^�x�[�X���ɒu�����A����SQL
�@�@�@�@�����s���܂��Bdb1�f�[�^�x�[�X�̂��ׂẴe�[�u���̓��e���Adb2�f�[�^�x�[�X
�@�@�@�@�̃e�[�u���ɃR�s�[����܂��B���o�[�W�����ɂ̂ݑ��݂���e�[�u�������݂���
�@�@�@�@�ꍇ�A���Y�e�[�u���̂݃G���[�ƂȂ�APRINT���Ńe�[�u�������o�͂��܂��B
********************************************************************************
*/

--���ʌ�����\�����Ȃ�
SET NOCOUNT ON;

/*
==============================
�ϐ���`
==============================
*/
--SQL�g�ݗ��ĕ�����
DECLARE @sql VARCHAR(MAX);

/*
==============================
������
==============================
*/
--�\���J�[�\���쐬
DECLARE [cur�\��] CURSOR FOR
SELECT [object_id], [name] FROM [db1].[sys].[tables];

--�\���J�[�\�����Ŏg�p����ϐ��̐錾
DECLARE @object_id INT;
SET @object_id = -1;
DECLARE @�\�� VARCHAR(100);
SET @�\�� = '';

--�\���J�[�\�����J���A1���ڂ̃f�[�^���擾
OPEN [cur�\��];
FETCH [cur�\��] INTO @object_id, @�\��;

--�\���J�[�\���̃f�[�^��1��������
WHILE (@@fetch_status = 0)
BEGIN
    --�\��object_id�ɊY������񖼃J�[�\���쐬
    DECLARE [cur��] CURSOR FOR
    SELECT [name], [is_identity] FROM [db1].[sys].[columns]
    WHERE [object_id] = @object_id;

    --�񖼃J�[�\�����Ŏg�p����ϐ��̐錾
    DECLARE @�� VARCHAR(100);
    SET @�� = '';
    DECLARE @is_identity INT;
    SET @is_identity = 0;

    --AUTO_INCREMENT�񂩂ǂ����𔻒f����t���O�ϐ���錾
    DECLARE @�����t�� INT;
    SET @�����t�� = 0;

    --INSERT���߂��쐬����ۂ̗񖼂�񋓂���ϐ���錾
    DECLARE @�񖼗� VARCHAR(MAX);
    SET @�񖼗� = '';

    --�񖼃J�[�\�����J���A1���ڂ̃f�[�^���擾
    OPEN [cur��];
    FETCH [cur��] INTO @��, @is_identity;

    --�񖼃J�[�\���̃f�[�^��1��������
    WHILE (@@fetch_status = 0)
    BEGIN
        --AUTO_INCREMENT��̏ꍇ
        IF (@is_identity = 1) AND (@�����t�� = 0)
        BEGIN
            --AUTO_INCREMENT��t���O��ON
            SET @�����t�� = 1;
        END

        --2���߈ȍ~�ɗ񖼂�ǉ�����Ȃ�J���}��ǋL
        IF (@�񖼗� <> '')
        BEGIN
            SET @�񖼗� = @�񖼗� + ',';
        END

        --�񖼂�ǋL
        SET @�񖼗� = @�񖼗� + @��;

        --���̃��R�[�h��
        FETCH [cur��] INTO @��, @is_identity;
    END

    --�񖼃J�[�\������A���
    CLOSE [cur��];
    DEALLOCATE [cur��];

    --�G���[�t���O�ϐ���錾���A�����l����
    DECLARE @err�L INT;
    SET @err�L = 0;

    --�R�s�[��̃e�[�u������f�[�^��S�폜
    SET @sql = '';
    SET @sql = @sql + ' DELETE FROM [db2].[dbo].[' + @�\�� + '];';
    BEGIN TRY
        EXECUTE (@sql);
    END TRY
    BEGIN CATCH
        --�폜�Ɏ��s�����玸�s�����\����\�����A�G���[�t���O��ON
        PRINT @sql;
        SET @err�L = 1;
        PRINT '�폜���s�F' + @�\��;
    END CATCH

    --�񖼂̗񋓂��I������e�[�u�����R�s�[
    IF (@err�L = 0)
    BEGIN
        SET @sql = '';

        --AUTO_INCREMENT��̏ꍇ
        IF (@�����t�� = 1)
        BEGIN
            --IDENTITY_INSERT������
            SET @sql = @sql + 'SET IDENTITY_INSERT [db2].[dbo].[' + @�\�� + '] ON;';
        END

        --INSERT�R�}���h
        SET @sql = @sql + ' INSERT INTO [db2].[dbo].[' + @�\�� + '] (' + @�񖼗� + ')';
        SET @sql = @sql + ' SELECT ' + @�񖼗�
        SET @sql = @sql + ' FROM [db1].[dbo].[' + @�\�� + '];';

        --AUTO_INCREMENT��̏ꍇ
        IF (@�����t�� = 1)
        BEGIN
            --IDENTITY_INSERT���ĊJ
            SET @sql = @sql + 'SET IDENTITY_INSERT [db2].[dbo].[' + @�\�� + '] OFF;';
        END

        --���R�[�h��1���ǉ�
        BEGIN TRY
            EXECUTE (@sql);
        END TRY
        BEGIN CATCH
            --�ǉ��Ɏ��s�����玸�s�����\����\��
            PRINT @sql;
            PRINT '�ǉ����s�F' + @�\��;
        END CATCH
    END

    --���̃��R�[�h��
    FETCH [cur�\��] INTO @object_id, @�\��;
END

--�\���J�[�\������A���
CLOSE [cur�\��];
DEALLOCATE [cur�\��];
